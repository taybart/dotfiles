# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/taylor/.google-cloud-sdk/path.zsh.inc' ]; then . '/Users/taylor/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/taylor/.google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/taylor/.google-cloud-sdk/completion.zsh.inc'; fi

# opam configuration
[[ ! -r /Users/taylor/.opam/opam-init/init.zsh ]] || source /Users/taylor/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

