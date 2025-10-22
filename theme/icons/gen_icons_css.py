# Generate stylesheet with GNOME SVG icons as CSS variables.
#
# Fetch icons from official git repos and convert them to inline CSS variables
# adding support for reoloring in Firefox in the process.
#
# Git is required to run the script.
#
# Partially inspired by https://gitlab.gnome.org/World/design/icon-library/-/blob/master/update-icons.py

import json
import logging
import os
import shutil
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import TypedDict
from urllib.parse import quote

ABS_PATH = Path(__file__).resolve().parent
ICONS_FILE = ABS_PATH / "icons.json"
CSS_FILE = ABS_PATH / "icons.css"
ICONS_REPO_URL = os.getenv(
    "ICONS_REPO_URL",
    "https://gitlab.gnome.org/GNOME/adwaita-icon-theme.git"
)
ICONS_REPO_PATH = ABS_PATH / ICONS_REPO_URL.split("/")[-1].replace(".git", "")
ICONS_KIT_REPO_URL = (
    "https://gitlab.gnome.org/Teams/Design/icon-development-kit-www.git"
)
ICONS_KIT_REPO_PATH = ABS_PATH / "icon-development-kit-www"

ET.register_namespace("", "http://www.w3.org/2000/svg")


class IconsDefinition(TypedDict):
    icons: list[str]


def main():
    if not ICONS_REPO_PATH.exists():
        subprocess.call(["git", "clone", "--depth", "1", ICONS_REPO_URL], cwd=ABS_PATH)
    if not ICONS_KIT_REPO_PATH.exists():
        subprocess.call(
            ["git", "clone", "--depth", "1", ICONS_KIT_REPO_URL], cwd=ABS_PATH
        )

    # Get icons name to path mappings
    icon_paths = {
        **lookup_icons(ICONS_KIT_REPO_PATH / "img" / "symbolic"),  # Extra GNOME icons kit
        **lookup_icons(ICONS_REPO_PATH / "Adwaita" / "symbolic"),  # Core GNOME icons
        **lookup_icons(ABS_PATH / "custom", False),  # Custom icons
    }

    # Load definition of icons needed by the theme
    with open(ICONS_FILE, "r") as f:
        icons_def: IconsDefinition = json.load(f)

    # Process icons SVGs for CSS
    icons_svg: dict[str, str] = {}
    for icon in icons_def["icons"]:
        if icon not in icon_paths:
            logging.warning(f"No icon file found for '{icon}'")
            continue

        text = process_svg(icon_paths[icon])
        svg = quote(text, safe=" =:/'")  # URL encode the icon, omitting some characters
        icons_svg[icon] = svg

    # Write CSS file
    with open(CSS_FILE, "w") as css:
        css.write(":root {\n")
        for name, svg in icons_svg.items():
            css.write(f'\t--gnome-icon-{name}: url("data:image/svg+xml,{svg}");\n')
        css.write("}\n")

    # Remove repos dirs
    shutil.rmtree(ICONS_REPO_PATH)
    shutil.rmtree(ICONS_KIT_REPO_PATH)


def lookup_icons(icons_folder: Path, has_subdirs=True) -> dict[str, Path]:
    """Finds all symbolic icons in a folder and maps their name to their Path."""
    lookup: dict[str, Path] = {}

    # Use Path.glob() for finding files
    glob_pattern = "**/*-symbolic.svg" if has_subdirs else "*-symbolic.svg"
    
    for path in icons_folder.glob(glob_pattern):
        # Use path.stem to get the filename without the .svg extension
        name = path.stem
        lookup[name] = path

    return lookup


def process_svg(filename: Path) -> str:
    """
    Process SVG's XML to be one liner and add Mozilla's SVG coloring properties
    """
    tree = ET.parse(filename)
    root = tree.getroot()

    # Set context-* values for fill and fill-opacity
    # Needed for icon recolor from CSS
    for tag in ("{http://www.w3.org/2000/svg}g", "{http://www.w3.org/2000/svg}path"):
        for elem in root.iter(tag):
            if "class" not in elem.attrib:  # Paths with class name are colored overlays
                if "fill" in elem.attrib:
                    elem.set("fill", "context-fill")
                    elem.set("fill-opacity", "context-fill-opacity")
                if "stroke" in elem.attrib:
                    elem.set("stroke", "context-stroke")
                    elem.set("stroke-opacity", "context-stroke-opacity")

    # Strip line breaks and indentation
    for elem in root.iter("*"):
        if elem.text is not None:
            elem.text = elem.text.strip()
        if elem.tail is not None:
            elem.tail = elem.tail.strip()

    text = ET.tostring(root, "unicode")
    text = text.replace('"', "'")  # Use single quotes

    return text


main()
