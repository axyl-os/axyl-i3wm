#!/bin/env bash

source colors

# sets wallpaper using feh
bash $HOME/.config/i3/.fehbg

# polybar
$HOME/.config/i3/bin/i3bar.sh

# Fix cursor
xsetroot -cursor_name left_ptr

# kill if already running
killall -9 picom xfce4-power-manager ksuperkey dunst sxhkd conky

# Launch Conky
conky -c $HOME/.config/conky/axyl.conkyrc

# sets superkey
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# start hotkey daemon
sxhkd &

# Launch notification daemon
dunst \
-geom "280x50-10+38" -frame_width "1" -font "Source Code Pro Medium 10" \
-lb "${bg}FF" -lf "${fg}FF" -lfr "${altbg}FF" \
-nb "${bg}FF" -nf "${fg}FF" -nfr "${altbg}FF" \
-cb "${bg}FF" -cf "#BF616AFF" -cfr "#BF616AFF" &

# start compositor and power manager
xfce4-power-manager &

while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
picom --config $HOME/.config/i3/picom.conf &

# start polkit
if [[ ! `pidof xfce-polkit` ]]; then
    /usr/lib/xfce-polkit/xfce-polkit &
fi

# start udiskie
udiskie &

# replace neovim colorscheme
sed -i "s/theme =.*$/theme = \"everforest\",/g" $HOME/.config/nvim/lua/chadrc.lua

## Welcome-App-Run-Once
axyl-welcome &
sed -i -e '/## Welcome-App-Run-Once/Q' "$HOME"/.config/i3/bin/autostart.sh
