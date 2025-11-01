#!/bin/bash

set -e

echo "==> Configuring macOS settings..."

# Dock
echo "Configuring Dock..."
## Dockからすべてのアプリを消す
defaults write com.apple.dock persistent-apps -array
## Dockのサイズ
defaults write com.apple.dock "tilesize" -int "36"
## 最近起動したアプリを非表示
defaults write com.apple.dock "show-recents" -bool "false"
## アプリをしまうときのアニメーション
defaults write com.apple.dock "mineffect" -string "scale"
## 使用状況に基づいてデスクトップの順番を入れ替え
defaults write com.apple.dock "mru-spaces" -bool "false"

# Screenshot
echo "Configuring Screenshot settings..."
## 保存場所
if [[ ! -d "$HOME/Pictures/Screenshots" ]]; then
    mkdir -p "$HOME/Pictures/Screenshots"
fi
defaults write com.apple.screencapture "location" -string "~/Pictures/Screenshots"

# Finder
echo "Configuring Finder..."
## 拡張子まで表示
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
## 隠しファイルを表示
defaults write com.apple.Finder "AppleShowAllFiles" -bool "true"
## パスバーを表示
defaults write com.apple.finder ShowPathbar -bool "true"
## 未確認ファイルを開くときの警告無効化
defaults write com.apple.LaunchServices LSQuarantine -bool "false"

# Feedback
echo "Configuring Feedback settings..."
## フィードバックを送信しない
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"
## クラッシュレポート無効化
defaults write com.apple.CrashReporter DialogType -string "none"

# .DS_Store
echo "Configuring .DS_Store settings..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

# Battery
echo "Configuring Battery display..."
## バッテリーを%表示
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Trackpad
echo "Configuring Trackpad..."
## タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool "true"
defaults -currentHost write -g com.apple.mouse.tapBehavior -bool "true"
## ドラッグ&ドロップ
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool "true"
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool "true"
defaults write com.apple.AppleMultitouchTrackpad.trackpad DragLock -bool "true"
defaults write com.apple.AppleMultitouchTrackpad.trackpad Dragging -bool "true"

# Aerospace使用時にMission Controlの画面が小さくなる問題
# https://zenn.dev/mozumasu/articles/mozumasu-window-costomization#aerospace%E4%BD%BF%E7%94%A8%E6%99%82%E3%81%ABmission-control%E3%81%AE%E7%94%BB%E9%9D%A2%E3%81%8C%E5%B0%8F%E3%81%95%E3%81%8F%E3%81%AA%E3%82%8B%E5%95%8F%E9%A1%8C
echo "Configuring Mission Control..."
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# Security
echo "Configuring Security settings..."
## ファイアウォールon (sudoが必要)
if sudo -n true 2>/dev/null; then
    sudo defaults write /Library/Preferences/com.Apple.alf globalstate -int 1
    echo "✓ Firewall enabled."
else
    echo "⚠️  Note: Firewall configuration requires sudo privileges."
    echo "   Please run manually: sudo defaults write /Library/Preferences/com.Apple.alf globalstate -int 1"
fi

echo "✓ macOS configuration complete."
echo "Note: Some settings may require logging out or restarting to take effect."
