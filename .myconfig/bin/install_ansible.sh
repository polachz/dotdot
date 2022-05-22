#!/bin/bash

#install ansible and all necessary references

sudo dnf install -y ansible
sudo dnf -y install gcc python-devel krb5-devel krb5-libs krb5-workstation

pip install pywinrm

