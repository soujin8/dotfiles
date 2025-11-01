#!/bin/bash

set -e

REPO_URL="https://github.com/soujin8/dotfiles.git"

echo "=== dotfiles セットアップスクリプト ==="

# macOS の場合、Command Line Tools のチェック
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! xcode-select -p &> /dev/null; then
        echo "Xcode Command Line Tools がインストールされていません。"
        echo "インストールダイアログが表示されます。インストール完了後、このスクリプトを再実行してください。"
        xcode-select --install
        exit 0
    else
        echo "✓ Xcode Command Line Tools が確認できました。"
    fi
fi

# chezmoi がインストールされているかチェック
if ! command -v chezmoi &> /dev/null; then
    echo "chezmoi がインストールされていません。インストールを開始します..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
    echo "✓ chezmoi のインストールが完了しました。"
else
    echo "✓ chezmoi は既にインストールされています。"
fi

# chezmoi のパスを確認
if ! command -v chezmoi &> /dev/null; then
    # インストール直後で PATH が通っていない場合の対処
    if [ -f "$HOME/bin/chezmoi" ]; then
        export PATH="$HOME/bin:$PATH"
    elif [ -f "$HOME/.local/bin/chezmoi" ]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

# chezmoi init と apply
echo ""
echo "dotfiles リポジトリを初期化して適用します..."
chezmoi init --apply "$REPO_URL"
echo "✓ セットアップが完了しました!"
