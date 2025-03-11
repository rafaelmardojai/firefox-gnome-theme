#! /usr/bin/env bash

firefoxInstallationPaths=(
    # Firefox
    ~/.mozilla/firefox # Package
    ~/.var/app/org.mozilla.firefox/.mozilla/firefox # Flatpak
    ~/snap/firefox/common/.mozilla/firefox # Snap
    "$HOME/Library/Application Support/Firefox" # MacOS Package
    ~/AppData/Roaming/Mozilla/Firefox # Microsoft Windows

    # Librewolf
    ~/.librewolf # Package
    ~/.var/app/io.gitlab.librewolf-community/.librewolf # Flatpak

    # Floorp
    ~/.floorp # Package
    ~/.var/app/one.ablaze.floorp/.floorp # Flatpak

    # Waterfox
    ~/.var/app/net.waterfox.waterfox/.waterfox # Flatpak
    
)

installScript="./scripts/install.sh"
folderArg=""
foldersFoundCount=0

eval "chmod +x ${installScript}"

for folder in "${firefoxInstallationPaths[@]}"; do
    if [ -d "$folder" ]; then
    echo Firefox installation folder found

    folderArg=" -f \"$folder\""
    eval ${installScript}${folderArg}   
    foldersFoundCount+=1

    fi

done

if [ $foldersFoundCount = 0 ];then
    echo No firefox folder found ;
    fi
