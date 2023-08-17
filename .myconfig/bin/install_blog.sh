#!/bin/bash

if [ -d "$HOME/blog" ]; then
    echo "Blog folder already exists. Blog seems to be installed. Exiting"
    exit 1
fi

sudo install hugo

#now clone blog repository
git clone --recurse-submodules git@github.com:polachz/blog.git "$HOME/blog"

#switch to blog directory and install gatsby
cd "$HOME/blog"

detect_wsl_subsystem

if [ $WSL_VERSION -eq 2 ]; then
   #now try to open VS code with blog folder
   code "$HOME/blog"
fi

#and run here
# gatsby develop
echo "to develop the blog, run:"
echo "cd ~/blog"
echo "hugo server --disableFastRender"

