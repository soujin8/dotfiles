# ---------------------------------------------------------
# prompt
# ---------------------------------------------------------
eval "$(starship init zsh)"

# ---------------------------------------------------------
# 履歴保存管理
# ---------------------------------------------------------
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt share_history           # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_dups        # 同じコマンドをhistoryに残さない
setopt hist_ignore_all_dups    # 同じコマンドをhistoryに残さない
setopt hist_ignore_space       # historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks      # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups       # 重複するコマンドが保存されるとき、古い方を削除する
setopt inc_append_history      # 実行時に履歴をファイルにに追加していく

setopt auto_pushd              # push directory stack when cd
setopt auto_cd                 # automatically change directory when dir name is typed
setopt nonomatch               # stop globbing from throwing error if no match

autoload -Uz compinit
compinit

zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|jj?|lazygit|la|ll|ls|rm|rmdir)($| )" ]]
}

# MacOSでssh-addを自動で。
# https://zenn.dev/moya_dev/scraps/26c19e6a5b3927
# ssh-add --apple-load-keychain

# ---------------------------------------------------------
# alias
# ---------------------------------------------------------

alias g='git'
alias gs='git status'
alias c='clear'
alias k='kubectl'
alias n='nvim'
alias be='bundle exec'
alias rm='rm -i'

# macOSでBSD系CLIツール→GNU系に置き換える
case "$OSTYPE" in
    darwin*)
        (( ${+commands[gdate]} )) && alias date='gdate'
        # (( ${+commands[gls]} )) && alias ls='gls' # eza 使っているので不要
        (( ${+commands[gmkdir]} )) && alias mkdir='gmkdir'
        (( ${+commands[gcp]} )) && alias cp='gcp'
        (( ${+commands[gmv]} )) && alias mv='gmv'
        (( ${+commands[grm]} )) && alias rm='grm'
        (( ${+commands[gdu]} )) && alias du='gdu'
        (( ${+commands[ghead]} )) && alias head='ghead'
        (( ${+commands[gtail]} )) && alias tail='gtail'
        (( ${+commands[gsed]} )) && alias sed='gsed'
        (( ${+commands[ggrep]} )) && alias grep='ggrep'
        (( ${+commands[gfind]} )) && alias find='gfind'
        (( ${+commands[gdirname]} )) && alias dirname='gdirname'
        (( ${+commands[gxargs]} )) && alias xargs='gxargs'
    ;;
esac

# eza
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias la='eza --group-directories-first -a'
  alias ll='eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
  alias tree='eza --group-directories-first -T --icons'
fi

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
  local host=$(grep -E "^Host " ~/.ssh/conf.d/hosts/* | sed -e 's/.*Host[ ]*//g' | fzf)
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

# movファイルをgifに変換 
# 使い方：$ mov2gif hoge.mov 800 30 # 横幅800px 30FPS
# refer: https://blog.nasbi.jp/programming/devenv/mov2gif-easy-way/
function mov2gif() {
	mov=$1;
	if [[ -z $2 ]]; then
		width=300
	else
		width=$2
	fi
	if [[ -z $3 ]]; then
		rate=15
	else
		rate=$3
	fi
	gif=`basename $mov`".gif"
	ffmpeg -i $mov -vf scale=$width:-1 -pix_fmt rgb24 -r $rate -f gif - | gifsicle --optimize=3 --delay=3 > $gif
}

# fzf で gcloud 切り替え
function gcloud-activate() {
  name="$1"
  project="$2"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
function gx-complete() {
  _values $(gcloud config configurations list | awk '{print $1}')
}
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | fzf)
    name=$(echo "${line}" | awk '{print $1}')
  else
    line=$(gcloud config configurations list | grep "$name")
  fi
  project=$(echo "${line}" | awk '{print $4}')
  gcloud-activate "${name}" "${project}"
}
compdef gx-complete gx

# zshの起動時間計測
function zsh-startuptime() {
  local total_msec=0
  local msec
  local i
  for i in $(seq 1 10); do
    msec=$((TIMEFMT='%mE'; time zsh -i -c exit) 2>/dev/stdout >/dev/null)
    msec=$(echo $msec | tr -d "ms")
    echo "${(l:2:)i}: ${msec} [ms]"
    total_msec=$(( $total_msec + $msec ))
  done
  local average_msec
  average_msec=$(( ${total_msec} / 10 ))
  echo "\naverage: ${average_msec} [ms]"
}

# deltaを利用したdiff
function delta_diff() {
  echo "Enter first input (end with Ctrl-D):"
  input1=$(cat)
  echo "Enter second input (end with Ctrl-D):"
  input2=$(cat)

  # プロセス置換を使用してdiffを取り、deltaで表示
  delta <(echo "$input1") <(echo "$input2")
}
