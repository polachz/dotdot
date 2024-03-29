#/bin/sh
#using https://github.com/amix/vimrc
VIM_RUNTIME_AMIX_DIR="$HOME/.vim_runtime"

if [ ! -d "$VIM_RUNTIME_AMIX_DIR" ]; then
   #not cloned yet -> new install -> clone
   echo "Cloning amix vim configuration..."
   git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_RUNTIME_AMIX_DIR" > /dev/null 2>&1
#   sed -i "s~.*tlib https://github.com/vim-scripts/tlib.*~tlib https://github.com/tomtom/tlib_vim~g" "$VIM_RUNTIME_AMIX_DIR/update_plugins.py"
   sh "$VIM_RUNTIME_AMIX_DIR/install_awesome_vimrc.sh"
else
   echo "Amix vim configuration already installed. Updating..."
   git  -C "$VIM_RUNTIME_AMIX_DIR" pull > /dev/null 2>&1
#   sed -i "s~.*tlib https://github.com/vim-scripts/tlib.*~tlib https://github.com/tomtom/tlib_vim~g" "$VIM_RUNTIME_AMIX_DIR/update_plugins.py"
   if command -v python3 &> /dev/null; then
      python3 "$VIM_RUNTIME_AMIX_DIR/update_plugins.py" > /dev/null 2>&1
   else 
      if command -v python &> /dev/null; then
         python "$VIM_RUNTIME_AMIX_DIR/update_plugins.py" > /dev/null 2>&1
      else
         echo "ERROR - No python interpreter found !!!!"
      fi
   fi
fi


if [ ! -f ~/.vim_runtime/my_configs.vim  ]; then
   ln -s ~/.myconfig/vim/my_configs.vim ~/.vim_runtime/my_configs.vim
fi

