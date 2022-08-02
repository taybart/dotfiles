PLUGIN_DIR=$HOME/.dotfiles/shell/plugins

function use {
  p="$PLUGIN_DIR/${1##*/}"
  [ ! -f $p ] && curl -o $p -O "https://raw.githubusercontent.com/$1" 
  source $p
}
function usegit {
  p="$PLUGIN_DIR/${1##*/}"
  [ ! -f $p/$2 ] && git clone "https://github.com/$1" $p
  source $p/$2
}



use rupa/z/master/z.sh
use zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh

use ohmyzsh/ohmyzsh/master/plugins/vi-mode/vi-mode.plugin.zsh
use ohmyzsh/ohmyzsh/master/plugins/fzf/fzf.plugin.zsh

usegit zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting.zsh
