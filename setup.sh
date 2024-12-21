#!/usr/bin/env bash
# Setup for Arch-linux...


function ctrl_c() {
    echo "Exiting script..."
    exit 1
}
trap ctrl_c INT
echo "Updating System..."
sudo pacman -Syu

echo "Installing Brew..."
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
/usr/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing package from Brew..."
/home/linuxbrew/.linuxbrew/bin/brew install gcc
/home/linuxbrew/.linuxbrew/bin/brew install nodejs
/home/linuxbrew/.linuxbrew/bin/brew install wtf
/home/linuxbrew/.linuxbrew/bin/brew install toipe
/home/linuxbrew/.linuxbrew/bin/brew install php
/home/linuxbrew/.linuxbrew/bin/brew install java
/home/linuxbrew/.linuxbrew/bin/brew install tree-sitter
/home/linuxbrew/.linuxbrew/bin/brew install perl
/home/linuxbrew/.linuxbrew/bin/brew install composer

# Install SSH key in system.
echo "If have the ssh-key setup the just press enter."
echo -n "If not then want to setup (y|N):- "
read setup_ssh

if [ "${setup_ssh,,}" == "y" ]; then
    ssh_add_function () {
        echo "Enter the absolute-dir-path and don't put '/' or '.' in the end of path."
        take_path (){
            read -p "Enter ssh-key dir path:- " path
            read -p "Confirm '$path' this is the path(Y|n)? " confirm    
            if [ "${confirm,,}" == "n" ]; then
                take_path
            fi
        }
        take_path
        ssh_dir="$HOME/.ssh"
        mkdir -p $ssh_dir
        cp -r "$path/." $ssh_dir 
        ssh_key_file="$(find $ssh_dir -type f | fzf)"
        if [ ! -z $ssh_key_file ]; then
            eval "$(ssh-agent -s)"
            ssh-add $ssh_key_file
        else
            restart_or_not () {
                echo "An error occur while setting up ssh_key,"
                echo "Restart ssh-key setup process or do it Manually."
                printf "\n *  r/restat <<\n    m/manually\n\n"
                read -p "choice:- " r_m
                if [ -z $r_m ] || [ "$(r_m)" == "m" ] || [ "$(r_m)" == "manually" ]; then
                    eval zsh
                    read -p "Is setup Done (Y|n)? " done
                    if [ "${done,,}" == "n" ]; then
                        restart_or_not
                    fi
                else
                    ssh_add_function
                fi
            }
            restart_or_not
        fi
    } 
    ssh_add_function
    echo "SSH setup is done."
fi

# Install config from github or not?
read -p "Install config from github (y|N):- " install_config
if [ "${install_config,,}" == "y" ]; then
    echo "Seting Up config..."
    rm -rf ~/.config/rofi/
    rm -rf ~/.config/i3/
    rm -rf ~/.icons/
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    cd ~
    rm .zshrc
    git init
    git branch -M main
    git config --global user.email "zandaxheart955@gmail.com"
    git config --global user.name "nico-Zero"
    git remote add origin git@github.com:nico-Zero/config.git
    git fetch
    git reset origin/main
    git checkout -t origin/main
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    git clone https://github.com/nico-Zero/nvim.git ~/.config/nvim/
    git clone https://github.com/terroo/wallset down-wallset
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k && echo 'source /root/powerlevel10k/powerlevel10k.zsh-theme' >>/root/.zshrc
    cd down-wallset
    sudo sh install.sh
fi

echo "Installing Package from Pacman..."
sudo pacman -S lua
sudo pacman -S cargo
sudo pacman -S java
sudo pacman -S julia
sudo pacman -S ruby

# Install betterlockscreen into system.
git clone https://github.com/Raymo111/i3lock-color.git && cd ~/i3lock-color/ && ./install-i3lock-color.sh
rm -rf ~/i3lock-color
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
betterlockscreen -u ~/wallpaper/anime-girl-red-eye-tattoo-sword-4k-wallpaper-uhdpaper.com-310@0@j.jpg


# installing fonts...
# 1-67" | getnf
# -------------------------------------------------------------------------------------------------------
# do all this first...
# tmux source ~/.config/tmux/tmux.conf (inside tmux)
# Run <Ctrl-b I> inside tmux.
# make a shortcut <Alt-Ctrl-l> to Lunch alacritty
# make a shortcut <Alt-Space> to Lunch rofi (command:- rofi -show drun)
# Open Nvim and Wait for it to config itself.
# And then You are all done.
# Run this command after terminal restart...
# conda update conda
# conda install python=3.11
# conda install build
# pip install installer
# pip install jupyterlab-vim
# pip install neovim
# pip install PyGObject
# npm install -g neovim
# gem install neovim
# conda install -c conda-forge libstdcxx-ng libffi
# Add This line (UUID=A232F5EE32F5C6F7 /mnt/Nova ntfs defaults  0  2) in /etc/fstab
# Add This line (SUBSYSTEM=='backlight', RUN+='/usr/bin/chmod 666 /sys/class/backlight/%k/brightness') in /etc/udev/rules.d/99-backlight.rules
# run 'sudo udevadm control --reload' and 'sudo udevadm trigger'
# Restart the terminal.
# sudo pacman -S dbus libappindicator-gtk3
# sudo pacman -S xdg-desktop-portal
# sudo pacman -S ibus
# sudo pacman -S xscreensaver
# sudo pacman -S --needed gobject-introspection
# sudo pacman -S arc-gtk-theme
# sudo pacman -S pavucontrol

# Dark mode in i3wm.
# ~/.config/gtk-3.0/settings.ini)
# [Settings]
# gtk-theme-name = Materia-dark
# gtk-icon-theme-name = Papirus-Dark
# gtk-cursor-theme-name = Jingyuan
# gtk-cursor-theme-size = 16

# coursor gtk-cursor-theme-name
# ~/.Xresources
# Xcursor.theme: Jingyuan

# This is for netural scrolling in i3wm-arch-linux. mouse
# /etc/X11/xorg.conf.d/40-libinput.conf
#
# Section "InputClass"
#     Identifier "libinput touchpad catchall"
#     MatchIsTouchpad "on"
#     Driver "libinput"
#     Option "Tapping" "on"
#     Option "NaturalScrolling" "true"  # Optional, if you want natural scrolling
# EndSection
# Rorgrongku
#
#
# sudo vim /etc/xdg/reflector/reflector.conf
# sudo systemctl enable reflector.service reflector.timer
# sudo systemctl start reflector.service reflector.timer
#
# this in /etc/X11/xorg.conf.d/40-libinput.conf
#    Option "DisableWhileTyping" "off"

# run this to setup dxvk-bin config for wine:-
# export WINEPREFIX=~/.wine  # Change to your Wine prefix
# setup_dxvk install

# winetricks directx9
# winetricks corefonts
# winetricks vcrun2015
# winetricks corefonts cjkfonts vcrun2019 dxdx9 dxvk ole32 dotnet35 dotnet48
# winetricks --force d3d11
# winetricks --force dxvk
# winetricks --force vcrun2017

# run this to setup dxvk-bin config for wine:-
# export WINEPREFIX=~/.wine  # Change to your Wine prefix
# setup_dxvk install
#
# git clone https://github.com/Fumasu/mf-install
# WINEPREFIX="/home/gaben/.local/share/Steam/steamapps/compatdata/751440/pfx" ./install-mf.sh
# xwinwrap -fs -ni -s -st -sp -b -nf -ov -- mpv --no-border --wid=%WID --loop /path/to/your/video.mp4
#
# grub themes in the /boot/grub/themes/ past the theme here
# grub default setting in -> /etc/default/grub   # change into this dir to chage the grub settings.\
# and then run "sudo grub-mkconfig -o /boot/grub/grub.cfg" the command in the terminal after saving the grub file.
#
#
# sudo pacman -Rns $(pacman -Qdtq)
# to clean up the left overs
#
# sudo pacman -S archlinux-keyring
# sudo pacman-key --refrace-key
# sudo pacman -Scc
# sudo modprobe ath9k_htc
