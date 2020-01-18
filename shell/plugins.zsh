# -- Plugins --
# source if exist
function sife() {
  [ -f $1 ] && source $1
}
export FZF_DEFAULT_COMMAND='fd --type f'
sife ~/.fzf.zsh
sife $DOTFILES/shell/z/z.sh
sife $DOTFILES/shell/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^E' autosuggest-accept
export ZSH_AUTOSUGGEST_USE_ASYNC=1

unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

autoload -U +X bashcompinit && bashcompinit
[ -f /usr/local/bin/mc ] && complete -o nospace -C /usr/local/bin/mc mc

# -- Sources --
sife $HOME/.zshrc.local
