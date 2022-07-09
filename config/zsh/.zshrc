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

## Added by Zinit's installer
 # if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
 #     print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
 #     command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
 #     command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
 #         print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
 #         print -P "%F{160}▓▒░ The clone has failed.%f%b"
 # fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
## End of Zinit's installer chunk

# ---------------------------------------------------------
# path
# ---------------------------------------------------------

typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
  "$HOME/.local/bin"(N-/)
  "$HOME/.cargo/bin"(N-/)
  "$GOPATH/bin"
)

# GitHub CLI
eval "$(gh completion -s zsh)"
# direnv
eval "$(direnv hook zsh)"
# asdf
if [[ "$OSTYPE" == "darwin"* ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

# asdfでruby2.6.5インストールするときにこれらを設定するとできるようになった
# https://stackoverflow.com/questions/69012676/install-older-ruby-versions-on-a-m1-macbook
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# export LDFLAGS="-L/opt/homebrew/opt/readline/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/readline/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig"
# export optflags="-Wno-error=implicit-function-declaration"
# export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"
# eval $(/opt/homebrew/bin/brew shellenv)

# ---------------------------------------------------------
# basic
# ---------------------------------------------------------

# # 履歴保存管理
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt share_history           # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_all_dups    # 同じコマンドをhistoryに残さない
setopt hist_ignore_space       # historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks      # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups       # 重複するコマンドが保存されるとき、古い方を削除する
setopt inc_append_history      # 実行時に履歴をファイルにに追加していく
# https://qiita.com/kwgch/items/445a230b3ae9ec246fcb
setopt nonomatch

zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|jj?|lazygit|la|ll|ls|rm|rmdir)($| )" ]]
}

# MacOSでssh-addを自動で。
# https://zenn.dev/moya_dev/scraps/26c19e6a5b3927
# ssh-add --apple-load-keychain
export TERM=xterm-256color

# ---------------------------------------------------------
# completions
# ---------------------------------------------------------

# brew completion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi


# initialise completions with ZSH's compinit
# autoload -Uz compinit && compinit

# 補完候補をそのまま探す -> 小文字を大文字に変えて探す -> 大文字を小文字に変えて探す
# zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

### 補完方法毎にグループ化する。
# zstyle ':completion:*' format '%B%F{blue}%d%f%b'
# zstyle ':completion:*' group-name ''

### 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
# zstyle ':completion:*:default' menu select=2

# automatically change directory when dir name is typed
# setopt auto_cd

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

function f() {
  local project dir repository session current_session
  project=$(ghq list | fzf --prompt='Project >')

  if [[ $project == "" ]]; then
    return 1
  elif [[ -d ~/dev/${project} ]]; then
    dir=~/dev/${project}
  elif [[ -d ~/.go/src/${project} ]]; then
    dir=~/.go/src/${project}
  fi

  if [[ ! -z ${TMUX} ]]; then
    repository=${dir##*/}
    session=${repository//./-}
    current_session=$(tmux list-sessions | grep 'attached' | cut -d":" -f1)

    if [[ $current_session =~ ^[0-9]+$ ]]; then
      cd $dir
      tmux rename-session $session
    else
      tmux list-sessions | cut -d":" -f1 | grep -e "^$session\$" > /dev/null
      if [[ $? != 0 ]]; then
        tmux new-session -d -c $dir -s $session
      fi
      tmux switch-client -t $session
    fi
  else
    cd $dir
  fi
}

function sshsp() {
  local host=$(grep -E "^Host " ~/.ssh/config | sed -e 's/Host[ ]*//g' | fzf)
  if [ -n "$host" ]; then
    ssh $host
  fi
}

# Ctrl + r で履歴検索
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history


# rspec util function
function changed_spec_files()
{
  git diff --name-only --diff-filter=ACMR origin/main | grep spec | grep -v -E '.*spec\/(factories|fixtures)/' | tr '\r\n' ' '
}

function rspec_git()
{
  files=$(changed_spec_files)
  echo "Discovered... $files"
  rspec $files
}

function all_spec_files()
{
  find -name "*_spec.rb" -not -path "./tmp/*" -and -not -path "./vendor/*" -and -not -path "./qa/*"
}

function rspec()
{
  files=${1:-$(all_spec_files | fzf)}
  if [[ -f ./bin/rspec ]]; then
    ./bin/rspec $files
  else
    bundle exec rspec $files
  fi
}

# ---------------------------------------------------------
# plugin
# ---------------------------------------------------------

# zsh theme
zinit ice depth=1; zinit light romkatv/powerlevel10k
source $ZDOTDIR/p10k.zsh

### plugins ###
zinit wait lucid null for \
    atinit'source "$ZDOTDIR/.zshrc.lazy"' \
    @'zdharma-continuum/null'

