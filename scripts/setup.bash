#!/bin/bash
set -x

CUR_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
REPO_DIR="$(cd "$(dirname "$0")/.." || exit 1; pwd)"

if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$XDG_CONFIG_HOME"

ln -sfv "$REPO_DIR/config/"* "$XDG_CONFIG_HOME"
ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"
ln -sfv "$XDG_CONFIG_HOME/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -svf "$HOME/dev/github.com/soujin8/dotfiles/.i3" $HOME
ln -svf "$HOME/dev/github.com/soujin8/dotfiles/.Xmodemap" $HOME

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
