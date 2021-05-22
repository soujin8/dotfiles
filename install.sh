#!/bin/bash
# 配置したい設定ファイル
#dotfiles=(.zshrc tmux/.tmux.conf git/.gitconfig)
dotfiles= .zshrc

# シンボリックリンクをホームディレクトリ直下に作成
for file in "${dotfiles[@]}"; do
	ln -svf $files ~/
done

ln -sf ~/dotfiles/nvim ~/.config 
ln -sf ~/dotfiles/alacritty ~/.config 

