
sysThemeNames=("'Pop-dark'" "'Pop-light'" "'Yaru-dark'" "Yaru-light")
themeNames=("pop" "pop" "yaru" "yaru")

firefoxInstalationPaths=(
    ~/.mozilla/firefox
    ~/.var/app/org.mozilla.firefox/.mozilla/firefox
)

VERSION=$(curl -s "https://github.com/rafaelmardojai/firefox-gnome-theme/releases/latest/download" 2>&1 | sed "s/^.*download\/\([^\"]*\).*/\1/")
FILENAME=firefox-gnome-theme-$VERSION.tar.gz
FOLDERPATH=$PWD/firefox-gnome-theme

if [ -d "$FOLDERPATH" ]; then rm -Rf $FOLDERPATH; fi

mkdir $FOLDERPATH

cd $FOLDERPATH

curl -LJo $FILENAME https://github.com/rafaelmardojai/firefox-gnome-theme/tarball/$VERSION

tar -xzf $FILENAME --strip-components=1
rm $FILENAME

chmod +x scripts/install.sh

currentTheme=$(gsettings get org.gnome.desktop.interface gtk-theme ) || currentTheme=""
installScript="./scripts/install.sh"
themeArg=""
folderArg=""
foldersFoundCount=0

for i in "${!sysThemeNames[@]}"; do
   if [[ "${sysThemeNames[$i]}" = "${currentTheme}" ]]; then
        themeArg=" -t ${themeNames[i]}"
   fi
done

for folder in "${firefoxInstalationPaths[@]}"; do
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
if [ -d "$FOLDERPATH" ]; then rm -Rf $FOLDERPATH; fi