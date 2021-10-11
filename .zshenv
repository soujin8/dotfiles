# export LANG=en_US.utf8
# export LANGUAGE=en
export LANG=jp_JP.utf8
export LANGUAGE=jp
export PATH="$HOME/.local/bin:$PATH"
export PATH='/bin:/sbin':"$PATH"

# for anyenv
if [ -e "$HOME/.anyenv" ];
then
    export ANYENV_ROOT="$HOME/.anyenv"
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv 1>/dev/null 2>&1
    then
        eval "$(anyenv init -)"
    fi
fi

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
export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin':"$PATH"

# for krew (kubectl plugin manager)
if [ -e "$HOME/.krew" ];
then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi
