# -- Aliases --
alias q="exit"
alias :q="exit"
alias zshrc="nvim ~/.zshrc && . ~/.zshrc"
alias startredis="docker run -p 6379:6379 -d redis"


# Git Aliases
alias gs="git status"
alias gcm="git commit -m"
alias gd="git diff --patience --ignore-space-change"
alias gpo=" git pull origin"
alias gpom=" git pull origin master"
alias gitadddeleted="git ls-files --deleted -z | xargs -0 git rm"
alias gitdisabledirty="git config --add oh-my-zsh.hide-dirty 1"


############## Variables ###############

set fish_greeting (date)

set -x EDITOR nvim
# set -x LC_ALL en_US.UTF-8
set GPG_TTY (tty)

# Go
set -x GOPATH $HOME/dev/.go
set -x PATH $HOME/dev/.go/bin:$PATH

# Android
set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x PATH $PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Node
set -x PATH "$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"


############### Alias ##################
set HOMEIP "192.168.0.100"
set EXHOMEIP "73.229.143.233"
alias home="title home && ssh $EXHOMEIP -p 12355"
alias localhome="title localhome && ssh $HOMEIP"

alias top="gotop -m"
alias ls="ls -G -l -h"
alias lsusb="system_profiler SPUSBDataType"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
alias ctags="`brew --prefix`/bin/ctags"
alias update="brew update && brew upgrade"
alias install="brew install"

# Python
alias python="python3"
alias pip="pip3"



############## Fucntions ###############

#alias grep="grep -RIns --color=auto --exclude=\"tags\""
#
bind \ee echo 'hello'
#
bind ! __history_previous_command
bind '$' __history_previous_command_arguments
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

theme_gruvbox dark
