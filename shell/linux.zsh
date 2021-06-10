alias ls="ls -lh --color"
alias xup="xrdb ~/.Xresources"
alias copy="xclip -sel clip"
alias xup="xrdb ~/.Xresources"

function open {
  xdg-open "$@" >/dev/null 2>&1
}

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
  alias remove="yay -Rcns"
elif `grep -Fq Amazon /etc/system-release 2> /dev/null`; then
  alias update="sudo yum update"
  alias install="sudo yum install"
  alias remove="sudo yum remove"
elif [ -f /etc/alpine-release ]; then
  alias update="sudo apk update"
  alias install="sudo apk add"
  alias remove="sudo apk del"
fi
