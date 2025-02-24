###############
#     Path    #
###############
source "$DOTFILES/shell/essentials.zsh"

export PATH="$HOME/.local/bin"

function add_path() {
  export PATH="$PATH:$1"
}

function add_here() {
  export PATH="$PATH:$(pwd)"
}

# asdf
add_path "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
# macos
add_path "/opt/homebrew/sbin:/opt/homebrew/bin"
# go
export GOPATH="$HOME/.go"
add_path "$GOPATH/bin"
# rust
add_path "$HOME/.cargo/bin"
# deno
add_path "$HOME/.deno/bin"
# python
add_path "$HOME/.poetry/bin:.venv/bin"
# yarn
add_path "$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"

# nixos
add_path "/run/wrappers/bin"
add_path "/run/current-system/sw/bin"

# and finally regular system path
add_path "/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

###############
# Completion  #
###############

# bun completions
[ -s "/Users/taylor/.bun/_bun" ] && source "/Users/taylor/.bun/_bun"

# asdf completions
# [ ! -f "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ] && mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" && asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"

