#!/usr/bin/env bash

function green_color() { echo "\033[0;32m\c"; }
function blue_color() { echo "\033[0;34m\c"; }
function reset_color() { echo "\033[0m\c"; }

function abort_if_prompted() {
  if [[ $1 != "y" ]]; then
    blue_color; echo "\n🙂 Alright, another time maybe! Cya 👋\n"; reset_color
    exit 1
  fi
}

function intro_message() {
  green_color
  echo "                                                                                "
  echo "                              __      __  _____ __                              "
  echo "                         ____/ /___  / /_/ __(_) /__  _____                     "
  echo "                        / __  / __ \/ __/ /_/ / / _ \/ ___/                     "
  echo "                      _/ /_/ / /_/ / /_/ __/ / /  __(__  )                      "
  echo "                     (_)__,_/\____/\__/_/ /_/_/\___/____/                       "
  echo "                                                                                "
  echo "                                                                                "
  echo "                                                                                "
  blue_color
  echo "This script will guide you through installing your local development environment"
  echo "Fear not, it will not install anything without asking you first!                "

  green_color; echo; read -p "✨ Shall we proceed with the installation? (Y/N) " -n 1; echo
  abort_if_prompted $REPLY
}

function installation_commands() {
  emoji=$1; name=$2; condition=$3;

  blue_color; echo "\n$emoji Trying to detect installed $name..."

  if ! [[ $(eval $condition) ]]; then
    blue_color; echo "$emoji Looks like we don't have it, but it's needed for our setup."

    green_color; read -p "$emoji Shall we install $name? (Y/N)" -n 1; echo
    abort_if_prompted $REPLY

    shift 3
    while test $# -gt 1; do
      blue_color; echo "$emoji $1"; reset_color
      eval $2
      shift 2
    done

    blue_color; echo "$emoji $name installed successfully! 🎉"
  else
    blue_color; echo "$emoji Looks like we already have it! Moving on."
  fi

  reset_color; sleep 1
}

function installation_files() {
  emoji=$1; name=$2; kind=$3; app=$4;

  green_color; echo; read -p "$emoji Shall we install the $name $kind? (y/N) " -n 1; echo

  if [[ $REPLY == "y" ]]; then
    blue_color; echo "$emoji $app will open shortly. Install the $kind and quit the app."
    sleep 5

    shift 4
    while test $# -gt 0; do
      open -W $1
      shift
    done

    blue_color; echo "$emoji $name $kind installed successfully! 🎉"
  else
    blue_color; echo "$emoji Skipping $name $kind installation."
  fi

  reset_color; sleep 1
}

function setup_dotfiles() {
  rm -rf ~/.gitconfig \
    ~/.ssh/config \
    ~/.tmux.conf \
    ~/.vim \
    ~/.vimrc \
    ~/.zshrc

  ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
  ln -s ~/.dotfiles/ssh/config ~/.ssh/config
  ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
  ln -s ~/.dotfiles/vim ~/.vim
  ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
  ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
}

# The script starts here
intro_message

installation_commands "🔧" "dotfiles" "ls -a ~/ | grep .dotfiles"\
  "Cloning repository from GitHub..."\
  "git clone git@github.com:clementbernet/dotfiles.git ~/.dotfiles"\
  "Create symlinks for config files..."\
  "setup_dotfiles"
  
unset -f green_color blue_color reset_color\
  intro_message installation_commands installation_files setup_dotfiles

exit 0
