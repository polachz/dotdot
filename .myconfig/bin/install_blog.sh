#!/bin/bash

if [ -d "$HOME/blog" ]; then
    echo "Blog folder already exists. Blog seems to be installed. Exiting"
    exit 1
fi

if [ ! -d "$HOME/.nvm" ]; then
     echo "Installing NVM and gatsby-cli..."
     #Instal nvm ang gatsby cli - we have this in the path in my environment
     #then call it directly without any magic
     install_gatsby-cli.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion"  ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#now clone blog repository
git clone --recurse-submodules git@github.com:polachz/blog.git "$HOME/blog"

#switch to blog directory and install gatsby
cd "$HOME/blog"

npm install gatsby

detect_wsl_subsystem

if [ $WSL_VERSION -eq 2 ]; then
   #now try to open VS code with blog folder
   code "$HOME/blog"
fi

#and run here
# gatsby develop
echo "to develop the blog, run:"
echo "cd ~/blog"
echo "gatsby develop"

