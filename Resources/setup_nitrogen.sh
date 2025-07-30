#!/bin/bash

cat << EOF > ~/.config/nitrogen/nitrogen.cfg
[geometry]
posx=1004
posy=12
sizex=900
sizey=1052

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs=$HOME/Pictures/Wallpapers;
EOF

cat << EOF > ~/.config/nitrogen/bg-saved.cfg
[xin_-1]
file=$HOME/Pictures/Wallpapers/astronaut.png
mode=4
bgcolor=#000000
EOF