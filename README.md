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
chezmoi init https://github.com/soujin8/dotfiles.git
```

# Brefile

```
brew bundle dump --force --file=./macos/Brewfile
```
