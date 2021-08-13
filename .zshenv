export LANG=en_US.utf8
export LANGUAGE=en
export PATH="$HOME/.local/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

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
