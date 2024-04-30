export HOMEBREW_NO_ENV_HINTS=true

. $(brew --prefix asdf)/libexec/asdf.sh

alias copy="pbcopy"
# alias grep="grep -RIns --color=auto --exclude=\"tags\""
alias ls="ls -G -l -h"
alias lsusb="system_profiler SPUSBDataType"
alias newmacaddr="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
# alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
alias ctags="$(brew --prefix)/bin/ctags"
alias update="brew update && brew upgrade"
alias install="brew install"
alias d2u="sed -i '' -e 's/\r$//'"
# alias python="python3"
alias flushcache="sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache"
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport"
alias resetaudio="sudo kill -9 $(ps ax|grep 'coreaudio[a-z]' | awk '{print $1}')"

function showhidden() {
  defaults write com.apple.finder AppleShowAllFiles -bool $1
  killall -HUP Finder
}

function remove() {
  brew rm $1
  brew autoremove
  # maybe move to brew autoremove every once in a while
  # leaves=$(join <(brew leaves) <(brew deps $1))
  # if [ -z "$leaves" ]; then
  #   brew rm $leaves
  # fi
  # brew rm $(join <(brew leaves) <(brew deps $1))
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
