### locale ###
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
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

# Android
export ANDROID_HOME=/Users/hayato.mochizuki/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH

# tealdeer
export TEALDEER_CONFIG_DIR="$HOME/tealdeer"
export TEALDEER_CACHE_DIR="$HOME/tealdeer"

# TrueColor
export TERM=screen-256color

# disable auto update on Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

# deno
. ~/.deno/env
