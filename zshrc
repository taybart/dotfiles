# https://gitorious.org/topmenu/pages/Home
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Check for platform
platform=$(uname)

source $ZSH/oh-my-zsh.sh

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(prompt_git_info)%{$fg_bold[blue]%} % %{$reset_color%}'

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

# Aliases
alias notes="vim ~/.notes"
alias ennotes="~/.dotfiles/notes"
alias v="vim"
alias q="exit"
alias mpv="mpv -no-border"
alias zshrc="vim ~/.zshrc && . ~/.zshrc"
alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
alias xup="xrdb ~/.Xresources"
alias hangups="hangups --col-scheme solarized-dark"
alias ohmyzsh="vim ~/.oh-my-zsh"
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
if [ "$platform" = "Darwin" ]
then
        plugins=(brew git osx sudo vagrant)
        alias ls="ls -G -l"
else
        plugins=(git sudo vi-mode)
        alias ls="ls -l --color --block-size=M"
        alias update="sudo apt-get update && sudo apt-get upgrade"
        alias ccat="pygmentize -g"
        alias install="sudo apt-get install"
        alias remove="sudo apt-get autoremove"
        alias noise="play -n synth 60:00 brownnoise"
        xmodmap ~/.xmodmap > /dev/null 2>&1 
        compton -b --backend glx --vsync opengl-swc
        alias goto=google_app_func
        google_app_func() {
            google-chrome --app=$1
        }
fi

# Exports
export EDITOR=vim
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/opt/X11/bin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/msp430-toolchain/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/taylor/go/bin:/Users/taylor/.rvm/bin:/usr/games:$HOME/dotfiles:$PATH:/usr/local/LPCXpresso/tools/bin:$HOME/.rvm/bin"

