#!/bin/bash

FIREFOXFOLDER=~/.mozilla/firefox/
PROFILENAME=""
GNOMISHEXTRAS=false

while getopts 'f:p:g' flag; do
	case "${flag}" in    
		f) FIREFOXFOLDER="${OPTARG}" ;;
		p) PROFILENAME="${OPTARG}" ;;
		g) GNOMISHEXTRAS=true ;;
	esac
done

# Set and enter Firefox folder
cd $FIREFOXFOLDER

if test -z "$PROFILENAME" 
	then
		if [[ $(grep '\[Profile[^0]\]' profiles.ini) ]]
			then PROFPATH=$(grep -E '^\[Profile|^Path|^Default' profiles.ini | grep -1 '^Default=1' | grep '^Path' | cut -c6-)
			else PROFPATH=$(grep 'Path=' profiles.ini | sed 's/^Path=//')
		fi
	else
	      PROFPATH=$PROFILENAME
fi

THEMEINSTALL="$FIREFOXFOLDER/$PROFPATH/chrome"

git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git $THEMEINSTALL

if [ "$GNOMISHEXTRAS" = true ] ; then
	cd $THEMEINSTALL
    [[ -s customChrome.css ]] || echo >> customChrome.css
	sed -i '1s/^/@import "theme\/hide-single-tab.css";\n/' customChrome.css
	sed -i '2s/^/@import "theme\/matching-autocomplete-width.css";\n/' customChrome.css
fi
