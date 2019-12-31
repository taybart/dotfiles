# -- Plugins --
# source if exist
function sife() {
  [ -f $1 ] && source $1
}
sife ~/.fzf.zsh
sife $DOTFILES/shell/z/z.sh
sife $DOTFILES/shell/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^E' autosuggest-accept
export ZSH_AUTOSUGGEST_USE_ASYNC=1

autoload -U +X bashcompinit && bashcompinit
[ -f /usr/local/bin/mc ] && complete -o nospace -C /usr/local/bin/mc mc

# -- Sources --
sife $HOME/.zshrc.local
