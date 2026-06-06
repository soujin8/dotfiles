#!/bin/bash

set -e

echo "========================================="
echo "Applying chezmoi"
echo "========================================="

if ! command -v chezmoi &> /dev/null; then
    echo "Error: chezmoi is not installed."
    exit 1
fi

echo "==> Running chezmoi apply..."
chezmoi apply

echo ""
echo "========================================="
echo "✓ chezmoi apply completed!"
echo "========================================="
