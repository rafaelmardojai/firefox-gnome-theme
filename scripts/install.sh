#!/bin/bash

THEMEDIRECTORY=$(cd `dirname $0` && cd .. && pwd)
FIREFOXFOLDER=~/.mozilla/firefox
PROFILENAME=""
THEME=DEFAULT

# Determine firefox profile being currently used programatically
# credits: https://stackoverflow.com/questions/57526217/
function current_profile() {
	pgrep firefox | xargs -I{} lsof -p {} 2>/dev/null | grep .parentlock |
		awk '{for(i=9;i<=NF;++i)printf $i""FS ; print ""}'  | cut -d'/' -f6
}


# Get options.
while getopts 'f:p:g:t:h' flag; do
	case "${flag}" in
		f) FIREFOXFOLDER="${OPTARG}" ;;
		p) PROFILENAME="${OPTARG}" ;;
		t) THEME="${OPTARG}" ;;
		h) 
		echo "Gnome Theme Install Script:"
		echo "  -f <firefox_folder_path>. Set custom Firefox folder path."
		echo "  -p <profile_name>. Set custom profile name."
		echo "  -t <theme_name>. Set the colors used in the theme."
		echo "  -h to show this message."
		exit 0
		;;
	esac
done

# Define profile folder path.
if test -z "$PROFILENAME"
	then
		PROFILEFOLDER="$FIREFOXFOLDER/$(current_profile)"
	else
		PROFILEFOLDER="$FIREFOXFOLDER/$PROFILENAME"
fi

# Enter Firefox profile folder.
if ! cd $PROFILEFOLDER ; then
	echo "Error entering profile folder."
	echo "Try using -p flag to specify a custom profile name."
	exit 1
fi

echo "Installing theme in $PWD"

# Create a chrome directory if it doesn't exist.
mkdir -p chrome
cd chrome

# Copy theme repo inside
echo "Copying repo in $PWD"
cp -R $THEMEDIRECTORY $PWD

# Create single-line user CSS files if non-existent or empty.
[[ -s userChrome.css ]] || echo >> userChrome.css

# Import this theme at the beginning of the CSS files.
sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css

if [ $THEME != "DEFAULT" ]; then
	if [ $THEME = "yaru" ]; then
		echo "Setting $THEME theme."
		echo '@import "firefox-gnome-theme\/theme/colors/light-yaru.css";' >> userChrome.css
		echo '@import "firefox-gnome-theme\/theme/colors/dark-yaru.css";' >> userChrome.css
	fi
else
	echo "No theme set, using default adwaita."
fi

cd ..

# Symlink user.js to firefox-gnome-theme one.

echo "Set configuration user.js file"
if ! ln -s chrome/firefox-gnome-theme/configuration/user.js user.js ; then
	echo "Please, manually copy theme's user.js contents to yours."
fi

echo "Done."

