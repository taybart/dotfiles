# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# opam configuration
[[ ! -r /Users/taylor/.opam/opam-init/init.zsh ]] || source /Users/taylor/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

