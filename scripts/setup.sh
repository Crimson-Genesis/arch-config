#!/usr/bin/env bash
# Setup for Arch-linux...


function ctrl_c() {
    echo "Exiting script..."
    exit 1
}
trap ctrl_c INT

function clone_repo(){
    git clone $1
}

function main(){
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
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        cd ~
        rm .zshrc
        git init
        git branch -M main
        git config --global user.email "nico.zero.0x@gmail.com"
        git config --global user.name "Crimson-Genesis"
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

}
