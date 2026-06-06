#!/bin/bash

set -e

echo "========================================="
echo "Installing Rustup"
echo "========================================="

echo "==> Checking Rustup installation..."

if command -v rustup &> /dev/null; then
  echo "Rustup is already installed."
  echo "==> Updating Rust toolchain..."
  rustup update
else
  echo "Rustup not found. Installing..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  CARGO_ENV="${CARGO_HOME:-$HOME/.cargo}/env"
  if [[ -f "$CARGO_ENV" ]]; then
    source "$CARGO_ENV"
  else
    export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
  fi
fi

echo ""
echo "==> Rust version:"
rustc --version
cargo --version

echo ""
echo "==> Installing Alacritty..."
if [[ -d "/Applications/Alacritty.app" ]]; then
  echo "Alacritty.app is already installed."
else
  ALACRITTY_TMP="$(mktemp -d)"
  git clone --depth 1 https://github.com/alacritty/alacritty.git "$ALACRITTY_TMP"
  pushd "$ALACRITTY_TMP"
  make app
  cp -r target/release/osx/Alacritty.app /Applications/
  popd
  rm -rf "$ALACRITTY_TMP"
  echo "✓ Alacritty.app installed to /Applications/"
fi

if ! command -v alacritty &> /dev/null; then
  sudo ln -sf /Applications/Alacritty.app/Contents/MacOS/alacritty /usr/local/bin/alacritty
  echo "✓ Symlinked alacritty to /usr/local/bin/"
fi

echo ""
echo "========================================="
echo "✓ Rustup setup completed!"
echo "========================================="
