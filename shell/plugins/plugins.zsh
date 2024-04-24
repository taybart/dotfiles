PLUGIN_DIR=$HOME/.dotfiles/shell/plugins

function use {
  p="$PLUGIN_DIR/${1##*/}"
  [ ! -f $p ] && curl -o $p -O "https://raw.githubusercontent.com/$1" 
  source $p
}
function usegit {
  p="$PLUGIN_DIR/${1##*/}"
  [ ! -f $p/$2 ] && \git clone "https://github.com/$1" $p && cd $p && git reset --hard $3 && cd ..
  source $p/$2
}



use rupa/z/d37a763a6a30e1b32766fecc3b8ffd6127f8a0fd/z.sh
use zsh-users/zsh-autosuggestions/c3d4e576c9c86eac62884bd47c01f6faed043fc5/zsh-autosuggestions.zsh

use ohmyzsh/ohmyzsh/5d2d35cd1741af19553007fe0cc5324744fc58fa/plugins/vi-mode/vi-mode.plugin.zsh
use ohmyzsh/ohmyzsh/5d2d35cd1741af19553007fe0cc5324744fc58fa/plugins/fzf/fzf.plugin.zsh

usegit zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting.zsh e0165eaa730dd0fa321a6a6de74f092fe87630b0
