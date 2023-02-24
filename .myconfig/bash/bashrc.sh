if [ -d "$HOME/.myconfig" ]; then
   export PERSONAL_CFG_DIR="$HOME/.myconfig"
   #add personal config bin dir to path
   if [ -d "$PERSONAL_CFG_DIR/bin" ]; then
      PATH="$PERSONAL_CFG_DIR/bin:$PATH"
   fi
   if [ -d "$PERSONAL_CFG_DIR/templates" ]; then
      export PERSONAL_TEMPLATES_DIR="$PERSONAL_CFG_DIR/templates"
   fi
   export PERSONAL_BASRC_D_DIR="$PERSONAL_BASH_CFG_DIR/bashrc.d"
fi

if [ -f "$PERSONAL_BASH_CFG_DIR/functions.sh" ]; then
   . "$PERSONAL_BASH_CFG_DIR/functions.sh"
fi

if [ -f "$PERSONAL_BASH_CFG_DIR/aliases" ]; then
   . "$PERSONAL_BASH_CFG_DIR/aliases"
fi

if [ -f "$PERSONAL_BASH_CFG_DIR/colours.sh" ]; then
   . "$PERSONAL_BASH_CFG_DIR/colours.sh"
fi

detect_wsl_subsystem

if [ $WSL_VERSION -eq 2 ]; then
   if [ -f "$PERSONAL_BASH_CFG_DIR/pageant.sh" ]; then
      . "$PERSONAL_BASH_CFG_DIR/pageant.sh"
   fi

   if [ -f "/bin/set_wsl_static_ip.sh" ]; then
      wsl.exe -u root -d $(hostname) /bin/set_wsl_static_ip.sh
   fi
fi

if [ -d ~/.nvm ]; then
   if [ -f "$PERSONAL_BASH_CFG_DIR/nvm.sh"  ]; then
      . "$PERSONAL_BASH_CFG_DIR/nvm.sh"
   fi
fi

# Dynamically defined aliases and functions
if [ -d "$PERSONAL_BASRC_D_DIR" ]; then
	for rc in "$PERSONAL_BASRC_D_DIR/*"; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

## To make Kerberos and  Python happy -> to use global ca file
export REQUESTS_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt

