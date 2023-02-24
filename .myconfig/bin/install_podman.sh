#!/bin/bash

#include common functions 
. "$PERSONAL_BASH_CFG_DIR/functions.sh"

sudo dnf install -y podman podman-remote
systemctl enable --now --user podman.socket

current_user_uuid=$(id -u)

copy_template_file_to_bashrc_d 'podman.sh'

apply_var_to_template_in_bashrc_d 'podman.sh' 'USER_UUID' $current_user_uuid
