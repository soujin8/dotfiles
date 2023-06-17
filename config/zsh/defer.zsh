# 非同期実行したい処理をここに書く

# ---------------------------------------------------------
# alias
# ---------------------------------------------------------

alias g='git'
alias gs='git status'
alias c='clear'
alias k='kubectl'
alias n='nvim'
alias ojt='oj t -c "ruby main.rb" -d test'
alias be='bundle exec'
alias gcd='g checkout develop && git pull && gh poi'
alias tenki='curl http://wttr.in/Tokyo'
alias rm='rm -i'

alias lazygit='lazygit -ucd ~/dev/github.com/m-88888888/dotfiles/config/lazygit'
# refer https://zenn.dev/ryuu/scraps/fddefc2ca60f88
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.asdf\/shims:/} brew"
# macOSでBSD系CLIツール→GNU系に置き換える
case "$OSTYPE" in
    darwin*)
        (( ${+commands[gdate]} )) && alias date='gdate'
        # (( ${+commands[gls]} )) && alias ls='gls' # exa 使っているので不要
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

# exa
alias ls='exa --group-directories-first'
alias la='exa --group-directories-first -a'
alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
alias tree='exa --group-directories-first -T --icons'

# zeno.zsh fast-syntax と相性悪い？一旦無効化にする
# if [[ -n $ZENO_LOADED ]]; then
#   bindkey ' '  zeno-auto-snippet

#   # fallback if snippet not matched (default: self-insert)
#   # export ZENO_AUTO_SNIPPET_FALLBACK=self-insert

#   # if you use zsh's incremental search
#   # bindkey -M isearch ' ' self-insert

#   bindkey '^m' zeno-auto-snippet-and-accept-line

#   bindkey '^i' zeno-completion

#   # fallback if completion not matched
#   # (default: fzf-completion if exists; otherwise expand-or-complete)
#   # export ZENO_COMPLETION_FALLBACK=expand-or-complete
#   bindkey '^r'   zeno-history-selection
#   bindkey '^x^s' zeno-insert-snippet
#   bindkey '^x^f' zeno-ghq-cd
# fi

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

# direnv
eval "$(direnv hook zsh)"

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

## fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

## pack
# . $(pack completion --shell zsh)
# GitHub CLI
eval "$(gh completion -s zsh)"
## gcloud
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

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

nction reload() {
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
