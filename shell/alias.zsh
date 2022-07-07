function is_installed() {
  test $1 > /dev/null
}


# -- Aliases --
alias q="exit"
alias :q="exit"
alias zshrc="nvim ~/.zshrc && . ~/.zshrc"
alias redis="docker run -p 6379:6379 redis"
alias dev="ENV=development"
alias lzd="lazydocker"
alias python=python3
alias venv="python3 -m venv .venv && . ./.venv/bin/activate"
alias myip="curl https://taybart.com/ip"
alias j="z"
alias ct="certs"
alias y="yarn"
alias p="pnpm"

if is_installed btm; then
  alias btm="btm -b"
  alias top="btm"
fi

if is_installed bat; then
  alias bat="bat --map-syntax='*.rest:Terraform'"
  alias cat="bat --pager never"
fi

alias luamake=$HOME/.local/share/nvim/lua-language-server/3rd/luamake/luamake

if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
fi

# Git Aliases
alias gs="git status"
alias gf="git fetch --all --tags"
alias gcm="git commit -m"
alias gco="git checkout"
alias gdc="git diff --cached"
alias gd="git diff --patience --ignore-space-change"
# alias gitclean="git branch --merged master | \grep -v master | xargs -n 1 git branch -d"

# K8s Aliases
# alias kc="kubectl"

alias newredis="helm install redis --set cluster.enabled=false --set usePassword=false bitnami/redis"

alias pt="printf '\033]2;%s\033\\'"
# alias notes="nvim ~/.notes/notes"

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  sife $DOTFILES/shell/macos.zsh
else
  sife $DOTFILES/shell/linux.zsh
fi
