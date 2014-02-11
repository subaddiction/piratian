#!/bin/bash

# Clean the chroot
lb clean

# Configure live machine hostname, live user and locales
lb config --debian-installer live -b hdd --archive-areas "main contrib non-free" --bootappend-live "boot=live config locales=it_IT.UTF-8 keyboard-layouts=it username=pirata hostname=piratian user-fullname=pirata@piratian"

# Configure basic desktop packages
echo task-gnome-desktop > config/package-lists/desktop.list.chroot

# Configure repository packages
echo "vim byobu ssh-client gnupg seahorse remmina filezilla iceweasel xul-ext-firebug nautilus nautilus-open-terminal gedit gedit-plugins gnome-system-monitor gnome-disk-utility gparted python inkscape python-libxml2 python-numpy blender gimp gimp-gap gimp-plugin-registry autotrace imagemagick create-resources pidgin pidgin-otr ffmpeg vlc" > config/package-lists/piratian.list.chroot

# Packages from additional repos
# debian-multimedia-keyring deb.torproject.org-keyring tor

# Configure the user
rm -rf config/includes.chroot/etc/skel
mkdir -p config/includes.chroot/etc/skel
cp -rT ./home/pirata/ config/includes.chroot/etc/skel/

# Clean & remake the custom /usr/bin
rm -rf config/includes.chroot/usr/bin
mkdir -p config/includes.chroot/usr/bin

# Make a custom /usr/local/bin
mkdir -p config/includes.chroot/usr/local/bin/

# Install firefox
rm -rf config/includes.chroot/usr/local/bin/firefox*
wget "ftp://ftp.mozilla.org/pub/firefox/releases/latest/linux-x86_64/it/firefox-27.0.tar.bz2" -O config/includes.chroot/usr/local/bin/firefox.tar.bz2
tar xjvf config/includes.chroot/usr/local/bin/firefox.tar.bz2 -C config/includes.chroot/usr/local/bin/
ln -s /usr/local/bin/firefox/firefox config/includes.chroot/usr/bin/firefox
rm -rf config/includes.chroot/usr/local/bin/firefox.tar.bz2

# Install thunderbird
rm -rf config/includes.chroot/usr/local/bin/thunderbird*
wget "ftp://ftp.mozilla.org/pub/thunderbird/releases/latest/linux-x86_64/it/thunderbird-24.3.0.tar.bz2" -O config/includes.chroot/usr/local/bin/thunderbird.tar.bz2
tar xjvf config/includes.chroot/usr/local/bin/thunderbird.tar.bz2 -C config/includes.chroot/usr/local/bin/
ln -s /usr/local/bin/thunderbird/thunderbird config/includes.chroot/usr/bin/thunderbird
rm -rf config/includes.chroot/usr/local/bin/thunderbird.tar.bz2



# Custom additional repositories
echo "#Piratian additional repositories" > config/archives/piratian.list.chroot

# Finally, build your piratian system
lb build
