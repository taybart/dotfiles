if status --is-interactive
# -- Aliases --
alias q="exit"
alias :q="exit"
alias startredis="docker run -p 6379:6379 -d redis"

alias top="gotop -m"
alias ls="ls --color -l -h"
alias update="echo please define"
alias install="echo please define"

# Python
alias python="python3"
alias pip="pip3"
alias grep="grep -RIns --color=auto --exclude=\"tags\""


# Git Aliases
alias gs="git status"
alias gcm="git commit -m"
alias gd="git diff --patience --ignore-space-change"
alias gpo=" git pull origin"
alias gpom=" git pull origin master"
alias gitadddeleted="git ls-files --deleted -z | xargs -0 git rm"


############## Variables ###############

set fish_greeting

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

############## Functions ###############

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

  set -l local $HOME/.local.fish
  if test -e $local
  source $local
  end
  end
