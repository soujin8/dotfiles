#!/bin/bash

set -e

# ========================================
# macOS セットアップスクリプト
# ========================================

# macOS判定
if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This script is only for macOS."
    exit 1
fi

# スクリプトディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

echo ""
echo "=========================================="
echo "  macOS Setup Script"
echo "=========================================="
echo ""
echo "This script will configure your macOS environment."
echo "Scripts directory: ${SCRIPTS_DIR}"
echo ""

# スクリプトディレクトリの存在確認
if [[ ! -d "${SCRIPTS_DIR}" ]]; then
    echo "Error: Scripts directory not found: ${SCRIPTS_DIR}"
    exit 1
fi

# スクリプト実行関数
run_script() {
    local script_path="$1"
    local script_name=$(basename "${script_path}")

    if [[ ! -f "${script_path}" ]]; then
        echo "Error: Script not found: ${script_path}"
        exit 1
    fi

    if [[ ! -x "${script_path}" ]]; then
        chmod +x "${script_path}"
    fi

    echo ""
    echo "=========================================="
    echo "Running: ${script_name}"
    echo "=========================================="
    echo ""

    bash "${script_path}"

    if [[ $? -ne 0 ]]; then
        echo ""
        echo "Error: ${script_name} failed."
        exit 1
    fi
}

run_script "${SCRIPTS_DIR}/01-configure-macos.sh"
run_script "${SCRIPTS_DIR}/02-setup-ssh.sh"
run_script "${SCRIPTS_DIR}/03-install-brew.sh"
run_script "${SCRIPTS_DIR}/04-install-mise.sh"
run_script "${SCRIPTS_DIR}/05-install-claude.sh"

# 完了メッセージ
echo ""
echo "=========================================="
echo "✓ All setup completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  - Restart your terminal or run: source ~/.zshrc"
echo "  - Log out and log back in for some settings to take effect"
echo ""
