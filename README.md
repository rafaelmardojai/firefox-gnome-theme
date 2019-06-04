# Firefox GNOME Theme
A GNOME theme for Firefox 60+.

*This theme follows lastest GNOME default gtk theme adwaita*

**This theme is under development and is not ready to use**

![Screenshot of the theme](screenshot.png)

## Description

This is a bunch of CSS code to make Firefox look closer to GNOME's default
theme.

The `master` branch track current Firefox and GNOME stable.

## Installation

**TODO**

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
