#/bin/sh

RESOURCE_FILE_TO_MODIFY="$HOME/.bashrc"

BOOTSTRAP_SCRIPT_PATH=$(readlink -f "$0")
BOOTSTRAP_DIR=$(dirname "$BOOTSTRAP_SCRIPT_PATH")
if [ ! -d "$BOOTSTRAP_DIR" ]; then BOOTSTRAP_DIR="$PWD"; fi

if [ -d ~/.myconfig/bash  ]; then
   BASH_PERSONAL_CFG_DIR="$HOME/.myconfig/bash"
else
   echo "Unable to find bash config dir !!"
   exit 1
fi
if [ -f "$BASH_PERSONAL_CFG_DIR/functions.sh" ]; then
    . "$BASH_PERSONAL_CFG_DIR/functions.sh"
else
   echo "Unable to include functions.sh file. Bootstrap failed"
   exit 1
fi

echo "Checking $RESOURCE_FILE_TO_MODIFY presence..."

if [ -f "$RESOURCE_FILE_TO_MODIFY" ]; then
   if ! check_line_presence 'Inserted by YADM bootstraping code' $RESOURCE_FILE_TO_MODIFY; then
      echo '#'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo '# Inserted by YADM bootstraping code to include personal config files'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo '#'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo ''  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo 'if [ -d ~/.myconfig/bash ]; then' >>  "$RESOURCE_FILE_TO_MODIFY"
      echo '   BASH_PERSONAL_CFG_DIR="$HOME/.myconfig/bash"' >>  "$RESOURCE_FILE_TO_MODIFY"
      echo 'fi'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo '   '  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo 'if [ -f "$BASH_PERSONAL_CFG_DIR/bashrc.sh" ]; then'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo '   . "$BASH_PERSONAL_CFG_DIR/bashrc.sh"'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo 'fi'  >>  "$RESOURCE_FILE_TO_MODIFY"
      echo ''  >>  "$RESOURCE_FILE_TO_MODIFY"
   else
      echo "INFO: The file $RESOURCE_FILE_TO_MODIFY already bootstraped!"
   fi
else
   echo "ERROR: The file $RESOURCE_FILE_TO_MODIFY doesn't exist !!! Bash not installed???"
fi

if [ -f "$BOOTSTRAP_DIR/vim_bootstrap.sh"  ]; then
   . "$BOOTSTRAP_DIR/vim_bootstrap.sh"
else
   echo "ERROR: vim_bootstrap.sh file is missing!!!"
fi

detect_wsl_subsystem

if [ $WSL_VERSION -eq 2 ]; then
   if [ -f "$BOOTSTRAP_DIR/wsl2_bootstrap.sh" ]; then
      . "$BOOTSTRAP_DIR/wsl2_bootstrap.sh"
   else
      echo "WARNING: WSL2 detected, but bootstrap script wsl2_bootstrap.sh can not be found!!"
   fi
fi

echo "Updating the yadm repo origin URL"
#in some cases, uncomment this:
#yadm remote set-url origin "https://github.com/polachz/dotdot.git"
#but in main cases, we are using SSH
yadm remote set-url origin "git@github.com:polachz/dotdot.git"

