#! /usr/bin/env bash

VERSION=$(curl --silent "https://api.github.com/repos/rafaelmardojai/firefox-gnome-theme/releases/latest" | grep tag_name | cut -d'"' -f4)
FILENAME=firefox-gnome-theme-$VERSION.tar.gz
FOLDERPATH=$PWD/firefox-gnome-theme

if [ -d "$FOLDERPATH" ]; then rm -Rf $FOLDERPATH; fi

mkdir $FOLDERPATH

cd $FOLDERPATH

curl -LJo $FILENAME https://github.com/rafaelmardojai/firefox-gnome-theme/tarball/$VERSION

tar -xzf $FILENAME --strip-components=1
rm $FILENAME

chmod +x scripts/auto-install.sh

./scripts/auto-install.sh

if [ -d "$FOLDERPATH" ]; then rm -Rf $FOLDERPATH; fi
