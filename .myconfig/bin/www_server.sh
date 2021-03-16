#!/bin/sh
mkdir -p ~/www
/usr/bin/python3 -m http.server 8888 -d ~/www -b 0.0.0.0

