#/bin/sh
#using https://github.com/amix/vimrc
VIM_RUNTIME_AMIX_DIR="$HOME/.vim_runtime"

if [ ! -d "$VIM_RUNTIME_AMIX_DIR" ]; then
   #not cloned yet -> new install -> clone
   echo "Cloning amix vim configuration..."
   git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_RUNTIME_AMIX_DIR" > /dev/null 2>&1
   sh "$VIM_RUNTIME_AMIX_DIR/install_awesome_vimrc.sh"
else
   echo "Amix vim configuration already installed. Updating..."
   git  -C "$VIM_RUNTIME_AMIX_DIR" pull > /dev/null 2>&1
   python3 "$VIM_RUNTIME_AMIX_DIR/update_plugins.py" > /dev/null 2>&1
fi

if [ ! -f ~/.vim_runtime/my_configs.vim  ]; then
   ln -s ~/.myconfig/vim/my_configs.vim ~/.vim_runtime/my_configs.vim
fi

