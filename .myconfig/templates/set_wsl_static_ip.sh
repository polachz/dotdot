#!/bin/bash

#$1 can be path to config file, then it overrides default
#if $1 is empty then default config file is used

WSL_NET_CONFIG_FILE="/etc/sysconfig/wsl-net-cfg"

check_line_presence () {
#params line_search_pattern, file_where_to_search
   local GREP_FOUND_PATTERN=$(grep "$1" "$2")
   if [ -z "$GREP_FOUND_PATTERN" ]; then
      return 1
   else
      return 0
   fi
}

replace_or_add_line () {
#params line_search_pattern, new_line_value file_where_to_replace_or_add
   if check_line_presence "$1" "$3"; then
      #line present. replace, use ~ as delimiter instead / due filenames
      sed -i "/^#/!s~.*$1.*~$2~g" "$3"
   else
      #add line at the end of file
      echo "$2" >> "$3"
   fi
}

ipv4_tonum() {
    if [[ $1 =~ ([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+) ]]; then
        addr=$(( (${BASH_REMATCH[1]} << 24) + (${BASH_REMATCH[2]} << 16) + (${BASH_REMATCH[3]} << 8) + ${BASH_REMATCH[4]} ))
        eval "$2=\$addr"
    fi
}
ipv4_toaddr() {
    b1=$(( ($1 & 0xFF000000) >> 24))
    b2=$(( ($1 & 0xFF0000) >> 16))
    b3=$(( ($1 & 0xFF00) >> 8))
    b4=$(( $1 & 0xFF ))
    eval "$2=\$b1.\$b2.\$b3.\$b4"
}

parse_cidr_ip() {
   if [[ $1 =~ ^([0-9\.]+)/([0-9]+)$ ]]; then
      # CIDR notation
      IPADDR=${BASH_REMATCH[1]}
      NETMASKLEN=${BASH_REMATCH[2]}
      zeros=$((32-NETMASKLEN))
      NETMASKNUM=0
      for (( i=0; i<$zeros; i++ )); do
           NETMASKNUM=$(( (NETMASKNUM << 1) ^ 1 ))
      done
      NETMASKNUM=$((NETMASKNUM ^ 0xFFFFFFFF))
      ipv4_toaddr $NETMASKNUM NETMASK
   else
      IPADDR=${1:-192.168.1.1}
      NETMASK=${2:-255.255.255.0}
   fi

   ipv4_tonum $IPADDR IPADDRNUM
   ipv4_tonum $NETMASK NETMASKNUM

   # The logic to calculate network and broadcast
   INVNETMASKNUM=$(( 0xFFFFFFFF ^ NETMASKNUM ))
   NETWORKNUM=$(( IPADDRNUM & NETMASKNUM ))
   BROADCASTNUM=$(( INVNETMASKNUM | NETWORKNUM ))

   ipv4_toaddr $NETWORKNUM NETWORK
   ipv4_toaddr $BROADCASTNUM BROADCAST

}

if [ ! -z "$1" ]; then
   WSL_NET_CONFIG_FILE="$1"
fi

if [ ! -f "$WSL_NET_CONFIG_FILE" ]; then
    #No config, then no requirement to modify networking
    exit 0
fi

#read config values
. "$WSL_NET_CONFIG_FILE"


parse_cidr_ip $WSL_IP

if [ -z "$WSL_IP" ] || [ -z "$WSL_GW" ] || [ -z "$IPADDR" ] || [ -z "$NETMASKLEN" ] || [ -z "$BROADCAST" ]; then

    echo "Some config value is empty or invalid!!"
    echo "Unable to set static ip to the WSL instance"
fi


#modify DNS server IP
if [ ! -z "$WSL_DNS" ]; then
#    echo "modifying DNS Server"
    sudo bash -c "$(declare -f ); replace_or_add_line nameserver 'nameserver $WSL_GW' /etc/resolv.conf"
fi

if [ ! -z "$WSL_HOST_FQDN" ]; then
#    echo "modifying Hosts"
    sudo bash -c "$(declare -f ); replace_or_add_line $WSL_HOST_FQDN '$WSL_GW      $WSL_HOST_FQDN' /etc/hosts"
fi
# Fix network adapter in WSL
sudo ip addr del $(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | head -n 1) dev eth0
sudo ip addr add $(echo "$IPADDR/$NETMASKLEN broadcast $BROADCAST dev eth0")
sudo ip route $(echo "add 0.0.0.0/0 via $WSL_GW dev eth0")


