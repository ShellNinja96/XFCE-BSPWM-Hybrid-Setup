#!/bin/bash

set -e # Exit on error
sudo apt update

# =========================================================================================================================================================== #
# === 00 - APT INSTALLS ===================================================================================================================================== #
# =========================================================================================================================================================== #

    echo "Installing packages from Debian repositories..."
    sudo apt install -y xfce4-appmenu-plugin bspwm sxhkd nitrogen picom rofi polybar

# =========================================================================================================================================================== #
# === 01 - XFCE4 PANEL & APPMENU PLUGIN ===================================================================================================================== #
# =========================================================================================================================================================== #

    echo "Setting up appmenu GTK module..."
    xfconf-query -c xsettings -p /Gtk/Modules -n -t string -s "appmenu-gtk-module"

    echo "Configuring XFCE4 panel..."
    xfconf-query -c xfce4-panel -p /panels -rR
    xfconf-query -c xfce4-panel -p /plugins -rR
    xfce4-panel --restart
    sleep 5
    xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -t bool -s false --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/length-adjust -t bool -s false --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/length -t int -s 50 --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/size -t int -s 28 --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/position -t string -s "p=0;x=548;y=25" --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -t bool -s true --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -t int -s 1 --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -t double -s 0 -t double -s 0 -t double -s 0 -t double -s 0 --create; sleep 1
    xfconf-query -c xfce4-panel -n -p /plugins/plugin-1 -t string -s "appmenu" --create; sleep 1
    xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids --force-array -t int -s 1 --create; sleep 1
    xfce4-panel --restart

# =========================================================================================================================================================== #
# === 02 - BSPWM, SXHKD & XFCE KEYBOARD SHORTCUTS =========================================================================================================== #
# =========================================================================================================================================================== #

    echo "Setting up BSPWM..."
    xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command --force-array -t string -s "bspwm"
    xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command --force-array -t string -s ""
    xfconf-query -c xfce4-session -p /sessions/Failsafe/Client2_Command --force-array -t string -s ""
    xfconf-query -c xfce4-session -p /sessions/Failsafe/Client3_Command --force-array -t string -s ""
    xfconf-query -c xfce4-session -p /sessions/Failsafe/Client4_Command --force-array -t string -s ""
    xfconf-query -c xfce4-session -p /general/SaveOnExit -n -t bool -s false
    rm -rf ~/.cache/sessions/*
    mkdir -p ~/.config/bspwm
    cp ./ConfigFiles/bspwmrc ~/.config/bspwm/bspwmrc
    chmod +x ~/.config/bspwm/bspwmrc

    echo "Setting up SXHKD..."
    mkdir -p ~/.config/sxhkd
    cp ./ConfigFiles/sxhkdrc ~/.config/sxhkd/sxhkdrc

    echo "Removing XFCE keyboard shortcuts..."
    for shortcut in $(xfconf-query -c xfce4-keyboard-shortcuts -l); do
        xfconf-query -c xfce4-keyboard-shortcuts -p "$shortcut" -t string -s ""
    done

# =========================================================================================================================================================== #
# === 03 - NITROGEN & WALLPAPER ============================================================================================================================= #
# =========================================================================================================================================================== #

    echo "Setting up Nitrogen..."
    mkdir -p ~/.config/nitrogen
    chmod +x ./Resources/setup_nitrogen.sh
    ./Resources/setup_nitrogen.sh
    mkdir -p ~/Pictures/Wallpapers
    cp ./Resources/astronaut.png ~/Pictures/Wallpapers/astronaut.png

# =========================================================================================================================================================== #
# === 04 - PICOM ============================================================================================================================================ #
# =========================================================================================================================================================== #

    echo "Setting up Picom..."
    mkdir ~/.config/picom
    cp ./ConfigFiles/picom.conf ~/.config/picom/picom.conf

# =========================================================================================================================================================== #
# === 05 - XBORDER ========================================================================================================================================== #
# =========================================================================================================================================================== #

    echo "Installing xborder..."
    sudo mkdir /opt/xborder
    sudo cp ./Resources/xborder/* /opt/xborder/
    sudo chmod +x /opt/xborder/xborders
    sudo ln -s /opt/xborder/xborders /usr/local/bin/xborder

# =========================================================================================================================================================== #
# === 06 - ROFI ============================================================================================================================================= #
# =========================================================================================================================================================== #

    echo "Setting up rofi..."
    mkdir -p ~/.config/rofi/
    cp ./ConfigFiles/rofi.catppuccin-mocha.rasi ~/.config/rofi/catppuccin-mocha.rasi
    cp ./ConfigFiles/rofi.catppuccin-default.rasi ~/.config/rofi/catppuccin-default.rasi
    chmod +x ./Resources/setup_rofi.sh
    ./Resources/setup_rofi.sh

# =========================================================================================================================================================== #
# === 07 - CATPPUCCIN & GTK OVERRIDES ======================================================================================================================= #
# =========================================================================================================================================================== #

    echo "Installing Catppuccin Mocha Pink GTK theme..."
    sudo cp -r ./Resources/catppuccin-mocha-pink-standard+default/catppuccin-mocha-pink-standard+default /usr/share/themes/
    sudo cp -r ./Resources/catppuccin-mocha-pink-standard+default/catppuccin-mocha-pink-standard+default-hdpi /usr/share/themes/
    sudo cp -r ./Resources/catppuccin-mocha-pink-standard+default/catppuccin-mocha-pink-standard+default-xhdpi /usr/share/themes/

    echo "Setting up Catppuccin Mocha Pink GTK theme..."
    mkdir -p ~/.config/gtk-4.0
    ln -sf /usr/share/themes/catppuccin-mocha-pink-standard+default/gtk-4.0/assets ~/.config/gtk-4.0/assets
    ln -sf /usr/share/themes/catppuccin-mocha-pink-standard+default/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
    ln -sf /usr/share/themes/catppuccin-mocha-pink-standard+default/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css
    xfconf-query -c xsettings -p /Net/ThemeName -t string -s "catppuccin-mocha-pink-standard+default" --create

    echo "Setting up GTK 3.0 theme overrides..."
    mkdir -p ~/.config/gtk-3.0
    cp ./ConfigFiles/gtk.css ~/.config/gtk-3.0/gtk.css

# =========================================================================================================================================================== #
# === 08 - FUTURE CYAN CURSORS ============================================================================================================================== #
# =========================================================================================================================================================== #

    echo "Installing Future Cyan Cursors..."
    sudo cp -r ./Resources/Future-cyan-cursors/ /usr/share/icons/

    echo "Setting up Future Cyan Cursors..."
    sudo sed -i 's/^Inherits=.*/Inherits=Future-cyan-cursors/' /usr/share/icons/default/index.theme
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -t string -s "Future-cyan-cursors" --create
    
# =========================================================================================================================================================== #
# === 09 - PAPIRUS ICONS ==================================================================================================================================== #
# =========================================================================================================================================================== #

    echo "Installing Papirus Icons (Indigo Folders)..."
    sudo cp -r ./Resources/papirus-icon-theme-indigo-folders/* /usr/share/icons
    xfconf-query -c xsettings -p /Net/IconThemeName -t string -s "Papirus-Dark" --create

# =========================================================================================================================================================== #
# === 10 - JETBRAINS MONO NERD FONT ========================================================================================================================= #
# =========================================================================================================================================================== #

    echo "Installing JetBrainsMono Nerd Fonts..."
    sudo mkdir -p /usr/share/fonts/truetype/JetBrainsMonoNerdFont
    sudo cp ./Resources/JetBrainsMonoNerdFont/*.ttf /usr/share/fonts/truetype/JetBrainsMonoNerdFont/

    echo "Setting up JetBrainsMono Nerd Fonts..."
    xfconf-query -c xsettings -p /Gtk/FontName -t string -s "JetBrainsMono Nerd Font 10" --create
    xfconf-query -c xsettings -p /Gtk/MonospaceFontName -t string -s "JetBrainsMono Nerd Font 10" --create

# =========================================================================================================================================================== #
# === 11 - KITTY ============================================================================================================================================ #
# =========================================================================================================================================================== #

    echo "Installing Kitty..."
    sudo mkdir -p /opt/kitty.app
    sudo cp -r ./Resources/kitty-0.42.2-x86_64/* /opt/kitty.app
    sudo ln -sf /opt/kitty.app/bin/kitty /usr/bin/kitty
    sudo ln -sf /opt/kitty.app/bin/kitten /usr/bin/kitten
    sudo ln -sf /opt/kitty.app/share/applications/kitty.desktop /usr/share/applications/kitty.desktop
    sudo sed -i "s|Icon=kitty|Icon=/opt/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" /usr/share/applications/kitty*.desktop
    sudo sed -i "s|Exec=kitty|Exec=/opt/kitty.app/bin/kitty|g" /usr/share/applications/kitty*.desktop

    echo "Setting up Kitty..."
    mkdir -p ~/.config/kitty
    cp ./ConfigFiles/kitty.conf ~/.config/kitty/kitty.conf
    touch ~/.config/kitty/current-theme.conf
    kitten themes --dump-theme=yes Catppuccin-Mocha > ~/.config/kitty/current-theme.conf

# =========================================================================================================================================================== #
# === 12 - POLYBAR ========================================================================================================================================== #
# =========================================================================================================================================================== #
    
    echo "Setting up polybar..."
    mkdir -p ~/.config/polybar
    cp ./ConfigFiles/polybar.config.ini ~/.config/polybar/config.ini

# =========================================================================================================================================================== #
# === 13 - LIGHTDM GREETER ================================================================================================================================== #
# =========================================================================================================================================================== #
    
    echo "Setting up lightdm-gtk-greeter..."
    sudo cp ./ConfigFiles/lightdm-gtk-greeter.css /etc/lightdm/lightdm-gtk-greeter.css
    sudo cp ./Resources/astronaut.png /etc/lightdm/astronaut.png
    printf '@import url("/etc/lightdm/lightdm-gtk-greeter.css");\n' | sudo tee -a /usr/share/themes/catppuccin-mocha-pink-standard+default/gtk-3.0/gtk.css
    printf 'background=/etc/lightdm/astronaut.png\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'user-background=false\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'theme-name=catppuccin-mocha-pink-standard+default\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'icon-theme-name=Papirus-Dark\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'font-name=JetBrainsMono Nerd Font Mono 10\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'position=63%% 43%%\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'hide-user-image=true\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'indicators=~session;~spacer;~clock;~spacer;~power\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
    printf 'clock-format=%%A, %%-d of %%B %%Y - %%H:%%M\n' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf


# =========================================================================================================================================================== #
# === 14 - REBOOT =========================================================================================================================================== #
# =========================================================================================================================================================== #
    
    read -p "A reboot is required (and advised) in order to complete the setup, press enter to reboot now."
    sudo reboot now

# =========================================================================================================================================================== #