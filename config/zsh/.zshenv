### locale ###
# export LANG=en_US.utf8
# export LANGUAGE=en
export LANG=ja_JP.UTF-8
export LANGUAGE=jp

### XDG ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

### zsh ###
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

### Rust ###
export RUST_BACKTRACE=1
# export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# export CARGO_HOME="$XDG_DATA_HOME/cargo"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

export ANDROID_HOME=/Users/hayato.mochizuki/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
