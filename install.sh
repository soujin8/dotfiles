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

    # インストール後のバイナリ位置確認と移動
    if [ -f "$HOME/bin/chezmoi" ]; then
        echo "✓ chezmoi が $HOME/bin に配置されました。"
        # $HOME/.local/bin ディレクトリ確認・作成
        mkdir -p "$HOME/.local/bin"
        # バイナリを移動
        mv "$HOME/bin/chezmoi" "$HOME/.local/bin/chezmoi"
        echo "✓ $HOME/.local/bin に移動しました。"
    elif [ -f "$HOME/.local/bin/chezmoi" ]; then
        echo "✓ chezmoi が $HOME/.local/bin に配置されています。"
    else
        echo "エラー: chezmoi バイナリが見つかりません。"
        exit 1
    fi
else
    echo "✓ chezmoi は既にインストールされています。"
fi

# パス設定と実行権限付与
if ! command -v chezmoi &> /dev/null; then
    if [ -f "$HOME/.local/bin/chezmoi" ]; then
        chmod +x "$HOME/.local/bin/chezmoi"
        export PATH="$HOME/.local/bin:$PATH"
        echo "✓ PATH を設定し、実行権限を付与しました。"
    else
        echo "エラー: chezmoi が見つかりません。"
        exit 1
    fi
fi

# chezmoi 実行確認
if ! command -v chezmoi &> /dev/null; then
    echo "エラー: chezmoi コマンドが実行できません。"
    exit 1
fi
echo "✓ chezmoi コマンドが利用可能です。"

# chezmoi init と apply
echo ""
echo "dotfiles リポジトリを初期化して適用します..."
if ! chezmoi init --apply "$REPO_URL"; then
    echo "エラー: chezmoi init --apply が失敗しました。"
    exit 1
fi
echo "✓ セットアップが完了しました!"
