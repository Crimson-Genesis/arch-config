#!/usr/bin/env bash
function ctrl_c() {
    echo "Exiting script..."
    exit 1
}
trap ctrl_c INT

str_packages="alacritty screenkey btop neovim eza vim fzf yazi xclip unzip wget curl gzip tar bash zsh sh firefox nvtop fastfetch glxinfo entr figlet trash-cli bat rofi vlc libreoffice-still ddgr progress polybar
nitrogen bluez bluez-utils brightnessctl feh xorg-xinput blueman xsettingsd thefuck lazygit conky ntfs-3g qt5ct lxappearance xdotool xorg-xbacklight gucharmap gimp rofi-emoji rofi-calc alsa-utils flameshot luarocks
obs-studio xorg-xdpyinfo acpi git tmux grep ripgrep nushell jq kitty man go nodejs zoxide viu wezterm picom github-cli mesa-demos intel-media-driver nsxiv grafana bc materia-gtk-theme papirus-icon-theme python-pywal
xfce4-clipman-plugin blueberry sddm gvfs thunar-volman numactl ark reflector vkd3d man man-pages power-profiles-daemon dunst kdenlive wine man-db wireplumber tree sof-firmware winetricks udisks2 intel-ucode tldr 
cronie nmtui thunar-archive-plugin thunar-media-tags-plugin noto-fonts-emoji evtest ffmpegthumbnailer tumbler lshw php bind net-tools usbutils wireshark-qt wireshark-cli lldb cppcheck valgrind acpi_call gptfdisk"

package_array=($str_packages)
package_array+=("gcc clang libc++ cmake ninja libx11 libxcursor mesa-libgl fontconfig")
package_array+=("python-pluggy python-pycosat python-ruamel-yaml")
package_array+=("wine-gecko wine-mono lib32-glibc lib32-gcc-libs lib32-freetype lib32-libpng")
package_array+=("sdl2 sdl2_image sdl2_mixer sdl2_ttf")
package_array+=("lib32-sdl2 lib32-sdl2_image lib32-sdl2_mixer lib32-sdl2_ttf")
package_array+=("pipewire pipewire-pulse pipewire-alsa pipewire-jack")
package_array+=("$(pacman -Sgq nerd-fonts)")
package_array+=("gvfs gvfs-mtp gvfs-afc")
package_array+=("cuda cudnn")
package_array+=("mpv xorg-xwininfo xorg-xrandr")
package_array+=("zathura zathura-pdf-mupdf")


for package in "${package_array[@]}"; do
    echo "Installing $package..."
    sudo pacman -S --noconfirm "$package" || { echo "Failed to install $package"; exit 1; }
done

echo "Updating System..."
sudo pacman -Syu
read -p "Install Yay (Y|n)? " install_yay
if [ -z $install_yay ] || [ "${install_yay,,}" == "y"]; then
    echo "Install Yay..."
    sudo pacman -S --needed base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    cd ~
fi

echo "Install Package from Yay...(Will have to do it manually.)"
yay -S --noconfirm iriunwebcam-bin brave whatsie-git signal-desktop ascii-image-converter ani-cli getnf rxvt-unicode also-utils pywal spotify-adblock-git unicode autotiling-rs-git ascii-draw \
aseprite kotatsu-dl-git rofi-greenclip tokyonight-gtk-theme-git qt5-graphicaleffects geogebra-6-electron tensorrt dxvk-bin dxvk terraform  \
aws-cli-v2-bin xwinwrap-git gowall yt-dlp

echo "Install Anaconda..."
wget -P ~/Downloads/ https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
chmod +x ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh
bash ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh
conda init

sudo systemctl --user enable pipewire pipewire-pulse wireplumber && sudo systemctl --user start pipewire pipewire-pulse wireplumber
sudo systemctl status udisks2
sudo grub-mkconfig -o /boot/grub/grub.cfg
