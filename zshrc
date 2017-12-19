export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

#  -- Exports --
export TERM="screen-256color"
export EDITOR=vim
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.cargo/bin"
# Enable command auto-correction.
export ENABLE_CORRECTION=true
export DISABLE_AUTO_TITLE=true

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]
then
  plugins=(git osx sudo vagrant)

  alias grep="grep -RIns --color=auto --exclude=\"tags\""
  alias ls="ls -G -l"
  alias lsusb="system_profiler SPUSBDataType"
  alias newmacaddr="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
  alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
  alias ctags="`brew --prefix`/bin/ctags"
  alias update="brew update && brew upgrade"
  function title {
    echo -ne "\033]0;"$*"\007"
  }
else
    export PATH="$PATH:$HOME/.linuxbrew/bin"
    alias grep="grep -RIns --color --exclude=\"tags\""
    alias ls="ls -l --color --block-size=M"
    alias xup="xrdb ~/.Xresources"

  if [ -f /etc/debian_version ]; then
    plugins=(git sudo vagrant debian)

    alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
    alias install="sudo apt-get install"
    alias remove="sudo apt-get autoremove"
    alias sa="mosquitto_sub -t '#'"

    xmodmap ~/.xmodmap > /dev/null 2>&1
    # compton -b --backend glx --vsync opengl-swc > /dev/null 2>&1

  elif [ -f /etc/redhat-release ]; then
    plugins=(git sudo vagrant fedora)
    alias update="sudo dnf update"
    alias install="sudo dnf install"
  else
    echo "Unknown system"
  fi
fi


fzf_cd() { zle -I; DIR=$(find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf) && cd "$DIR" ; }; zle -N fzf_cd; bindkey '^E' fzf_cd


  # -- Aliases --
  alias q="exit"
  alias :q="exit"
  alias zshrc="nvim ~/.zshrc && . ~/.zshrc"
  # Prevent nested rangers
  unalias ranger 2>/dev/null
  alias ranger="if [ -z "$RANGER_LEVEL" ]
then
  $(which ranger)
else
  exit
fi
"
whereisip() {
  curl ipinfo.io/$1
}
# Git Aliases
alias gs="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gd="git diff --patience --ignore-space-change"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gm="git merge"
alias gitadddeleted="git ls-files --deleted -z | xargs -0 git rm"
alias gitfixauth="git config user.name \"Taylor\" && git config user.email taylor.bartlett@mfactorengineering.com && git commit --amend --reset-author"
alias gitdisabledirty="git config --add oh-my-zsh.hide-dirty 1"

# -- Sources --
source $HOME/.dotfiles/zsh-prompt.zsh-theme
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ -f $HOME/.zshrc.local ]; then
  . $HOME/.zshrc.local
fi

###-begin-pm2-completion-###
### credits to npm for the completion file model
#
# Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
      COMP_LINE="$COMP_LINE" \
      COMP_POINT="$COMP_POINT" \
      pm2 completion -- "${COMP_WORDS[@]}" \
      2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
      COMP_LINE="$line" \
      COMP_POINT="$point" \
      pm2 completion -- "${words[@]}" \
      2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi
###-end-pm2-completion-###


# Fish like autocomplete
source ~/.dotfiles/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept
export ZSH_AUTOSUGGEST_USE_ASYNC=1
