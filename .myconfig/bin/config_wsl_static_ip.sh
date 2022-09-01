#!/bin/bash


WSL_NET_CONFIG_FILE="/etc/sysconfig/wsl-net-cfg"

help()
{
    echo "Usage: config_wsl_static_ip.sh ipaddrandrangeCIDR 
               [ -f | --fqdn  hostFQDN] 
               [ -d | --dns dnsIP ]
               [ -g | --gateway gatewayIP]
               [ -h | --help  ]"
    exit 2
}
#$1 is IP and mask, in CIDR
#$2 can be fqdn

#we expect dns on same addr as gw and gw at ip x.x.x.1 from IP range


POSITIONAL_ARGS=()
MODIFY_FQDN="yes"
while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--fqdn)
      HOST_FQDN="$2"
      if [ -z "$2" ]; then
          echo "Value for parameter \"$1\" is missing!"
          exit 1
      fi 
      shift # past argument
      shift # past value
      ;;
    -d|--dns)
      DNS_IP="$2"
      if [ -z "$2" ]; then
          echo "Value for parameter \"$1\" is missing!"
          exit 1
      fi 
      shift # past argument
      shift # past value
      ;;
    -g|--gateway)
      GW_IP="$2"
      if [ -z "$2" ]; then
          echo "Value for parameter \"$1\" is missing!"
          exit 1
      fi 
      shift # past argument
      shift # past value
      ;;
    -n|--nofqdn)
      MODIFY_FQDN="no"
      shift # past argument with no value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z "$1" ]; then
    echo "IP address and range must be specified!!"
    exit 1
fi

if [ -f "$BASH_PERSONAL_CFG_DIR/functions.sh" ]; then
   . "$BASH_PERSONAL_CFG_DIR/functions.sh"
else
    echo "External function definitions not available. Can't continue!!"
    exit 1
fi

if [ ! -f "$PERSONAL_CFG_DIR/templates/set_wsl_static_ip.sh" ]; then
    echo "The template file \"set_wsl_static_ip.sh\" doesn't exist!"
    exit 1
fi

parse_cidr_ip $1



if  [ -z "$CIDR_PARSED_IP" ] || [ -z "$CIDR_PARSED_MASKLEN" ] || [ -z "$CIDR_PARSED_NETWORK" ]; then
    echo "IP/MASK vaue is invalid. Can't continue!!"
    exit 1
fi
if [ -z "$GW_IP" ]; then
    #gw is network.1
    GW_IP=${CIDR_PARSED_IP%.*}.1
fi

if [ -z "$DNS_IP" ]; then
    DNS_IP="$GW_IP"
fi

if [ "$CIDR_PARSED_MASKLEN" -gt "32" ] || [ "$CIDR_PARSED_MASKLEN" -lt "0" ]; then
    echo ": Mask bits count $CIDR_PARSED_MASKLEN is not in range 0-32"
    exit 1
fi
if ! validate_ip "$GW_IP"; then
    echo "Gateway ipaddress: $GW_IP is invalid"
    exit 1
fi

if ! validate_ip "$DNS_IP"; then
    echo "DNS Server ipaddress: $GW_IP is invalid"
    exit 1
fi

CONFIG_FILE_CONTENT="WSL_IP=\"$IPADDR/$CIDR_PARSED_MASKLEN\""$'\n'
CONFIG_FILE_CONTENT="$CONFIG_FILE_CONTENT"$"WSL_GW=\"$GW_IP\""
CONFIG_FILE_CONTENT="$CONFIG_FILE_CONTENT"$'\n'
CONFIG_FILE_CONTENT="$CONFIG_FILE_CONTENT"$"WSL_DNS=\"$DNS_IP\""
CONFIG_FILE_CONTENT="$CONFIG_FILE_CONTENT"$'\n'

if is_true "$MODIFY_FQDN"; then
    if [ -z "$HOST_FQDN" ]; then
      TMP_STR=$(powershell.exe '(Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain')
      HOST_FQDN=$( trim "$TMP_STR")
    fi  
    CONFIG_FILE_CONTENT="$CONFIG_FILE_CONTENT"$"WSL_HOST_FQDN=\"$HOST_FQDN\""
    CONFIG_FILE_CONTENT="$CONFIG_FILE_CONTENT"$'\n'
fi

sudo cp "$PERSONAL_CFG_DIR/templates/set_wsl_static_ip.sh" "/bin/set_wsl_static_ip.sh"
sudo chmod +x "/bin/set_wsl_static_ip.sh"
sudo echo "$CONFIG_FILE_CONTENT" > "$WSL_NET_CONFIG_FILE"




