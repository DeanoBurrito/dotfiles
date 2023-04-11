#!/bin/sh

# DNF speed hints
printf "\nmax_parallel_downloads=10\n" >> /etc/dnf/dnf.conf
printf "fastestmirror=True\n" >> /etc/dnf/dnf.conf

# Add RPM fusion repos
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "[Install] Updating system before progressing."
dnf upgrade -y

echo "[Install] Installing core tools."
dnf install -y make gcc clang git nano wget unzip

# TODO: install development libs required for building other tools
dnf install -y yajl-devel libX11-devel libXft-devel libXinerama-devel \
    libXrender-devel freetype-devel

echo "[Install] Creating base directory structure"
cd /home/$SUDO_USER
sudo -u $SUDO_USER mkdir documents projects downloads pictures .config

echo "[Install] Cloning dotfiles"
sudo -u $SUDO_USER git clone https://codeberg.org/r4/dotfiles
sudo -u $SUDO_USER cp dotfiles/cfg/alacritty.yml .config/alacritty.yml

echo "[Install] Installing display manager and Xorg"
dnf install -y xorg-x11-server-Xorg sddm picom
cd /home/$SUDO_USER
cp dotfiles/x/20-touchpad.conf /etc/X11/xorg.conf.d/
sudo -u $SUDO_USER cp dotfiles/cfg/.bashrc .bashrc
sudo -u $SUDO_USER cp dotfiles/cfg/.picom.conf .config/picom.conf

systemctl set-default graphical.target

read -p "Do you want to use the included .Xresources?" use_default_xres
if [ $use_default_xres = "y" ] || [ $use_default_xres = "yes" ]; then
    echo "[Install] Copying .Xresources."
    sudo -u $SUDO_USER cp dotfiles/cfg/.Xresources .Xresources
else
    echo "[Install] Not copying .Xresources."
fi

echo "[Install] Installing desktop stack (dwm/dmenu/slstatus)"
cd /home/$SUDO_USER
sudo -u $SUDO_USER git clone https://github.com/bakkeby/dmenu-flexipatch.git
sudo -u $SUDO_USER cp dotfiles/patches/dmenu-config.h dmenu-flexipatch/config.h
sudo -u $SUDO_USER cp dotfiles/patches/dmenu-patches.h dmenu-flexipatch/patches.h
cd dmenu-flexipatch
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install
cd ..
sudo -u $SUDO_USER rm -rf dmenu-flexipatch

cd /home/$SUDO_USER
sudo -u $SUDO_USER git clone https://github.com/bakkeby/dwm-flexipatch.git
sudo -u $SUDO_USER cp dotfiles/patches/dwm-config.h dwm-flexipatch/config.h
sudo -u $SUDO_USER cp dotfiles/patches/dwm-patches.h dwm-flexipatch/patches.h
cd dwm-flexipatch
sudo -u $SUDO_USER echo "YAJLLIBS = -lyajl" >> config.mk
sudo -u $SUDO_USER echo "YAJLINC = -I/usr/include/yajl" >> config.mk
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install
cd ..
sudo -u $SUDO_USER rm -rf dwm-flexipatch

echo "[Install] Installing FiraCode nerd-font"
cd /home/$SUDO_USER
sudo -u $SUDO_USER wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip -O fira-code.zip
sudo -u $SUDO_USER mkdir -p firacode
sudo -u $SUDO_USER unzip fira-code.zip -d firacode
cd firacode
mkdir -p /usr/local/share/fonts/firacode
cp Fira* /usr/local/share/fonts/firacode
chown -R root: /usr/local/share/fonts/firacode
chmod 644 /usr/local/share/fonts/firacode/*
restorecon -vFr /usr/share/fonts/firacode
cd ..
sudo -u $SUDO_USER rm -r firacode fira-code.zip

# TODO: slstatus
# TODO: lockscreen

echo "[Install] Installing userspace programs nvim"
dnf -y install vlc alacritty ranger firefox speedcrunch polybar
# TODO: what other programs do we frequently use?

read -p "Install VScode?" use_vscode
if [ $use_vscode = "y" ] || [ $use_vscode = "yes" ]; then
    echo "[Install] Installing VScode."
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf install -y code
else
    echo "[Install] Skipping VScode install"
fi

read -p "Build cross compiler toolchains?" gen_osdev_tools
if [ $gen_osdev_tools = "y" ] || [ $gen_osdev_tools = "yes "]; then
    echo "[Install] Building cross-compiler toolchain"
    cd /home/$SUDO_USER
    # TODO: toolchain gen
else
    echo "[Install] Not building cross-compiler tools."
fi
