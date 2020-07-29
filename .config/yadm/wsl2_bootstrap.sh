#/bin/sh

SSH_HOME_DIR="$HOME/.ssh"
WSL_CONF_FILE="/etc/wsl.conf"
PAGEANT_EXE_URL="https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.2.0/wsl2-ssh-pageant.exe"

if [ ! -d "$SSH_HOME_DIR" ]; then
   mkdir  "$SSH_HOME_DIR"
   chmod 750 "$SSH_HOME_DIR"
fi

echo "Checking wsl2-pageant binary presence..."

if [ ! -f "$SSH_HOME_DIR/wsl2-ssh-pageant.exe" ]; then
   echo "Downloading wsl2-pageant binary..."
   wget -P "$SSH_HOME_DIR" "$PAGEANT_EXE_URL" > /dev/null 2>&1

   if [ ! -f "$SSH_HOME_DIR/wsl2-ssh-pageant.exe" ]; then
      echo "WARNING: wsl2-ssh-pageant.exe hasn't been downloaded. Pageant WSL support broken!"
   else
      chmod 750 "$SSH_HOME_DIR/wsl2-ssh-pageant.exe"
   fi
fi

echo "Checking socat presence...."

if ! is_binary_installed 'socat'; then
   echo "Socat is not installed, going to install it..."
   install_binary socat
   if ! is_binary_installed 'socat'; then
      echo "ERROR: Socat ws not installed!!!!"
   fi
fi

#create wsl.conf
if [ -f "$WSL_CONF_FILE" ]; then
   if ! check_line_presence '[user]' $WSL_CONF_FILE; then
      echo "INFO: $WSL_CONF_FILE exists, but user section not found. creating..."
      sudo  echo "[user]" >> $WSL_CONF_TMP
      sudo  echo "default=$USER" >> $WSL_CONF_TMP
   else
      if ! check_line_presence "default=$USER" $WSL_CONF_FILE; then
         echo "WARNING: The file $WSL_CONF_FILE exists."
         echo "Unable to modify automatically. Please Merge changes yourself"
      fi
   fi
else
   echo "Creating $WSL_CONF_FILE ..."
   WSL_CONF_TMP=$( mktemp )
   echo "[user]" >> $WSL_CONF_TMP
   echo "default=$USER" >> $WSL_CONF_TMP
   sudo mv $WSL_CONF_TMP $WSL_CONF_FILE
   sudo chown 0:0  $WSL_CONF_FILE
   sudo chmod 644  $WSL_CONF_FILE
   if [ ! -f "$WSL_CONF_FILE" ]; then
      echo "ERROR - Unable to create $WSL_CONF_FILE !!"
   fi
fi



