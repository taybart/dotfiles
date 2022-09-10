function is_installed() {
  type $1 > /dev/null
  return $?
}


# -- Aliases --
alias q="exit"
alias :q="exit"
alias zshrc="nvim ~/.zshrc && . ~/.zshrc"
alias redis="docker run -p 6379:6379 redis"
alias dev="ENV=development"
alias lzd="lazydocker"
# alias python=python3
alias venv="python3 -m venv .venv && . ./.venv/bin/activate"
alias myip="curl https://taybart.com/ip"
alias ct="certs"
alias y="yarn"
alias p="pnpm"

# jump around
alias j="z"
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}


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
  alias ssh="TERM=xterm-256color ssh"
fi

# Git Aliases
alias gs="git status"
alias gf="git fetch --all --tags"
alias gcm="git commit -m"
alias gco="git checkout"
alias gdc="git diff --cached"
alias gd="git diff --patience --ignore-space-change"
alias GH="gh repo view --web"

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
