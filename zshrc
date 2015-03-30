# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Settings
ENABLE_CORRECTION="true"


### User configuration ###
# Variables
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/opt/X11/bin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/msp430-toolchain/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/taylor/go/bin:/Users/taylor/.rvm/bin"
export EDITOR='vim'

source $ZSH/oh-my-zsh.sh


# Compilation flags
# export ARCHFLAGS="-arch x86_64"
PLATFORM=$(uname)
if [[ $PLATFORM == 'Linux' ]]; then
  plugins=(git sudo)
  alias ls="ls -l --color"
else
  plugins=(brew git osx sudo vagrant)
  alias ls="ls -G -l"
fi
# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Aliases
alias v="vim"
alias notes="vim ~/Documents/notes.txt"

