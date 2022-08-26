#!/bin/bash

if [ -f "$BASH_PERSONAL_CFG_DIR/functions.sh" ]; then
    . "$BASH_PERSONAL_CFG_DIR/functions.sh"
fi

# Fix network adapter in WSL
sudo ip addr del $(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | head -n 1) dev eth0
sudo ip addr add 172.21.199.208/20 broadcast 172.21.207.255 dev eth0
sudo ip route add 0.0.0.0/0 via 172.21.192.1 dev eth0

#modify DNS server IP

#export -f replace_or_add_line_strict
sudo bash -c "$(declare -f ); replace_or_add_line_strict nameserver 'nameserver 172.21.192.1' /etc/resolv.conf"
# Fix network adapter configuration in windows
powershell.exe Start-Process -Verb runas powershell.exe -ArgumentList \'$(echo '-noexit -c Get-NetAdapter \"vEthernet (WSL)\" | Get-NetIPAddress | Remove-NetIPAddress -Confirm:$False; New-NetIPAddress -IPAddress 172.21.192.1 -PrefixLength 20 -InterfaceAlias \"vEthernet (WSL)\"; Get-NetNat | ? Name -Eq WSLNat | Remove-NetNat -Confirm:$False; New-NetNat -Name WSLNat -InternalIPInterfaceAddressPrefix 172.21.192.0/20;')\'

# SUPER OPTIONAL: Update display (may be different on your machine!)
export DISPLAY=$(ip route | awk '/^default/{print $3; exit}'):0

