#!/bin/sh

echo "Start symlink"

# dotfilesディレクトリにある、ドットから始まり2文字以上の名前のファイルに対して
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitconfig.local.template" ] && continue
    [ "$f" = ".gitmodules" ] && continue
    [ "$f" = ".gitignore" ] && continue

    # シンボリックリンクを貼る
    ln -snfv ${PWD}/"$f" ~/
done

# nvim alacrittyなどディレクトリごとシンボリックリンク
for f in nvim alacritty; do
    ln -snfv ${PWD}/"$f" ~/.config
done

echo "End symlink"

