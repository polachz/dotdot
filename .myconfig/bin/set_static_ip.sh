#!/bin/bash

GW_IP="172.21.21.1"
BCAST_IP="172.21.21.255"
PREFIX="24"
WSL_IP="172.21.21.100"

if [ -f "$BASH_PERSONAL_CFG_DIR/functions.sh" ]; then
    . "$BASH_PERSONAL_CFG_DIR/functions.sh"
fi

PKPK=$(echo "$GW_IP/$PREFIX broadcast $BCAST_IP dev eth0")

# Fix network adapter in WSL
sudo ip addr del $(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | head -n 1) dev eth0
sudo ip addr add $(echo "$WSL_IP/$PREFIX broadcast $BCAST_IP dev eth0")
sudo ip route $(echo "add 0.0.0.0/0 via $GW_IP dev eth0")

#modify DNS server IP

#export -f replace_or_add_line_strict
sudo bash -c "$(declare -f ); replace_or_add_line_strict nameserver 'nameserver $GW_IP' /etc/resolv.conf"
# Fix network adapter configuration in windows

CURRENT_GW_IP=$(powershell.exe "Get-NetAdapter \"vEthernet (WSL)\" | Get-NetIPAddress | Select -ExpandProperty IPAddress")

CURRENT_GW_IP=$(trim "$CURRENT_GW_IP")

#modify windows switch only if ip is diferent
if [ $CURRENT_GW_IP != $GW_IP ]; then

COMMAND_STRING="-noexit -c Get-NetAdapter 'vEthernet (WSL)' | Get-NetIPAddress | Remove-NetIPAddress -Confirm:\`\$False; New-NetIPAddress -IPAddress $GW_IP -PrefixLength $PREFIX -InterfaceAlias 'vEthernet (WSL)'; Get-NetNat | ? Name -Eq WSLNat | Remove-NetNat -Confirm:\`\$False; New-NetNat -Name WSLNat -InternalIPInterfaceAddressPrefix $GW_IP/$PREFIX;"

powershell.exe Start-Process -Verb runas powershell.exe -ArgumentList \"$(echo "$COMMAND_STRING")\"

fi

# SUPER OPTIONAL: Update display (may be different on your machine!)
export DISPLAY=$(ip route | awk '/^default/{print $3; exit}'):0

