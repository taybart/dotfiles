export PS1="\W "
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
alias notes="vim ~/.notes"
alias ennotes="~/.dotfiles/notes"
alias v="vim"
alias mpv="mpv -no-border"
alias q="exit"

if [ -z "$TMUX" ]
then
        alias ranger="if [ -z "$RANGER_LEVEL" ]
        then
                /usr/local/bin/ranger
        else
                exit
        fi
"
fi
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
alias xup="xrdb ~/.Xresources"
alias hangups="hangups --col-scheme solarized-dark"

platform=$(uname)
if [ "$platform" = "Darwin" ]
then
        alias ls="ls -G -l"
else
        alias ls="ls -l --color"
        alias update="sudo apt-get update && sudo apt-get upgrade"
        alias ccat="pygmentize -g"
        alias install="sudo apt-get install"
fi

