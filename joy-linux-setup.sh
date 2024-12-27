#!/bin/bash

set -e

# Function to install packages for Debian-based distros
debian_install() {
    sudo apt update && sudo apt upgrade -y
    sudo apt install git curl apt-transport-https preload bleachbit tlp lolcat btop cmatrix gamemode bash-completion nala wget -y

    if grep -q Ubuntu /etc/os-release; then
        sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
        sudo apt install ubuntu-restricted-extras fastfetch -y
        sudo add-apt-repository ppa:kisak/kisak-mesa -y
        sudo dpkg --add-architecture i386
        sudo apt update && sudo apt upgrade -y
        sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y
    fi
}

# Function to install packages for Fedora-based distros
fedora_install() {
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf config-manager --enable fedora-cisco-openh264 -y
    sudo dnf copr enable elxreno/preload -y
    sudo dnf copr enable rafatosta/zapzap -y

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | \
        sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

    sudo dnf check-update

    sudo dnf install mesa-vulkan-drivers git curl wget preload bleachbit zapzap tlp lolcat btop cmatrix gamemode bash-completion \
                    go fastfetch migrate google-chrome-stable code kitty steam docker-ce docker-ce-cli containerd.io \
                    docker-buildx-plugin docker-compose-plugin -y

    sudo dnf group install multimedia -y
    sudo dnf install dnf-plugins-core -y
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
}

# Function to install packages for Arch-based distros
arch_install() {
    if ! command -v paru &> /dev/null; then
        echo "Installing Paru AUR helper..."
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si
        cd ..
        rm -rf paru
    fi

    paru -Syu --noconfirm
    paru -S git curl preload bleachbit tlp lolcat btop cmatrix gamemode bash-completion nala wget \
           mesa-vulkan-drivers steam starship kitty code google-chrome brave-bin discord spotify zapzap-bin gimp krita aseprite nerd-fonts-fira-code
}

# Detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                echo "Detected Debian-based distro: $ID"
                debian_install
                ;;
            fedora)
                echo "Detected Fedora-based distro"
                fedora_install
                ;;
            arch)
                echo "Detected Arch-based distro: $ID"
                arch_install
                ;;
            *)
                echo "Unsupported distro: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect the Linux distribution. Unsupported system."
        exit 1
    fi
}

# Install terminal prompt and emulator
install_terminal_tools() {
    echo "Installing terminal tools..."
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    if ! command -v kitty &> /dev/null; then
        echo "Ensure Kitty terminal is installed as per your distro's method."
    fi
}

# Main script execution
main() {
    detect_distro
    install_terminal_tools
    echo "Setup complete! Reboot your system to apply changes."
}

main
