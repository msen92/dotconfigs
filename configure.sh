#!/bin/bash
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
answer=$1

cd $SCRIPTPATH

fileCheck() {
    check=$1
    echo "Do you want export $check file contents [ Y / N ]"
    read bool
    if [ "$bool" == "Y" ]
    then
        echo "source $SCRIPTPATH/$check" >> .zshrc
        echo "source $SCRIPTPATH/$check command added to .zshrc"
    else
        echo "Skipping $check file"
    fi
}

if  [ "$answer" == "Y" ]
then
    cat .rootrc > .zshrc
    echo "source $SCRIPTPATH/.env" >> .zshrc
    echo "source $SCRIPTPATH/.functions" >> .zshrc
    echo "source $SCRIPTPATH/.aliases" >> .zshrc
    echo "source $SCRIPTPATH/.zshplugins" >> .zshrc
    echo 'if [ "" != "ls -a | grep local" ]; then; for file in $(ls -a $HOME/dotconfigs | grep local); do source $HOME/dotconfigs/$file; done; fi' >> .zshrc
    echo "source $ZSH/oh-my-zsh.sh" >> .zshrc
    echo ".edit file will replace your shell keybindings with vi keybindings."
    echo "This is not recommended if you are not familiar with vi editing."
    fileCheck .edit
    echo ".keybindings will add vi editor shortcut if you want to write commands"
    echo "in vi editor screen. Shortcut will be (control + E)"
    fileCheck .keybindings
    echo "check_git_status" >> .zshrc
elif [ "$answer" == "N" ]
then
    cat backup/.zshrc > .zshrc
    echo "\n" >> .zshrc
    cat .vimrc > .vimrc
    echo "Getting .zshrc from backup"
    fileCheck .env
    fileCheck .functions
    fileCheck .aliases
    fileCheck .zshplugins
    cat backup/.vimrc >> .vimrc
    echo 'if [ "" != "ls -a | grep local" ]; then; for file in $(ls -a $HOME/dotconfigs | grep local); do source $HOME/dotconfigs/$file; done; fi' >> .zshrc
    echo "source $ZSH/oh-my-zsh.sh" >> .zshrc
    echo ".edit file will replace your shell keybindings with vi keybindings."
    echo "This is not recommended if you are not familiar with vi editing."
    fileCheck .edit
    echo ".keybindings will add vi editor shortcut if you want to write commands"
    echo "in vi editor screen. Shortcut will be (control + E)"
    fileCheck .keybindings
    echo "check_git_status" >> .zshrc
else
    echo "Invalid input supplied. Valid inputs are Y or N"
    exit 1
fi

