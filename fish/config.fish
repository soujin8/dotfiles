set PATH /usr/local/bin $PATH
# ruby
set -x PATH /Users/hachi/.gem/ruby/2.7.0 $PATH
# rbenv
status --is-interactive; and source (rbenv init -|psub)
# MySQL
set -x PATH "/usr/local/opt/mysql@5.7/bin" $PATH
# script file
set -x PATH ~/.scripts $PATH
# golang
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
# anyenv
set -x PATH $HOME/.anyenv/bin $PATH
# nodenv
set -x NODENV_ROOT /Users/hachi/.anyenv/envs/nodenv
set -x PATH /Users/hachi/.anyenv/envs/nodenv/bin $PATH
set -x PATH /Users/hachi/.anyenv/envs/nodenv/shims $PATH
set -x NODENV_SHELL fish

# alias
alias be='bundle exec'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias g='git'
alias c='clear'
alias ll='ls -lahG'

# theme-bobthefish
set -g fish_prompt_pwd_dir_length 0  # ディレクトリ省略しない
set -g theme_display_git_master_branch yes # git branch名を表示
set -g theme_display_date no  # 時刻を表示しないように設定
set -g theme_display_cmd_duration no  # コマンド実行時間の非表示

