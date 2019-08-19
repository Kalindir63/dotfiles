#!/bin/env bash

sudo pacman -S xsel
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#{{{pomodoro
mkdir -p "$HOME/.local/bin"
cd "$HOME/.local/bin" || exit
proxychains wget https://github.com/justincampbell/tmux-pomodoro/releases/download/v1.2.1/tmux-pomodoro_linux_amd64.tar.gz
tar -zxvf tmux-pomodoro*.tar.gz
rm tmux-pomodoro*.tar.gz
cd "$HOME" || exit
#}}}

echo "'prefix I' to install plugins"
