#!/bin/bash

set -e

echo "========================================="
echo "Installing Claude Code"
echo "========================================="

# claude code install
echo "==> Checking Claude Code installation..."
if command -v claude >/dev/null 2>&1; then
    echo "Claude Code is already installed."
else
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
    echo "✓ Claude Code installation completed."
fi

echo ""
echo "========================================="
echo "✓ Claude Code setup completed!"
echo "========================================="
