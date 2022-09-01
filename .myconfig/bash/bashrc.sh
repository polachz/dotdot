if [ -d "$HOME/.myconfig" ]; then
   export PERSONAL_CFG_DIR="$HOME/.myconfig"
   #add personal config bin dir to path
   if [ -d "$PERSONAL_CFG_DIR/bin"  ]; then
      PATH="$PERSONAL_CFG_DIR/bin:$PATH"
   fi
fi

if [ -f "$BASH_PERSONAL_CFG_DIR/functions.sh" ]; then
   . "$BASH_PERSONAL_CFG_DIR/functions.sh"
fi

if [ -f "$BASH_PERSONAL_CFG_DIR/aliases" ]; then
   . "$BASH_PERSONAL_CFG_DIR/aliases"
fi

if [ -f "$BASH_PERSONAL_CFG_DIR/colours.sh" ]; then
   . "$BASH_PERSONAL_CFG_DIR/colours.sh"
fi

detect_wsl_subsystem

if [ $WSL_VERSION -eq 2 ]; then
   if [ -f "$BASH_PERSONAL_CFG_DIR/pageant.sh" ]; then
      . "$BASH_PERSONAL_CFG_DIR/pageant.sh"
   fi

   if [ -f "/bin/set_wsl_static_ip.sh" ]; then
      wsl.exe -u root -d $(hostname) /bin/set_wsl_static_ip.sh
   fi 
fi

if [ -d ~/.nvm ]; then
   if [ -f "$BASH_PERSONAL_CFG_DIR/nvm.sh"  ]; then
      . "$BASH_PERSONAL_CFG_DIR/nvm.sh"
   fi
fi

if is_true $WSL_PRESENT; then
  cd ~
fi

