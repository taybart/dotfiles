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
alias ct="certs"

# Git Aliases
alias gs="git status"
alias gf="git fetch --all --tags"
alias gcm="git commit -m"
alias gmom="git fetch --all && git merge origin/master"
alias gco="git checkout"
alias gd="git diff --patience --ignore-space-change"
alias gitclean="git branch --merged master | \grep -v master | xargs -n 1 git branch -d"

# K8s Aliases
# alias kc="kubectl"

alias newredis="helm install redis --set cluster.enabled=false --set usePassword=false bitnami/redis"

# alias notes="nvim ~/.notes/notes"

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  sife $DOTFILES/shell/macos.zsh
else
  sife $DOTFILES/shell/linux.zsh
fi
