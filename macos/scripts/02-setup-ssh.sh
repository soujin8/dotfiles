#!/bin/bash

set -e

echo "========================================="
echo "Setting up SSH directory"
echo "========================================="

# .sshディレクトリの作成
echo "==> Checking .ssh directory..."
if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    echo "✓ Created .ssh directory with proper permissions."
else
    echo ".ssh directory already exists."
    # パーミッションが正しいか確認して修正
    chmod 700 "$HOME/.ssh"
    echo "✓ SSH directory permissions verified."
fi

echo ""
echo "========================================="
echo "✓ SSH setup completed!"
echo "========================================="
