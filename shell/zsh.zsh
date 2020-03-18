#  -- Exports --

function biggest() {
  du -a $1 | sort -n -r | head -n 5
}

function whereisip() {
  curl ipinfo.io/$1
}

function b64 {
  if [ "$1" = "-d" ]; then
    echo -n $2 | base64 -d
  else
    echo -n $1 | base64 | pbcopy
  fi
}

# -- Aliases --
alias q="exit"
alias :q="exit"
alias zshrc="nvim ~/.zshrc && . ~/.zshrc"
alias redis="docker run -p 6379:6379 redis"
alias dev="ENV=development"
alias lzd="lazydocker"
alias virtualenv="python3 -m virtualenv"
alias myip="curl https://taybart.com/ip"
alias j="z"

# Git Aliases
alias gs="git status"
alias gcm="git commit -m"
alias gd="git diff --patience --ignore-space-change"
alias gpo=" git pull origin"
alias gpom=" git pull origin master"
alias gitadddeleted="git ls-files --deleted -z | xargs -0 git rm"
alias gitdisabledirty="git config --add oh-my-zsh.hide-dirty 1"
alias gitremovemerged="git branch --merged dev | grep -v dev | xargs -n 1 git branch -d"

# K8s Aliases
alias kc="kubectl"
alias kcxt="kubectl config use-context"
alias kcxts="kubectl config get-contexts"

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  alias copy="pbcopy"
  alias grep="grep -RIns --color=auto --exclude=\"tags\""
  alias ls="ls -G -l -h"
  alias lsusb="system_profiler SPUSBDataType"
  alias newmacaddr="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
  alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
  alias ctags="`brew --prefix`/bin/ctags"
  alias update="brew update && brew upgrade"
  alias install="brew install"
  function remove() {
    brew rm $1
    brew rm $(join <(brew leaves) <(brew deps $1))
  }
function title {
  echo -ne "\033]0;"$*"\007"
}
# Usage: $ notify Title content
function notify {
  osascript -e "display notification \"$2\" with title \"$1\" sound name \"Ping\""
}
alias -s go="go run"
alias -s py="python"
else
  # alias grep="grep -RIns --color --exclude=\"tags\""
  alias ls="ls -lh --color"
  alias xup="xrdb ~/.Xresources"
  alias open="xdg-open"
  alias copy="xclip -sel clip"

  if [ -f /etc/debian_version ]; then
    alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
    alias install="sudo apt-get install"
    alias remove="sudo apt-get autoremove"

    xmodmap ~/.xmodmap > /dev/null 2>&1

  elif [ -f /etc/redhat-release ]; then
    alias update="sudo dnf update"
    alias install="sudo dnf install"
    alias remove="sudo dnf remove"
  elif [ -f /etc/arch-release ]; then
    alias update="yay -Syu"
    alias install="yay -S"
    alias remove="yay -R"
  elif `grep -Fq Amazon /etc/system-release`; then
    alias update="sudo yum update"
    alias install="sudo yum install"
    alias remove="sudo yum remove"
  fi
fi

# -- Functions --
alias newpw="head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | fold -w 32 | head -n 1 | copy"
