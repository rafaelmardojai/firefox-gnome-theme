#! /usr/bin/env bash

sysThemeNames=("'Pop'" "'Pop-dark'" "'Pop-light'" "'Yaru'" "'Yaru-dark'" "'Yaru-light'" "'Adwaita-maia'" "'Adwaita-maia-dark'")
themeNames=("pop" "pop" "pop" "yaru" "yaru" "yaru" "maia" "maia")

firefoxInstallationPaths=(
    ~/.mozilla/firefox
    ~/.var/app/org.mozilla.firefox/.mozilla/firefox
    ~/.librewolf
    ~/.var/app/io.gitlab.librewolf-community/.librewolf
    ~/snap/firefox/common/.mozilla/firefox
)

currentTheme=$(gsettings get org.gnome.desktop.interface gtk-theme ) || currentTheme=""
installScript="./scripts/install.sh"
themeArg=""
folderArg=""
foldersFoundCount=0

eval "chmod +x ${installScript}"

for i in "${!sysThemeNames[@]}"; do
   if [[ "${sysThemeNames[$i]}" = "${currentTheme}" ]]; then
        themeArg=" -t ${themeNames[i]}"
   fi
done

for folder in "${firefoxInstallationPaths[@]}"; do
    if [ -d $folder ]; then
    echo Firefox installation folder found

    folderArg=" -f $folder"
    eval ${installScript}${themeArg}${folderArg}   
    foldersFoundCount+=1

    fi

done

if [ $foldersFoundCount = 0 ];then
    echo No firefox folder found ;
    fi
