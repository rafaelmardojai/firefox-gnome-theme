<h1 align="center">
	<img src="icon.svg" alt="Firefox GNOME theme" width="100" height="100"/><br>
 Firefox GNOME theme
</h1>

[![GitHub](https://img.shields.io/github/license/rafaelmardojai/firefox-gnome-theme.svg)](https://github.com/rafaelmardojai/firefox-gnome-theme/blob/master/LICENSE)
[![Donate](https://img.shields.io/badge/PayPal-Donate-gray.svg?style=flat&logo=paypal&colorA=0071bb&logoColor=fff)](https://paypal.me/RafaelMardojaiCM)

<p align="center"><strong>A GNOME theme for Firefox</strong></p>

<p align="center">This theme follows lastest GNOME Adwaita style.</p>

![Screenshot of the theme](screenshot.png)

## Description

This is a bunch of CSS code to make Firefox look closer to GNOME's native apps.

This theme is supposed to work with current supported Firefox releases:

- Firefox 80
- Firefox 78 ESR
- Firefox 68 ESR
- Firefox 81 Beta
- Firefox 82 Nightly

## Installation

### Installation script
1. Clone this repo and enter folder:
	```sh
	git clone https://github.com/rafaelmardojai/firefox-gnome-theme/ && cd firefox-gnome-theme
	```

2. Run installation script:
	```sh
	./scripts/install.sh # Standard
	./scripts/install.sh -f ~/.var/app/org.mozilla.firefox/.mozilla/firefox # Flatpak
	```

#### Script options
- `-f <firefox_folder_path>` *optional*
	- Set custom Firefox folder path, for example `~/.mozilla/icecat/`.
	- Default: `~/.mozilla/firefox/`

- `-p <profile_name>` *optional*
	- Set custom profile name, for example `e0j6yb0p.default-nightly`
	- Default: standard default profile

- `-g` *optional*
	- Auto enable GNOMISH extra features `hide-single-tab.css` & `matching-autocomplete-width.css`


### Manual installation
1. Go to `about:support` in Firefox.

2. Application Basics > Profile Directory > Open Directory.

3. Open directory in a terminal.

4. Create a `chrome` directory if it doesn't exist:

	```sh
	mkdir -p chrome
	cd chrome
	```

5. Clone this repo to a subdirectory:

	```sh
	git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git
	```

6. Create single-line user CSS files if non-existent or empty (at least one line is needed for `sed`):

	```sh
	[[ -s userChrome.css ]] || echo >> userChrome.css
	```

7. Import this theme at the beginning of the CSS files (all `@import`s must come before any existing `@namespace` declarations):

	```sh
	sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css
	```

8. Symlink preferences file:

	```sh
	ln -s chrome/firefox-gnome-theme/configuration/user.js ../user.js
	```

9. Restart Firefox.

10. Open Firefox customization panel and move the new tab button to headerbar.

11. Be happy with your new gnomish Firefox.

## Updating
Both manual and script installation methods should create a git clone in `your-profile-folder-path/chrome/firefox-gnome-theme`, so the easiet way to update the theme is to open this folder in terminal and perform a git pull.

```sh
git pull origin master
```

> Note: Running installation script to update after cloning again the repo can work, but also can introduce duplication in CSS sheets.

## Uninstalling
1. Go to your profile folder. (Go to `about:support` in Firefox > Application Basics > Profile Directory > Open Directory)
2. Remove `chrome` folder.

## Scrollbars
To achieve Firefox with overlay scrollbars install [firefox-gnome-scrollbars](https://github.com/rafaelmardojai/firefox-gnome-scrollbars).

## Enabling optional features
Open `chrome/firefox-gnome-theme/userChrome.css` with a text editor and follow instructions to enable extra features. Keep in mind this file might change in future versions and your configuration will be lost. You can copy the @imports you want to enable to a new file named `customChrome.css` directly in your `chrome/firefox-gnome-theme` directory if you want it to survive updates. Remember all @imports must be at the top of the file, before other statements.

Alternatively you can run installation script with `-g` flag to auto install GNOMISH features.

```sh
./scripts/install.sh -g
```

*Those features are not included by default, because can introduce bugs or Firefox functionalities lost.*

- **hide-single-tab.css** *GNOMISH*

	Hide the tab bar when only one tab is open.

	You should move the new tab button somewhere else for this to work, because by default it is on the tab bar too.

- **matching-autocomplete-width.css** *GNOMISH (FF 60-69)*

	Limit the URL bar's autocompletion popup's width to the URL bar's width.
	
	*This feature is included by default for Firefox 70+*
	
- **square-title-buttons.css**

	Use square title buttons old style.

- **normal-width-tabs.css**

	Use normal width tabs.

- **active-tab-contrast.css**

	Active tab better contrast.

- **system-icons.css**

	Use system theme icons instead of Adwaita icons included by theme.

- **drag-window-headerbar-buttons.css**

	Allow drag window from headerbar buttons *GNOMISH* **[BUGGED]**

	It can activate button action, with unpleasant behavior.

- **symbolic-tab-icons.css**

	Make all tab icons look kinda like symbolic icons.

## Known bugs

### CSD have sharp corners
See upstream [bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1408360).

#### Wayland fix:
1. Go to the `about:config` page
2. Search for the `layers.acceleration.force-enabled` preference and set it to true.
3. Now restart Firefox, and it should look good!

#### X11 fix:
1. Go to the `about:config` page 
2. Type `mozilla.widget.use-argb-visuals`
3. Set it as a `boolean` and click on the add button
4. Now restart Firefox, and it should look good!

### Icons color broken with system-icons.css
Icons might appear black where they should be white on some systems. I have no idea why, but you can adjust them directly in the `system-icons.css` file, look for `--gnome-icons-hack-filter` & `--gnome-window-icons-hack-filter` vars and play with css filters.

## Development

If you wanna mess around the styles and change something, you might find these
things useful.

To use the Inspector to debug the UI, open the developer tools (F12) on any
page, go to options, check both of those:

- Enable browser chrome and add-on debugging toolboxes
- Enable remote debugging

Now you can close those tools and press Ctrl+Alt+Shift+I to Inspect the browser
UI.

Also you can inspect any GTK3 application, for example type this into a terminal
and it will run Epiphany with the GTK Inspector, so you can check the CSS styles
of its elements too.

```sh
GTK_DEBUG=interactive epiphany
```

Feel free to use any parts of my code to develop your own themes, I don't force
any specific license on your code.

## Credits
Developed by **[Rafael Mardojai CM](https://github.com/rafaelmardojai)** and [contributors](https://github.com/rafaelmardojai/firefox-gnome-theme/graphs/contributors). Based on **[Sai Kurogetsu](https://github.com/kurogetsusai/firefox-gnome-theme)** original work.

## Donate
If you want to support development, consider donating via [PayPal](https://paypal.me/RafaelMardojaiCM). Also consider donating upstream, [Firefox](https://donate.mozilla.org/) & [GNOME](https://www.gnome.org/support-gnome/).
