#!/usr/bin/env bash

VERSION=$(curl --silent "https://api.github.com/repos/rafaelmardojai/firefox-gnome-theme/releases/latest" | grep tag_name | cut -d'"' -f4)
FILENAME=firefox-gnome-theme-$VERSION.tar.gz

(

cd $(mktemp -d) || exit 1
mkdir firefox-gnome-theme
cd firefox-gnome-theme

curl -LJo $FILENAME https://github.com/rafaelmardojai/firefox-gnome-theme/tarball/$VERSION

tar -xzf $FILENAME --strip-components=1

chmod +x scripts/auto-install.sh

./scripts/auto-install.sh

)
