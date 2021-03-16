#!/bin/sh

WWW_ROOT="~/www"

FG_YELLOW='\033[00;33m'
FG_BLUE='\033[00;34m'
FG_GREEN='\033[00;32m'
FG_LYELLOW='\033[01;33m'
FG_LBLUE='\033[01;34m'

#Reset text color to default
FG_NO_COLOR='\033[00;39m'

mkdir -p "$WWW_ROOT"

IP_LIST=$(ip addr show | grep -w "inet" | sed -e 's/^[ \t]*inet//' | sed 's/\/.*//' |     sed '/127.0.0*/d')
echo -e "$FG_LYELLOW\nAvailable IP addresses:\n"
echo -e "$FG_GREEN$IP_LIST$FG_NO_COLOR"
echo ""
#Run simpple server
/usr/bin/python3 -m http.server 8888 -d "$WWW_ROOT" -b 0.0.0.0

