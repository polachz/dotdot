#!/bin/bash

sudo dnf install make g++

cd ~

wget -O - https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion"  ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 14
nvm use 14

npm install react react-dom
npm install -g gatsby-cli


