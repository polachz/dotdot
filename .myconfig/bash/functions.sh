#/bin/sh
is_true () {
   if [ $1 -ne 0 ] 2> /dev/null; then
      return 0
   fi
   if [ "$1" = "yes" ]; then
      return 0
   fi
   if [ "$1" = 'true' ]; then
      return 0
   fi
   return 1
}

is_false () {
   if [ $1 -eq 0 ] 2> /dev/null; then
      return 0
   fi
   if [ $1 = 'no' ]; then
      return 0
   fi
   if [ $1 = 'false' ]; then
      return 0
   fi
   return 1
}

file_exist () {
   if [ -f $1 ]; then
      #exit code 0 is success in the BASH
      return 0
   else
      #exit <>0 is error (false) in bash
      return 1
   fi
}

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

replace_or_add_line_strict () {
#params line_search_pattern, new_line_value _file_where_to_replace_or_add
#Line must exactly beginning with line_search_pattern to be processed
#useful to change obly uncommented lines (not beginning by #)
   if check_line_presence "$1" "$3"; then
      #line present. replace
      sed -i "/^#/!s~$1.*~$2~g" "$3"
   else
      #add line at the end of file
      echo "$2" >> "$3"
   fi
}

replace_line () {
#params line_search_pattern, new_line_value _file_where_to_replace_or_add
   if check_line_presence "$1" "$3"; then
      #line present. replace
      sed -i "s~.*$1.*~$2~g" "$3"
   fi
}

# Running under WSL (Windows Subsystem for Linux)?
detect_wsl_subsystem () {

   if cat /proc/version | grep -iq "Microsoft"; then
      export WSL_PRESENT='true'
      if [ -d "/run/WSL" ]; then
         export WSL_VERSION=2
      else
         export WSL_VERSION=1
      fi
      return 0
   else
      export WSL_PRESENT='false'
      export WSL_VERSION=0
   fi
   return 1
}
is_binary_installed () {
   command -v $1 > /dev/null 2>&1
}

install_binary () {
#params binary_to_install
   local PKG_MGR=""
   if command -v 'dnf' > /dev/null; then
      PKG_MGR='dnf'
   elif command -v 'apt-get' > /dev/null; then
      PKG_MGR='apt-get'
   elif command -v 'yum' > /dev/null; then
      PKG_MGR='yum'
   fi
   if [ -z $PKG_MGR ]; then
      echo "ERROR: Unknown PKG mananger. Unable to install"
      return 1
   fi

   sudo  $PKG_MGR install $1 > /dev/null 2>&1

}

trim () {
    local var="$1"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo "$var"
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

    export CIDR_PARSED_IP=$IPADDR
    export CIDR_PARSED_MASKLEN=$NETMASKLEN
    export CIDR_PARSED_NETWORK=$NETWORK
    export CIDR_PARSED_MASK=$NETMASK
    export CIDR_PARSED_BROADCAST=$BROADCAST
 }

validate_ip() {
   if expr "$1" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
      IFS=.
      set $1
      for quad in 1 2 3 4; do
         if eval [ \$$quad -gt 255 ]; then
            return 1
         fi
      done
      #Ip is ok
      return 0
   else
      return 1
   fi
}

