# Firefox Gnome Dark

![Screenshot of the theme](screenshot.png)

## Description

This is a bunch of CSS code to make Firefox 57+ look closer to GNOME's default
dark theme. It styles the UI and interal Firefox' pages like about: and
view-source:. I only wrote styles for the dark variant, not the light one.

## Installation

Extensions can no longer style UI elements, but we can still use good old
`userChrome.css` and `userContent.css` files. Just drop this repo to your
`chrome` directory:

1. Go to your Firefox profile's directory.
2. Clone this repo to the `chrome` directory:

		git clone 'https://github.com/kurogetsusai/firefox-gnome-dark.git' chrome

You must run Firefox with the dark theme, either by setting it globally as your
default theme in GNOME Tweak Tools, or by running Firefox with the GTK_THEME
variable like this:

		GTK_THEME=Adwaita:dark firefox

You might want to adjust your default link colors so they are more visible on
dark background, either drop the code below into your
`(firefox profile)/user.js` file or change them manually in `about:config`.

		user_pref("browser.active_color", "#cc1a1a");
		user_pref("browser.anchor_color", "#0a8dff");
		user_pref("browser.visited_color", "#0871cc");
		user_pref("browser.display.background_color", "#2e3436");
		user_pref("browser.display.foreground_color", "#ccc");

You can't get rid of the title bar for now (except for Fedora I think, where you
can enable CSD in about:config), but you will be able to do it when they add
client-side decoration support. For now you can use a GNOME extension like
[No Title Bar](https://extensions.gnome.org/extension/1267/no-title-bar/) to
hide it.

## Broken stuff

If you use the bookmark bar, it's now above the URL bar. Also the menu bar is
below the tab bar (things are flipped upside down to move the tabs below the URL
bar). That's pretty shit, but I haven't figured out how to move the tab bar
without flipping everything else yet and I don't use the bookmark bar anyway so
I'm fine with that. I actually like having the menu bar below the tab bar, feels
cozy.

Icons might appear black where they should be white on some systems. I have no
idea why, but you can adjust them in the `ui/theme.css` file, look for
`filter: invert`.

I haven't finished styling the new... new tab page. I just replaced it with a
blank page, because I don't like all that clutter anyway, but feel free to
finish it yourself (my attempts are in the `userContent.css` file, look for
`about:newtab`).

Probably more things are broken, it looks okay for me, feel free to report
issues here on GitHub and share your ideas if you know how to fix them.

## Development

If you wanna mess around the styles and change something, or create a light
variant of this theme, you might find these things useful.

To use the Inspector to debug the UI, open the developer tools (F12) on any
page, go to options, check both of those:

	- Enable browser chrome and add-on debugging toolboxes
	- Enable remote debugging

Now you can close those tools and press Ctrl+Alt+Shift+I to Inspect the browser
UI.

Also you can inspect any GTK3 application, for example type this into a terminal
and it will run Epiphany with the GTK Inspector, so you can check the CSS styles
of its elements too.

		GTK_DEBUG=interactive epiphany

Feel free to use any parts of my code to develop your own themes, I don't force
any specific license on your code.
