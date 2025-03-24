# Generate stylesheet with GNOME SVG icons as CSS variables.
#
# Fetch icons from official git repos and convert them to inline CSS variables
# adding support for reoloring in Firefox in the process.
#
# Git is required to run the script.
#
# Partially inspired by https://gitlab.gnome.org/World/design/icon-library/-/blob/master/update-icons.py

import glob
import logging
import os
import shutil
import subprocess
import yaml
import xml.etree.ElementTree as ET
from typing import TypedDict
from urllib.parse import quote

ABS_PATH = os.path.dirname(os.path.abspath(__file__))
ICONS_FILE = os.path.join(ABS_PATH, "icons.yml")
CSS_FILE = os.path.join(ABS_PATH, "icons.css")
ICONS_REPO_URL = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme.git"
ICONS_REPO_PATH = os.path.join(ABS_PATH, "adwaita-icon-theme")
ICONS_KIT_REPO_URL = "https://gitlab.gnome.org/Teams/Design/icon-development-kit-www.git"
ICONS_KIT_REPO_PATH = os.path.join(ABS_PATH, "icon-development-kit-www")

ET.register_namespace("", "http://www.w3.org/2000/svg")

class IconsDefinition(TypedDict):
    icons: list[str]

def main():
    # Get icons repositories
    if not os.path.exists(ICONS_REPO_PATH):
        subprocess.call(["git", "clone", "--depth", "1", ICONS_REPO_URL], cwd=ABS_PATH)
    if not os.path.exists(ICONS_KIT_REPO_PATH):
        subprocess.call(["git", "clone", "--depth", "1", ICONS_KIT_REPO_URL], cwd=ABS_PATH)

    # Get icons name to path mappings
    icon_paths = {
        **lookup_icons(f"{ICONS_KIT_REPO_PATH}/img/symbolic"),  # Extra GNOME icons kit
        **lookup_icons(f"{ICONS_REPO_PATH}/Adwaita/symbolic"),  # Core GNOME icons
        **lookup_icons(f"{ABS_PATH}/custom", False)  # Custom icons
    }

    # Load definition of icons needed by the theme
    with open(ICONS_FILE, "r") as f:
        icons_def: IconsDefinition = yaml.safe_load(f)

    # Process icons SVGs for CSS
    icons_svg: dict[str, str] = {}
    for icon in icons_def["icons"]:
        if icon not in icon_paths:
            logging.warning(f"No icon file found for '{icon}'")
            continue

        text = process_svg(icon_paths[icon])
        svg = quote(text, safe=' =:/\'')  # URL encode the icon, omitting some characters
        icons_svg[icon] = svg

    # Write CSS file
    with open(CSS_FILE, "w") as css:
        css.write(":root {\n")
        for name, svg in icons_svg.items():
            css.write(f'\t--gnome-icon-{name}: url("data:image/svg+xml,{svg}");\n')
        css.write("}")

    # Remove repos dirs
    shutil.rmtree(ICONS_REPO_PATH)
    shutil.rmtree(ICONS_KIT_REPO_PATH)

def lookup_icons(icons_folder: str, has_subdirs = True) -> dict[str, str]:
    lookup: dict[str, str] = {}

    for path in glob.glob(f"{icons_folder}/{ "**/" if has_subdirs else "" }*-symbolic.svg"):
        filename = os.path.basename(path)
        name = filename.replace(".svg", "")
        lookup[name] = path

    return lookup

def process_svg(filename: str) -> str:
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

    # Strip line breasks and indentation
    for elem in root.iter("*"):
        if elem.text is not None:
            elem.text = elem.text.strip()
        if elem.tail is not None:
            elem.tail = elem.tail.strip()

    text = ET.tostring(root, "unicode")
    text = text.replace('"', "'") # Use single quotes

    return text

main()
