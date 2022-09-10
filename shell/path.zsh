export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

function add_path() {
  export PATH="$PATH:$1"
}

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
add_path "$HOME/.asdf/installs/python/$(asdf current python | awk '{print $2}')/bin/"
add_path "$HOME/.poetry/bin:.venv/bin"

