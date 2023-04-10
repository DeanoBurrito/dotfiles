#!/bin/sh

# DNF speed hints
printf "\nmax_parallel_downloads=10" >> /etc/dnf/dnf.conf
printf "\nfastestmirror=True" >> /etc/dnf/dnf.conf

# Add RPM fusion repos
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "[Install] Updating system before progressing."
dnf upgrade -y

echo "[Install] Installing core tools."
dnf install -y make gcc clang git nano

# TODO: install development libs required for building other tools
dnf install -y yajl-devel

echo "[Install] Cloning dotfiles"
cd /home/$SUDO_USER
sudo -u $SUDO_USER git clone https://codeberg.org/r4/dotfiles
sudo -u $SUDO_USER cp dotfiles/.alacritty.yml .alacritty.yml

echo "[Install] Installing display manager and Xorg"
dnf install -y xorg-x11-server-Xorg lightdm
cd /home/$SUDO_USER
cp dotfiles/x/20-touchpad.conf /etc/X11/xorg.conf.d/

read -p "Do you want to use the included .Xresources?" use_default_xres
if [$use_default_xres = "y"] || [$use_default_xres = "yes"]; then
    sudo -u $SUDO_USER cp dotfiles/.Xresources ~/.Xresources
fi

echo "[Install] Installing desktop stack (dwm/dmenu/slstatus)"
cd /home/$SUDO_USER
sudo -u $SUDO_USER git clone https://github.com/bakkeby/dmenu-flexipatch.git
sudo -u $SUDO_USER cp dotfiles/dmenu-config.h dmenu-flexipatch/config.h
sudo -u $SUDO_USER cp dotfiles/dmenu-config.h dmenu-flexipatch/patches.h
cd dmenu-flexipatch
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install

cd /home/$SUDO_USER
sudo -u $SUDO_USER git clone https://github.com/bakkeby/dwm-flexipatch.git
sudo -u $SUDO_USER cp dotfiles/dwm-config.h dwm-flexipatch/config.h
sudo -u $SUDO_USER cp dotfiles/dwm-config.h dwm-flexipatch/patches.h
cd dwm-flexipatch
sudo -u $SUDO_USER echo "YAJLLIBS = -lyajl" >> config.mk
sudo -u $SUDO_USER echo "YAJLINC = -I/usr/include/yajl" >> config.mk
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install

echo "[Install] Installing FiraMono nerd-font"
cd /home/$SUDO_USER
sudo -u $SUDO_USER git clone https://github.com/ryanoasis/nerd-fonts
nerd-fonts/install.sh FiraMono

# TODO: slstatus
# TODO: lockscreen

echo "[Install] Installing userspace programs nvim"
dnf -y install vlc alacritty ranger firefox
# TODO: what other programs do we frequently use?

read -p "Install VScode?" install_vscode
if [$use_vscode = "y"] || [$use_vscode = "yes"]; then
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf install -y code
fi

# Generate and install freestanding toolchains
