# Firefox Gnome Theme

![Screenshot of the theme](screenshot.png)

## Description

This is a bunch of CSS code to make Firefox 57+ look closer to GNOME's default
theme. It styles the UI and, if you pick the dark variant, interal Firefox'
pages like about: and view-source:. Both light and dark variants are supported.

## Installation

Extensions can no longer style UI elements, but we can still use good old
`userChrome.css` and `userContent.css` files. Just drop this repo to your
`chrome` directory:

1. Go to your Firefox profile's directory.
2. Clone this repo to the `chrome` directory:

	```sh
	git clone 'https://github.com/kurogetsusai/firefox-gnome-theme.git' chrome
	```

3. Enable the theme in your `userChrome.css` file. Open it with your favorite
text editor and follow instructions to enable one of the theme variants. You can
also enable extra features here.

The GTK theme variant must match the variant you picked for this Firefox
theme, which means you must either enable (for the dark variant) or disable (for
the light one) global dark theme in GNOME Tweak Tools, or alternativelly, you
can run Firefox with a specific variant without changing the global theme by
supplying the GTK_THEME variable like this:

	```sh
	# for the dark theme
	GTK_THEME=Adwaita:dark firefox

	# for the light one
	GTK_THEME=Adwaita:light firefox
	```

4. Optionally you can enable styling of Firefox' internal pages in your
`userContent.css` file.

You might want to adjust your default link colors so they are more visible on
dark background, either drop the code below into your
`(firefox profile)/user.js` file or change them manually in `about:config`.

```js
user_pref("browser.active_color", "#cc1a1a");
user_pref("browser.anchor_color", "#0a8dff");
user_pref("browser.visited_color", "#0871cc");
user_pref("browser.display.background_color", "#2e3436");
user_pref("browser.display.foreground_color", "#ccc");
```

You can't get rid of the title bar for now (except for Fedora I think, where you
can enable CSD in about:config), but you will be able to do it when they add
client-side decoration support. For now you can use a GNOME extension like
[No Title Bar](https://extensions.gnome.org/extension/1267/no-title-bar/) to
hide it.

## Broken stuff

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
