#!/bin/bash
cat << EOF > ~/.config/rofi/config.rasi
configuration {
  modi: "drun";
  show: "drun";
  show-icons: true;
  icon-theme: "Papirus-Dark";
}
@theme "$HOME/.config/rofi/catppuccin-default.rasi"
EOF