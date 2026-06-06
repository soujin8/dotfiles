#!/bin/bash

set -e

echo "========================================="
echo "Building Neovim from source"
echo "========================================="

# ghq の確認
if ! command -v ghq &> /dev/null; then
    echo "Error: ghq is not installed. Please install ghq first."
    exit 1
fi

# ビルド依存関係の確認
echo "==> Checking build dependencies..."
MISSING_DEPS=()
for dep in ninja cmake gettext curl git; do
    if ! command -v "$dep" &> /dev/null; then
        MISSING_DEPS+=("$dep")
    fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo "Missing dependencies: ${MISSING_DEPS[*]}"
    echo "Installing via Homebrew..."
    brew install "${MISSING_DEPS[@]}"
fi
echo "✓ All build dependencies are available."

# ghq で neovim をクローン
echo ""
echo "==> Cloning neovim repository via ghq..."
NEOVIM_REPO="neovim/neovim"

if ghq list | grep -q "github.com/${NEOVIM_REPO}"; then
    echo "Repository already cloned. Updating..."
    NEOVIM_DIR="$(ghq root)/github.com/${NEOVIM_REPO}"
    git -C "${NEOVIM_DIR}" pull --ff-only || true
else
    ghq get "https://github.com/${NEOVIM_REPO}.git"
    NEOVIM_DIR="$(ghq root)/github.com/${NEOVIM_REPO}"
fi

echo "✓ Repository ready at: ${NEOVIM_DIR}"

# stable ブランチに切り替え
echo ""
echo "==> Checking out stable branch..."
git -C "${NEOVIM_DIR}" checkout stable
git -C "${NEOVIM_DIR}" pull --ff-only || true

# ビルド
echo ""
echo "==> Building Neovim..."
make -C "${NEOVIM_DIR}" CMAKE_BUILD_TYPE=RelWithDebInfo

# インストール
echo ""
echo "==> Installing Neovim..."
sudo make -C "${NEOVIM_DIR}" install

# 起動確認
echo ""
echo "==> Verifying installation..."
if nvim --version | head -1; then
    echo "✓ Neovim has been successfully built and installed!"
else
    echo "Error: Neovim installation verification failed."
    exit 1
fi

echo ""
echo "========================================="
echo "✓ Neovim build completed!"
echo "========================================="
