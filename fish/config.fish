set PATH $PATH /bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin
set fish_user_paths /bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin $fish_user_paths
# golang
set -x GOPATH $HOME/go
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin /bin /usr/bin
# anyenv
set -x PATH $HOME/.anyenv/bin $PATH
# Lang
set -x LANG en_US.utf8
# Rust cargo
set -x PATH $HOME/.cargo/bin

# alias
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

# theme-bobthefish
#set -g fish_prompt_pwd_dir_length 0  # ディレクトリ省略しない
#set -g theme_display_git_master_branch yes # git branch名を表示
#set -g theme_display_date no  # 時刻を表示しないように設定
#set -g theme_display_cmd_duration no  # コマンド実行時間の非表示
#set -g theme_powerline_fonts no # Powerline font無効化

# theme pure-fish/pure
set -g pure_enable_single_line_prompt true
set -g pure_color_mute yellow

# fzf options
set -x FZF_CTRL_T_OPTS '--preview "head -100 {}" --prompt="P " --header="H" --margin=1,3 --inline-info --reverse --border --height 40%'

function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function ide -d "tmux split window like a ide"
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1
end

function jp -d "jump to bookmark directory"
  cd (go run main.go show | peco)
end

function reload -d "reload shell"
  exec fish
end

function gcop -d "git checkout by peco"
  git branch -a --sort=-authordate |
    grep -v -e '->' -e '*' |
    perl -pe 's/^\h+//g' |
    perl -pe 's#^remotes/origin/###' |
    perl -nle 'print if !$c{$_}++' |
    peco |
    xargs git checkout
end

function fs -d "Switch tmux session"
  tmux list-sessions -F "#{session_name}" | fzf | read -l result; and tmux switch-client -t "$result"
end
