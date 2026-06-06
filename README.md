# dotfiles

shell 依存関係

```
.zshrc
 |- sheldon
    |- defer.zsh
    |- sync.zsh
       |- starship
```

```
xcode-select --install
curl -L https://raw.githubusercontent.com/soujin8/dotfiles/refs/heads/master/install.sh | bash
chezmoi cd
chmod +x macos/setup.sh macos/scripts/*.sh
./macos/setup.sh
```
# Brefile

```
brew bundle dump --no-vscode --no-go --force --file=macos/Brewfile
```
