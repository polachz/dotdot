#!/bin/bash

if [ -d "$HOME/blog" ]; then
    echo "Blog folder already exists. Blog seems to be installed. Exiting"
    exit 1
fi

if [ ! -d "$HOME/.nvm" ]; then
     echo "Installing NVM and gatsby-cli..."
     #Instal nvm ang gatsby cli - we have this in the path in my environment
     #then call it directly without any magic
     gatsby-cli_install.sh
fi

#now clone blog repository
git clone --recurse-submodules git@github.com:polachz/blog.git "$HOME"

#switch to blog directory and install gatsby
cd "$HOME/blog"

npm install gatsby

#now try to open VS code with blog folder
code "$HOME/blog"

#and run here
# gatsby develop

