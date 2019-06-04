# Firefox GNOME Theme
A GNOME theme for Firefox 60+.

*This theme follows lastest GNOME default gtk theme adwaita*

![Screenshot of the theme](screenshot.png)

## Description

This is a bunch of CSS code to make Firefox look closer to GNOME's default
theme.

The `master` branch track current Firefox and GNOME stable.

## Installation

### Manual installation
1. Go to `about:support` in Firefox.
2. Application Basics > Profile Directory > Open Directory.
3. Create a folder named `chrome`.
4. Copy `userChrome.css` file and `theme` folder in `chrome`.
5. Go to `about:config` in Firefox.
6. Search for `toolkit.legacyUserProfileCustomizations.stylesheets` and set it to `true`.
7. Restart Firefox.
8. Open Firefox customization panel and:
	1. Use *Title bar* option to toggle CSD if is not set by default.
	2. Move the new tab button to headerbar
	3. Select light or dark variants on theme switcher.
9. Be happy with your new gnomish Firefox.


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
Developed by **Rafael Mardojai** and contributors. Based on **Sai Kurogetsu** work.
