# golang
set -x GOPATH $HOME/go
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin /bin /usr/bin
## anyenv
set -x PATH $HOME/.anyenv/bin $PATH
set -x NODENV_ROOT $HOME/.anyenv/envs/nodenv
set -x PATH $HOME/.anyenv/envs/ndenv/bin $PATH
set -x PATH $NDENV_ROOT/shims $PATH
set -x NODENV_SHELL fish
eval (anyenv init - | source)
## Lang
set -x LANG en_US.utf8
## Rust cargo
set -x PATH $HOME/.cargo/bin $PATH

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
alias k='kubectl'

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
