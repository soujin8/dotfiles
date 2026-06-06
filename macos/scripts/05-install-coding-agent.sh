#!/bin/bash

set -e

echo "========================================="
echo "Installing Coding Agents"
echo "========================================="

# PATHを通す
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Claude Code
echo "==> Checking Claude Code installation..."
if command -v claude >/dev/null 2>&1; then
  echo "Claude Code is already installed."
else
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  echo "✓ Claude Code installation completed."
fi

# Codex CLI
echo ""
echo "==> Checking Codex CLI installation..."
if command -v codex >/dev/null 2>&1; then
  echo "Codex CLI is already installed."
else
  echo "Installing Codex CLI..."
  curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
  echo "✓ Codex CLI installation completed."
fi

echo ""
echo "========================================="
echo "✓ Coding agents setup completed!"
echo "========================================="
