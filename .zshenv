# export LANG=en_US.utf8
# export LANGUAGE=en
export LANG=ja_JP.UTF-8
export LANGUAGE=jp
export PATH="$HOME/.local/bin:$PATH"
export PATH='/bin:/sbin':"$PATH"
export PATH="$HOME/node_modules/.bin:$PATH"

# for golang
if [ -e "/usr/local/go" ];
then
  export GOPATH=$HOME/go
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$PATH:$GOPATH/bin
fi

# for cargo
if [ -e "$HOME/.cargo" ];
then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# for linuxbrew
if [ -e "/home/linuxbrew" ];
then
  export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin':"$PATH"
fi

# for krew (kubectl plugin manager)
if [ -e "$HOME/.krew" ];
then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

. /opt/homebrew/opt/asdf/libexec/asdf.sh
# asdf
# . $HOME/.asdf/asdf.sh
# append completions to fpath
# fpath=(${ASDF_DIR}/completions $fpath)
