#!/usr/bin/env bash

# set -e

exec &> tee /var/log/my_install_script.log

function cecho(){
    local color_code=$1
    local message=$2
    echo -e "\033[38;5;${color_code}m${message}\033[0m"
}

if [[ $EUID -ne 0 ]]; then
    cecho 1 "This script must be run as root. Use sudo."
fi

function ctrl_c() {
    cecho 2 "Exiting script..."
    exit 1
}
trap ctrl_c INT

major_packages="alacritty screenkey btop neovim eza vim fzf yazi xclip unzip wget curl gzip tar bash zsh sh firefox nvtop fastfetch glxinfo entr figlet trash-cli bat rofi vlc libreoffice-still ddgr progress polybar
nitrogen bluez bluez-utils brightnessctl feh xorg-xinput blueman xsettingsd thefuck lazygit conky ntfs-3g qt5ct lxappearance xdotool xorg-xbacklight gucharmap gimp rofi-emoji rofi-calc alsa-utils flameshot luarocks
obs-studio xorg-xdpyinfo acpi git tmux grep ripgrep nushell jq kitty go nodejs zoxide viu wezterm picom github-cli mesa-demos intel-media-driver nsxiv grafana bc materia-gtk-theme papirus-icon-theme python-pywal
xfce4-clipman-plugin blueberry sddm gvfs thunar-volman numactl ark reflector vkd3d man man-pages power-profiles-daemon dunst kdenlive wine man-db wireplumber tree sof-firmware winetricks udisks2 intel-ucode tldr
cronie nmtui thunar-archive-plugin thunar-media-tags-plugin noto-fonts-emoji evtest ffmpegthumbnailer tumbler lshw php bind net-tools usbutils wireshark-qt wireshark-cli lldb cppcheck valgrind acpi_call gptfdisk
lxsession baobab composer texlab fd mingw-w64-gcc arandr direnv pandoc obsidian os-prober"

major_package=($major_packages)
major_package+=("gcc clang libc++ cmake ninja libx11 libxcursor mesa-libgl fontconfig")
major_package+=("python-pluggy python-pycosat python-ruamel-yaml")
major_package+=("wine-gecko wine-mono lib32-glibc lib32-gcc-libs lib32-freetype lib32-libpng")
major_package+=("sdl2 sdl2_image sdl2_mixer sdl2_ttf")
major_package+=("lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf")
major_package+=("pipewire pipewire-pulse pipewire-alsa pipewire-jack")
major_package+=("$(pacman -Sgq nerd-fonts)")
major_package+=("gvfs gvfs-mtp gvfs-afc")
major_package+=("cuda cudnn")
major_package+=("mpv xorg-xwininfo xorg-xrandr")
major_package+=("zathura zathura-pdf-mupdf")

minimal_packages=("btop" "neovim" "eza" "vim" "fzf" "yazi" "unzip" "wget" "curl" "gzip" "tat" "bash" "zsh" "sh" "fastfetch" "trash-cli" "bat" "ddgr" "brightnessctl" "lazygit" "ntfs-3g" "qt5ct" "git" "tmux"
                   "grep" "ripgrep" "man-db" "zoxide" "mesa-demos" "bc" "tree" "nmtui" "wireshark-qt" "wireshark-cli" "lxsession" "mingw-w64-gcc" "direnv" "pandoc" "os-prober")

function install_packages(){
    cecho 2 "Installing Packman Packages..."
    local package_type=$1
    if [[ $package_type == "major" ]]; then
        for package in "${major_package[@]}"; do
            cecho 2 "Installing $package"
            sudo pacman -S --noconfirm "$package" || { cecho 1 "Failed to install $package"; exit 1; }
        done
    elif [[ $package_type == "minimal" ]]; then
        for package in "${minimal_packages[@]}"; do
            cecho 2 "Installing $package"
            # sudo pacman -S --noconfirm "$package" || { cecho 1 "Failed to install $package"; exit 1; }
        done
    else
        cecho 1 "Invalid Install Type."
    fi
}

function install_yay(){
    read -e -p "Install Yay (Y|n)? " install_yay
    if [ -z $install_yay ] || [ "${install_yay,,}" == "y"]; then
        cecho 2 "Install Yay..."
        sudo pacman -S --needed base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
        cd ~

        cecho 2 "Install Package from Yay...(Will have to do it manually.)"
        yay -S --noconfirm iriunwebcam-bin brave whatsie-git signal-desktop ascii-image-converter ani-cli getnf rxvt-unicode also-utils pywal spotify-adblock-git unicode autotiling-rs-git ascii-draw \
        aseprite kotatsu-dl-git rofi-greenclip tokyonight-gtk-theme-git qt5-graphicaleffects geogebra-6-electron tensorrt dxvk-bin dxvk terraform  \
        aws-cli-v2-bin xwinwrap-git gowall yt-dlp ttf-ms-win11-auto
    fi
}

function install_anaconda(){
    cecho 2 "Install Anaconda..."
    wget -P ~/Downloads/ https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
    chmod +x ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh
    bash ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh
    conda init
}

function setup_git(){
    git config --global user.email "nico.zero.0x@gmail.com"
    git config --global user.name "Crimson-Genesis"
}

function config_git(){
    cd ~ && mkdir clone

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
}


function config_major(){
    systemctl --user enable pipewire pipewire-pulse wireplumber && sudo systemctl --user start pipewire pipewire-pulse wireplumber
    systemctl status udisks2
    grub-mkconfig -o /boot/grub/grub.cfg
}

function config_minimal(){
    install_yay "m"inimal"
}

function update_system(){
    cecho 2 "Updating System..."
    sudo pacman -Syu
}

# printf "%s\n" ${minimal_packages[@]}
