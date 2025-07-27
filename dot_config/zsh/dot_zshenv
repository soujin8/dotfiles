### locale ###
export LANG=ja_JP.UTF-8
export LANGUAGE=jp

### XDG ###
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

### zsh ###
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

### Rust ###
export RUST_BACKTRACE=1
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$XDG_DATA_HOME/cargo

### Go ###
export GOPATH=$XDG_DATA_HOME/go

# TrueColor
# export TERM=screen-256color
# export TERM=xterm-256color

# disable auto update on Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

export EDITOR="nvim"

# PATH
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin(N-/)
  $HOME/.local/bin(N-/)
  $HOME/.cargo/bin(N-/)
  $GOPATH/bin(N-/)
  /opt/homebrew/opt/mysql-client/bin(N-/)
  /snap/bin(N-/)
  /opt/nvim-linux-x86_64/bin(N-/)
  $HOME/.local/share/aquaproj-aqua/bin(N-/)
)

# load envfile
envfiles=(
  $HOME/.local/share/cargo/env(N)
  $HOME/.cargo/env(N)
  $HOME/.deno/env(N)
)

for envfile in $envfiles; do
  [[ -r $envfile ]] && source $envfile
done

# direnv
eval "$(direnv hook zsh)"
