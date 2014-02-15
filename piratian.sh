#!/bin/bash
# Clean the chroot
lb clean

#
rm -rf config/includes.chroot
mkdir config/includes.chroot

# Configure live machine hostname, live user and locales
lb  config --debian-installer live -b hdd --archive-areas "main contrib  non-free" --bootappend-live "boot=live config locales=it_IT.UTF-8  keyboard-layouts=it username=pirata hostname=piratian  user-fullname=pirata@piratian"
# Configure basic desktop packages
echo task-gnome-desktop > config/package-lists/desktop.list.chroot
# Configure repository packages
echo  "deb-multimedia-keyring deb.torproject.org-keyring resolvconf vim byobu ssh-client gnupg seahorse remmina filezilla iceweasel  xul-ext-firebug nautilus nautilus-open-terminal gedit gedit-plugins  gnome-system-monitor gnome-disk-utility gparted python inkscape  python-libxml2 python-numpy blender gimp gimp-gap gimp-plugin-registry  autotrace imagemagick create-resources pidgin pidgin-otr ffmpeg vlc tor"  > config/package-lists/piratian.list.chroot
# Packages from additional repos
# debian-multimedia-keyring deb.torproject.org-keyring tor
# Configure the user
rm -rf config/includes.chroot/etc/skel
mkdir -p config/includes.chroot/etc/skel

#Per aggiornare ad ultima versione home utente
git clone https://github.com/subaddiction/piratian.git piratian-git
cp -rT piratian-git/home/pirata config/includes.chroot/etc/skel
rm -rf piratian-git

###Per inserire una qualsiasi altra home copiata in /home/pirata
#cp -rT ./home/pirata/ config/includes.chroot/etc/skel/


### Clean & remake the custom /usr/bin
rm -rf config/includes.chroot/usr/bin
mkdir -p config/includes.chroot/usr/bin
# Make a custom /usr/local/bin
mkdir -p config/includes.chroot/usr/local/bin/

# Install firefox
rm -rf config/includes.chroot/usr/local/bin/firefox*
wget "ftp://ftp.mozilla.org/pub/firefox/releases/latest/linux-x86_64/it/firefox-27.0.1.tar.bz2" -O config/includes.chroot/usr/local/bin/firefox.tar.bz2
tar xjvf config/includes.chroot/usr/local/bin/firefox.tar.bz2 -C config/includes.chroot/usr/local/bin/
ln -s /usr/local/bin/firefox/firefox config/includes.chroot/usr/bin/firefox
rm -rf config/includes.chroot/usr/local/bin/firefox.tar.bz2
# Install thunderbird
rm -rf config/includes.chroot/usr/local/bin/thunderbird*
wget "ftp://ftp.mozilla.org/pub/thunderbird/releases/latest/linux-x86_64/it/thunderbird-24.3.0.tar.bz2" -O config/includes.chroot/usr/local/bin/thunderbird.tar.bz2
tar xjvf config/includes.chroot/usr/local/bin/thunderbird.tar.bz2 -C config/includes.chroot/usr/local/bin/
ln -s /usr/local/bin/thunderbird config/includes.chroot/usr/bin/thunderbird
rm -rf config/includes.chroot/usr/local/bin/thunderbird.tar.bz2


# Custom additional repositories
cp /usr/share/keyrings/deb-multimedia-keyring.gpg config/archives/deb-multimedia.list.key
echo "deb http://www.deb-multimedia.org wheezy main non-free" > config/archives/deb-multimedia.list.chroot
echo "deb http://www.deb-multimedia.org wheezy main non-free" > config/archives/deb-multimedia.list.binary
cp /usr/share/keyrings/deb.torproject.org-keyring.gpg config/archives/deb.torproject.org.list.key
echo "deb http://deb.torproject.org/torproject.org wheezy main" > config/archives/deb.torproject.org.list.chroot
echo "deb http://deb.torproject.org/torproject.org wheezy main" > config/archives/deb.torproject.org.list.binary

# Default DNS
rm -rf config/includes.chroot/etc/resolvconf/resolv.conf.d/
mkdir -p config/includes.chroot/etc/resolvconf/resolv.conf.d/
touch config/includes.chroot/etc/resolvconf/resolv.conf.d/base
ln -s /etc/resolvconf/run/resolv.conf config/includes.chroot/etc/resolv.conf
echo "nameserver 208.67.222.222" >> config/includes.chroot/etc/resolvconf/resolv.conf.d/base
echo "nameserver 208.67.220.220" >> config/includes.chroot/etc/resolvconf/resolv.conf.d/base
echo "search 208.67.220.220" >> config/includes.chroot/etc/resolvconf/resolv.conf.d/base
echo "search 208.67.222.222" >> config/includes.chroot/etc/resolvconf/resolv.conf.d/base

# Finally, build your piratian system
lb build

