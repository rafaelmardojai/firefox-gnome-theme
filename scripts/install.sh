#!/bin/bash

FIREFOXFOLDER=~/.mozilla/firefox/
PROFILENAME=""
GNOMISHEXTRAS=false

# Get options.
while getopts 'f:p:g' flag; do
	case "${flag}" in    
		f) FIREFOXFOLDER="${OPTARG}" ;;
		p) PROFILENAME="${OPTARG}" ;;
		g) GNOMISHEXTRAS=true ;;
	esac
done

# Define profile folder path.
if test -z "$PROFILENAME" 
	then
		PROFILEFOLDER="$FIREFOXFOLDER/*.default"
	else
		PROFILEFOLDER="$FIREFOXFOLDER/$PROFILENAME"
fi

# Enter Firefox profile folder.
cd $PROFILEFOLDER
echo "Installing theme in $PWD"

# Create a chrome directory if it doesn't exist.
mkdir -p chrome
cd chrome

# Clone theme repo inside
echo "Cloning repo in $PWD"
git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git

# Create single-line user CSS files if non-existent or empty
[[ -s userChrome.css ]] || echo >> userChrome.css

# Import this theme at the beginning of the CSS files
sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css

# If GNOMISH extras enabled, import it in customChrome.css
if [ "$GNOMISHEXTRAS" = true ] ; then
	echo "Enabling GNOMISH extra features"
    [[ -s customChrome.css ]] || echo >> firefox-gnome-theme/customChrome.css
	sed -i '1s/^/@import "theme\/hide-single-tab.css";\n/' firefox-gnome-theme/customChrome.css
	sed -i '2s/^/@import "theme\/matching-autocomplete-width.css";\n/' firefox-gnome-theme/customChrome.css
fi

# Symlink user.js to firefox-gnome-theme one.
echo "Set configuration user.js file"
ln -s chrome/firefox-gnome-theme/configuration/user.js ../user.js

echo "Done."
