## prompt
eval "$(starship init zsh)"

eval "$(rtx activate zsh)"

source $HOME/.cargo/env

# 履歴保存管理
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
