<h1 align="center">
	<img src="icon.svg" alt="Firefox GNOME theme" width="100" height="100"/><br>
 Firefox GNOME theme
</h1>

<center>
![GitHub](https://img.shields.io/github/license/rafaelmardojai/firefox-gnome-theme.svg)
[![Donate](https://img.shields.io/badge/PayPal-Donate-gray.svg?style=flat&logo=paypal&colorA=0071bb&logoColor=fff)](https://paypal.me/RafaelMardojaiCM)
</center>

<p align="center">A GNOME theme for Firefox 60+</p>

<p align="center"><em>(This theme follows lastest GNOME default gtk theme adwaita)</em></p>

![Screenshot of the theme](screenshot.png)

## Description

This is a bunch of CSS code to make Firefox look closer to GNOME's default
theme.

The `master` branch track current Firefox and GNOME stable.

## Installation

### Installation script
*Coming soon!*

### Manual installation
1. Go to `about:support` in Firefox.
2. Application Basics > Profile Directory > Open Directory.
3. Create a folder named `chrome`.
4. Copy `theme` folder and `userChrome.css` file to your `chrome` Firefox folder.
5. If you are using Firefox 69+:
	1. Go to `about:config` in Firefox.
	2. Search for `toolkit.legacyUserProfileCustomizations.stylesheets` and set it to `true`.
7. Restart Firefox.
8. Open Firefox customization panel and:
	1. Use *Title bar* option to toggle CSD if is not set by default.
	2. Move the new tab button to headerbar.
	3. Select light or dark variants on theme switcher.
9. Be happy with your new gnomish Firefox.

## Enabling optional features
Open `userChrome.css` with a text editor and follow instructions to enable extra features. Keep in mind this file might change in future versions and your configuration will be lost. You can copy the @imports you want to enable to a new file named `customChrome` directly in your `chrome` directory if you want it to survive updates. Remember all @imports must be at the top of the file, before other statements.

## Known bugs

### CSD have sharp corners
See upstream [bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1408360).

### Icons color broken
Icons might appear black where they should be white on some systems. I have no idea why, but you can adjust them in the `theme/colors/light.css` or `theme/colors/dark.css` files, look for `--gnome-icons-hack-filter` var and play with css filters.

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
Developed by **Rafael Mardojai** and [contributors](https://github.com/rafaelmardojai/firefox-gnome-theme/graphs/contributors). Based on **[Sai Kurogetsu](https://github.com/kurogetsusai/firefox-gnome-theme)** original work.

# Donate
If you want to support development, consider donating via [PayPal](https://paypal.me/RafaelMardojaiCM). Also consider donating upstream, [Firefox](https://donate.mozilla.org/) & [GNOME](https://www.gnome.org/support-gnome/).