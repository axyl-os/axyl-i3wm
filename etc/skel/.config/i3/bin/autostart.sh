#!/bin/env bash

# sets wallpaper using feh
bash $HOME/.config/i3/.fehbg

# polybar
$HOME/.config/i3/bin/launchbar.sh

# Fix cursor
xsetroot -cursor_name left_ptr

# kill if already running
killall -9 picom xfce4-power-manager ksuperkey dunst sxhkd conky eww

# Launch Conkeww
sed -i "s/colors\/color-.*/colors\/color-nord.yuck\")/g" $HOME/.config/conkeww/eww.yuck
eww --config $HOME/.config/conkeww/ open conkeww-main

# Launch Conky
conky -c $HOME/.config/conky/axyl.conkyrc

# sets superkey
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# start hotkey daemon
sxhkd &

# Launch notification daemon
dunst -config $HOME/.config/i3/dunstrc &

# start compositor and power manager
xfce4-power-manager &

while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
picom --config $HOME/.config/i3/picom.conf &

# start polkit
if [[ ! `pidof xfce-polkit` ]]; then
    /usr/lib/xfce-polkit/xfce-polkit &
fi

# replace neovim colorscheme
sed -i "s/theme =.*$/theme = \"nord\",/g" $HOME/.config/nvim/lua/custom/chadrc.lua

# change xfce4-terminal colorscheme
XFCE_TERM_PATH="$HOME/.config/xfce4/terminal"
cp "$XFCE_TERM_PATH"/colorschemes/nord "$XFCE_TERM_PATH"/terminalrc

# change cava colorscheme
CAVA_PATH="$HOME/.config/cava"
cp "$CAVA_PATH"/colorschemes/nord "$CAVA_PATH"/config

## Welcome-App-Run-Once
axyl-welcome &
sed -i -e '/## Welcome-App-Run-Once/Q' "$HOME/.config/i3/bin/autostart.sh"
sed -i -e '/##~~~ Floating Calamares/Q' "$HOME/.config/i3/config"
