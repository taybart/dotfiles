# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
export EDITOR=vim
# Enable command auto-correction.
ENABLE_CORRECTION="true"
platform=$(uname) 
# Plugins (plugins can be found in ~/.oh-my-zsh/plugins/*)
if [ "$platform" = "Darwin" ]
then
        plugins=(brew git osx sudo vagrant)
else
        plugins=(git sudo)
fi


# User configuration
#export PATH="/usr/local/bin:/bin:/sbin:/usr/sbin:/usr/bin"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/opt/X11/bin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/msp430-toolchain/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/taylor/go/bin:/Users/taylor/.rvm/bin"
#
#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

alias ohmyzsh="vim ~/.oh-my-zsh"

# Git Aliases
alias gs="git status"
alias gd="git diff --patience --ignore-space-change"
alias gcb="git checkout -b"
alias gb="git branch"
alias ga="git add"
alias gh="git hist"
alias be="bundle exec"
alias gm="git checkout master"
alias gcm="git commit -m"

# Random Aliases
alias ls="ls -l"
alias notes="vim ~/Documents/notes.txt"
alias v="vim"
alias mpv="mpv -no-border"
alias ranger="if [ -z "$RANGER_LEVEL" ]
        then
                ranger
        else
                exit
        fi
"
alias zshrc="vim ~/.zshrc && . ~/.zshrc"

source $ZSH/oh-my-zsh.sh

fancy-ctrl-z () {
if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
else
        zle push-input
        zle clear-screen
fi
}
zle -N fancy-ctrl-z

bindkey '^Z' fancy-ctrl-z
