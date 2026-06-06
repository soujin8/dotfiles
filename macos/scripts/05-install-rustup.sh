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
  source "$HOME/.cargo/env"
fi

echo ""
echo "==> Rust version:"
rustc --version
cargo --version

echo ""
echo "==> Installing Alacritty..."
if command -v alacritty &> /dev/null; then
  echo "Alacritty is already installed."
else
  cargo install alacritty
fi

echo ""
echo "========================================="
echo "✓ Rustup setup completed!"
echo "========================================="
