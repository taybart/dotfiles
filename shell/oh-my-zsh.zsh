# Enable command auto-correction.
export ENABLE_CORRECTION=true
export DISABLE_AUTO_TITLE=true
# zsh plugins
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  plugins=(
    docker
    docker-compose
    git
  )
elif [ -f /etc/debian_version ]; then
  plugins=(
    git
    sudo
    debian
    docker-compose
  )

elif [ -f /etc/redhat-release ]; then
  plugins=(
    git
    sudo
    fedora
  )
elif [ -f /etc/arch-release ]; then
  plugins=(
    git
    sudo
  )
elif `grep -Fq Amazon /etc/system-release`; then
  plugins=(
    git
    sudo
    docker
    docker-compose
    )
fi
source $ZSH/oh-my-zsh.sh
# theme
source $DOTFILES/shell/zsh-prompt.zsh-theme
