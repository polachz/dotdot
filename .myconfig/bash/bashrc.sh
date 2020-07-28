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
fi

if is_true $WSL_PRESENT; then
  cd ~
fi

