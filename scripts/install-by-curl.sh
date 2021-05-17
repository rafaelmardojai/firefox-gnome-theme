#! /bin/bash

VERSION=$(curl -s "https://github.com/rafaelmardojai/firefox-gnome-theme/releases/latest/download" 2>&1 | sed "s/^.*download\/\([^\"]*\).*/\1/")
FILENAME=firefox-gnome-theme-$VERSION.tar.gz
FOLDERPATH=$PWD/firefox-gnome-theme

if [ -d "$FOLDERPATH" ]; then rm -Rf $FOLDERPATH; fi

mkdir $FOLDERPATH

cd $FOLDERPATH

curl -LJo $FILENAME https://github.com/rafaelmardojai/firefox-gnome-theme/tarball/$VERSION

tar -xzf $FILENAME --strip-components=1
rm $FILENAME

chmod +x scripts/auto-install.sh

./auto-install.sh

if [ -d "$FOLDERPATH" ]; then rm -Rf $FOLDERPATH; fi
