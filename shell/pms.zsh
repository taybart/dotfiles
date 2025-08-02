# fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# gcloud
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# opam configuration
[[ ! -r /Users/taylor/.opam/opam-init/init.zsh ]] || source /Users/taylor/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# minio
[ -f /usr/local/bin/mc ] && complete -o nospace -C /usr/local/bin/mc mc

# bun completions
[ -s "/Users/taylor/.bun/_bun" ] && source "/Users/taylor/.bun/_bun"

[ -f ${HOME}/.ghcup/env ] && source ${HOME}/.ghcup/env

# Bun
export BUN_INSTALL="/Users/taylor/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
