#!/bin/sh

# A bunch of assumptions are made in this script, and it's really intended for my personal
# use (these are my personal dotfiles after all). It's expecting to run on
# a fedora distro (ideally the most minimal server install), with systemd and an
# internet connection.
# This was originally written on fedora 37/38, but it should be forwards compatible.

# DNF speed hints (thank me later ;) )

printf "\nmax_parallel_downloads=10\n" >> /etc/dnf/dnf.conf
printf "fastestmirror=True\n" >> /etc/dnf/dnf.conf

# Add RPM fusion repos
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update the system before progressing
dnf upgrade -y

# Setup automatic updates (download only, then notify)
# TODO: implement this!:

# Install and enable UFW
dnf install -y ufw
ufw limit 22/tcp
ufw default deny incoming
ufw enable

# Install core system tools we'll need throughout the install
dnf install -y make gcc clang rip-grep git nano neovim wget unzip findutils bat htop

# Development libraries needed for desktop packages
dnf install -y yajl-devel libX11-devel libXft-devel libXinerama-devel \
    libXrender-devel freetype-devel

# Clone dotfiles repo, setup home directory and copy user-level config files
cd /home/$SUDO_USER
sudo -u git clone https://codeberg.org/r4/dotfiles
sudo -u $SUDO_USER mkdir documents projects downloads pics


# Download desktop packages
dnf install -y xorg-x11-server-Xorg sddm picom dunst xsecurelock feh

# Configure xsecurelock (at a global level)
echo "XSECURELOCK_BACKGROUND_COLOR=#111111" >> /etc/environment
echo "XSECURELOCK_AUTH_BACKGROUND_COLOR=#222222" >> /etc/environment
echo "XSECURELOCK_AUTH_FOREGROUND_COLOR=#dddddd" >> /etc/environment
echo "XSECURELOCK_COMPOSITE_OBSCURER=0" >> /etc/environment

# Build remaining desktop packages (dwm, dmenu, dwmblocks-async)
sudo -u $SUDO_USER mkdir desktop-stack
cd desktop-stack
git clone https://github.com/bakkeby/dmenu-flexipatch.git
cd dmenu-flexipatch
sudo -u $SUDO_USER cp ../../dotfiles/patches/dmenu-patches.h patches.h
sudo -u $SUDO_USER cp ../../dotfiles/patches/dmenu-config.h config.h
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install
cd ..

git clone https://github.com/bakkeby/dwm-flexipatch.git
cd dwm-flexipatch
sudo -u $SUDO_USER cp ../../dotfiles/patches/dwm-patches.h patches.h
sudo -u $SUDO_USER cp ../../dotfiles/patches/dwm-config.h config.h
sudo -u $SUDO_USER echo "YAJLLIBS = -lyajl" >> config.mk
sudo -u $SUDO_USER echo "YAJLINC = -I/usr/include/yajl" >> config.mk
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install

cd ..

git clone https://github.com/UtkarshVerma/dwmblocks-async.git
cd dwmblocks-async
sudo -u $SUDO_USER cp ../../dotfiles/patches/dwmblocks-async-config.h config.h
sudo -u $SUDO_USER cp ../../dotfiles/patches/dwmblocks-async-config.c config.c
sudo -u $SUDO_USER make clean
sudo -u $SUDO_USER make all
make install
cd ..

# Install custom fonts (just fira code nerd font for now)
cd /home/$SUDO_USER
sudo -u $SUDO_USER wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip -O fira-code.zip
sudo -u $SUDO_USER mkdir -p firacode
sudo -u $SUDO_USER unzip fira-code.zip -d firacode
cd firacode
mkdir -p /usr/local/share/fonts/firacode
cp Fira* /usr/local/share/fonts/firacode
chown -R root: /usr/local/share/fonts/firacode
chmod 644 /usr/local/share/fonts/firacode/*
restorecon -vFr /usr/local/share/fonts/firacode
cd ..
fc-cache
sudo -u $SUDO_USER rm -r firacode fira-code.zip

# Make sure we boot into the display manager
systemctl set-default graphical.target
# Enable locking screen on sleep
systemctl enable xlock.service

# Install userspace tools
dnf install -y kitty ImageMagick ranger python python3-pillow
dnf install -y speedcrunch vlc firefox flameshot btop

# Install vscode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install -y code
cd /home/$SUDO_USER/dotfiles
cat stash/vscode-extensions | sudo -u $SUDO_USER xargs -n 1 code --install-extensions

# Copy root and user config files, now that everything is installed.
cp -a root/. /
sudo -u $SUDO_USER cp -a ~/dotfiles/home/. .
