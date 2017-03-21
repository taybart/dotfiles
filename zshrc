export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

#  -- Exports --
export TERM="screen-256color"
export EDITOR=vim
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin"
# Enable command auto-correction.
export ENABLE_CORRECTION=true
export DISABLE_AUTO_TITLE=true

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]
then
    plugins=(git osx sudo vagrant)

    export GREP_OPTIONS="-RIns --color=auto --exclude=\"tags\""
    alias ls="ls -G -l"
    alias lsusb="system_profiler SPUSBDataType"
    alias newmacaddr="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
    alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
    alias ctags="`brew --prefix`/bin/ctags"
    function update {
      temp=GREP_OPTIONS
      unset GREP_OPTIONS
      brew update && brew upgrade
      GREP_OPTIONS=temp
    }
    function title {
        echo -ne "\033]0;"$*"\007"
    }
else
    plugins=(git sudo vagrant debian)

    export PATH="$PATH:$HOME/.linuxbrew/bin"
    export GREP_OPTIONS="-RIns --color --exclude=\"tags\""
    alias ls="ls -l --color --block-size=M"
    alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
    alias check-update="sudo apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print \"PROGRAM: $1 INSTALLED: $2 AVAILABLE: $3\n\"}'"
    alias install="sudo apt-get install"
    alias remove="sudo apt-get autoremove"
    alias reboot="sudo reboot"
    alias sa="mosquitto_sub -t '#'"
    alias xup="xrdb ~/.Xresources"

    xmodmap ~/.xmodmap > /dev/null 2>&1
    compton -b --backend glx --vsync opengl-swc > /dev/null 2>&1
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


