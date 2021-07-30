#!/usr/bin/env zsh

kitty --name 'fzfmenu' \
  -o remember_window_size=no \
  -o initial_window_width=400 \
  -o initial_window_height=400 \
  -o window_border_width=20pt \
  -o hide_window_decorations=no \
  -o window_padding_width=10 \
  -- /home/taylor/.i3/getexe
