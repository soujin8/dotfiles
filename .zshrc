# ---------------------------------------------------------
# Enable Powerlevel10k
# ---------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------------------------------------------------------
# Zinit's installer
# ---------------------------------------------------------

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ---------------------------------------------------------
# plugin
# ---------------------------------------------------------

# zsh theme
zinit ice depth=1; zinit light romkatv/powerlevel10k
# syntax hightlight
zinit light zdharma-continuum/fast-syntax-highlighting
# 補完
zinit light zsh-users/zsh-completions
# autosuggest
zinit light zsh-users/zsh-autosuggestions
# open git repository
zinit light paulirish/git-open

# ---------------------------------------------------------
# basic
# ---------------------------------------------------------

# https://qiita.com/kwgch/items/445a230b3ae9ec246fcb
setopt nonomatch

# GitHub CLI
eval "$(gh completion -s zsh)"
# direnv
eval "$(direnv hook zsh)"
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---------------------------------------------------------
# completions
# ---------------------------------------------------------

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# 補完候補をそのまま探す -> 小文字を大文字に変えて探す -> 大文字を小文字に変えて探す
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

### 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''

### 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

# automatically change directory when dir name is typed
setopt auto_cd

# ---------------------------------------------------------
# prompt
# ---------------------------------------------------------

SCRIPT_DIR=$HOME/dotfiles
source $SCRIPT_DIR/zsh/p10k.zsh

# ---------------------------------------------------------
# alias
# ---------------------------------------------------------

alias be='bundle exec'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias g='git'
alias gp='git push -u origin HEAD'
alias c='clear'
alias ll='ls -lahG'
alias d='docker'
alias dc='docker-compose'
alias dcnt='docker container'
alias dcur='docker container ls -f status=running -l -q'
alias dexec='docker container exec -it $(dcur)'
alias dimg='docker image'
alias drun='docker container run —rm -d'
alias drunit='docker container run —rm -it'
alias dstop='docker container stop $(dcur)'
alias k='kubectl'
alias n='nvim'
alias ojt='oj t -c "ruby main.rb" -d test'

# ---------------------------------------------------------
# function
# ---------------------------------------------------------

function ide() {
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1
}

function dev() {
    moveto=$(ghq root)/$(ghq list | fzf)
    cd $moveto

    # rename session if in tmux
    if [[ ! -z ${TMUX} ]]
    then
        repo_name=${moveto##*/}
        tmux rename-session ${repo_name//./-}
    fi
}
zle -N dev
bindkey '^g' dev

function reload() {
  exec $SHELL -l
}

