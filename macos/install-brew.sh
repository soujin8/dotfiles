#!/bin/bash

set -e

echo "==> Checking Homebrew installation..."

# Homebrewのインストール
if ! type brew &> /dev/null ; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Brewfileからパッケージをインストール
echo "==> Installing packages from Brewfile..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/Brewfile"

if [[ -f "${BREWFILE}" ]]; then
  brew bundle install --file="${BREWFILE}"
  echo "✓ Package installation complete."
else
  echo "Warning: Brewfile not found at ${BREWFILE}"
  exit 1
fi
