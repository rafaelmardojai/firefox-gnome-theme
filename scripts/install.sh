#!/usr/bin/env bash

THEMEDIRECTORY=$(cd "$(dirname $0)" && cd .. && pwd)
FIREFOXFOLDER=~/.mozilla/firefox
PROFILENAME=""
THEME="DEFAULT"


# Get options.
while getopts 'f:p:t:' flag; do
	case "${flag}" in
	f) FIREFOXFOLDER="${OPTARG}" ;;
	p) PROFILENAME="${OPTARG}" ;;
	t) THEME="${OPTARG}" ;;
	*)
		echo "Gnome Theme Install Script:"
		echo "  -f <firefox_folder_path>. Set custom Firefox folder path."
		echo "  -p <profile_name>. Set custom profile name."
		echo "  -t <theme_name>. Set the colors used in the theme."
		echo "  -h to show this message."
		exit 0
		;;
	esac
done

function saveProfile(){
	local PROFILE_PATH="$1"

	cd "$FIREFOXFOLDER/$PROFILE_PATH" || { echo "FAIL, Firefox profile path was not found."; exit 1; }
	# Create a chrome directory if it doesn't exist.
	mkdir -p chrome
	cd chrome || { echo "FAIL, couldn't create chrome dir in $PWD, please check if there's something else named 'chrome'."; exit 1; }

	# Copy theme repo inside
	echo "Copying repo in $PWD" >&2
	cp -fR "$THEMEDIRECTORY" "$PWD" || { echo "FAIL, couldn't copy to $PWD/chrome, please check if there's something named 'chrome', that is not a dir."; exit 1; }

	# Create single-line user CSS files if non-existent or empty.
	if [ -s userChrome.css ]; then
		# Remove older theme imports
		sed 's/@import "firefox-gnome-theme.*.//g' userChrome.css | sed '/^\s*$/d' > tmpfile && mv tmpfile userChrome.css
		echo >> userChrome.css
	else
		echo >> userChrome.css
	fi

	# Import this theme at the beginning of the CSS files.
	sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css

	if [ "$THEME" = "DEFAULT" ]; then
		echo "No theme set, using default adwaita." >&2
	else
		echo "Setting $THEME theme." >&2
		echo "@import \"firefox-gnome-theme\/theme/colors/light-$THEME.css\";" >> userChrome.css
		echo "@import \"firefox-gnome-theme\/theme/colors/dark-$THEME.css\";" >> userChrome.css
	fi

	# Create single-line user content CSS files if non-existent or empty.
	if [ -s userContent.css ]; then
		# Remove older theme imports
		sed 's/@import "firefox-gnome-theme.*.//g' userContent.css | sed '/^\s*$/d' > tmpfile1 && mv tmpfile1 userContent.css
		echo >> userContent.css
	else
		echo >> userContent.css
	fi

	# Import this theme at the beginning of the CSS files.
	sed -i '1s/^/@import "firefox-gnome-theme\/userContent.css";\n/' userContent.css

	if [ "$THEME" = "DEFAULT" ]; then
		echo "No theme set, using default adwaita." >&2
	else
		echo "Setting $THEME theme."
		echo "@import \"firefox-gnome-theme\/theme/colors/light-$THEME.css\";" >> userContent.css
		echo "@import \"firefox-gnome-theme\/theme/colors/dark-$THEME.css\";" >> userContent.css
	fi

	cd ..

	echo "Set configuration to user.js file" >&2

	mapfile -t theme_prefs < <( grep "user_pref" chrome/firefox-gnome-theme/configuration/user.js )
	mapfile -t theme_prefs_unvalued < <( grep "user_pref" chrome/firefox-gnome-theme/configuration/user.js|cut -d'"' -f 2 )
	if [ ! -f "user.js" ]; then
		mv chrome/firefox-gnome-theme/configuration/user.js .
	else
		cp user.js user.js.bak
		OLDIFS=$IFS
		IFS='/'
		for t in "${theme_prefs_unvalued[@]}"; do
			sed -i "/$t/d" "user.js"
		done
		for f in "${theme_prefs[@]}"; do
			echo "$f" >> "user.js"
		done
		IFS=$OLDIFS
	fi
	echo "Done." >&2
	cd ..
}

PROFILES_FILE="${FIREFOXFOLDER}/profiles.ini"
if [ ! -f "${PROFILES_FILE}" ]; then
	>&2 echo "FAIL, please check Firefox installation, unable to find 'profile.ini' at ${FIREFOXFOLDER}."
	exit 1
fi
echo "'profiles.ini' found in ${FIREFOXFOLDER}"

PROFILES_PATHS=($(grep -E "^Path=" "${PROFILES_FILE}" | tr -d '\n' | sed -e 's/\s\+/SPACECHARACTER/g' | sed 's/Path=/::/g' ))
PROFILES_PATHS+=::

PROFILES_ARRAY=()
if [ "${PROFILENAME}" != "" ];
	then
		echo "Using ${PROFILENAME} profile"
		PROFILES_ARRAY+=${PROFILENAME}
else
	echo "Finding all available profiles";
	while [[ "$PROFILES_PATHS" ]]; do
		PROFILES_ARRAY+=( "${PROFILES_PATHS%%::*}" )
		PROFILES_PATHS=${PROFILES_PATHS#*::}
	done
fi



if [ ${#PROFILES_ARRAY[@]} -eq 0 ]; then
	echo "FAIL, no Firefox profile found in $PROFILES_FILE".;

else
	for i in "${PROFILES_ARRAY[@]}"
	do
		if [[ -n "$i" ]];
		then
			echo "Installing ${THEME} theme for $(sed 's/SPACECHARACTER/ /g' <<< $i) profile.";
			saveProfile "$(sed 's/SPACECHARACTER/ /g' <<< $i)"
		fi;
	done
fi
