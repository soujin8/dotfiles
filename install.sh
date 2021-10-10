#!/bin/bash

echo "Start creating symlink."

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

echo "Finish creating symlink."
echo ""

# homebrew install
echo "Start the installation of homebrew."
if [ "$(uname)" == 'Linux' ]; then

  brew help &> /dev/null 2>&1
  if [ $? -eq 127 ]; then
    echo "installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "run brew doctor..."
    which brew >/dev/null 2>&1 && brew doctor

    echo "run brew update..."
    which brew >/dev/null 2>&1 && brew update

    echo "ok. run brew upgrade..."
    brew upgrade

    if [ -e "Brewfile" ]; then
      brew bundle
    fi
  else
    echo "homebrew is already installed."
  fi

elif [ "$(uname)" == 'Darwin' ]; then

  brew help &> /dev/null 2>&1
  if [ $? -eq 127 ]; then
    echo "installing homebrew..."
    which brew >/dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    echo "run brew doctor..."
    which brew >/dev/null 2>&1 && brew doctor

    echo "run brew update..."
    which brew >/dev/null 2>&1 && brew update

    echo "ok. run brew upgrade..."
    brew upgrade

    if [ -e "Brewfile" ]; then
      brew bundle
    fi
  fi

else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

echo "Finish the installation of homebrew."
echo ""

