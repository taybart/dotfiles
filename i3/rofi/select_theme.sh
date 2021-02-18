#!/bin/zsh
theme_loc=/home/taylor/.config/rofi/themes/$1.rasi
rm /home/taylor/.config/rofi/theme
ln -s $theme_loc /home/taylor/.config/rofi/theme
