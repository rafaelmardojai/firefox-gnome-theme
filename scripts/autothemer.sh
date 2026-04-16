#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$(dirname "$SCRIPT_DIR")"
GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/^'//;s/'$//")
COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme | sed "s/^'//;s/'$//")

if [[ "$COLOR_SCHEME" == *"dark"* ]]; then
    CURRENT_MODE="dark"
else
    CURRENT_MODE="light"
fi

THEME_SEARCH_PATHS=("$HOME/.themes" "/usr/share/themes")

FIND_THEME_CSS() {
    local theme_name="$1"
    local css_file="$2"
    for dir in "${THEME_SEARCH_PATHS[@]}"; do
        if [[ -f "$dir/$theme_name/gtk-3.0/$css_file" ]]; then
            echo "$dir/$theme_name/gtk-3.0/$css_file"
            return 0
        fi
    done
    return 1
}

EXTRACT_BASE_NAME() {
    local theme="$1"
    echo "${theme%-Light}" | sed -e 's/-Dark$//' -e 's/-light$//' -e 's/-dark$//'
}

LIGHT_THEME=""
DARK_THEME=""
LIGHT_CSS=""
DARK_CSS=""

BASE_NAME=$(EXTRACT_BASE_NAME "$GTK_THEME")

if [[ "$GTK_THEME" == *"-Light" ]] || [[ "$GTK_THEME" == *"-light" ]]; then
    LIGHT_THEME="$GTK_THEME"
    LIGHT_CSS=$(FIND_THEME_CSS "$LIGHT_THEME" "gtk.css")
    
    DARK_CANDIDATE="${BASE_NAME}-Dark"
    if [[ -n "$DARK_CANDIDATE" ]] && [[ "$DARK_CANDIDATE" != "$LIGHT_THEME" ]]; then
        DARK_CSS=$(FIND_THEME_CSS "$DARK_CANDIDATE" "gtk-dark.css")
        if [[ -n "$DARK_CSS" ]]; then
            DARK_THEME="$DARK_CANDIDATE"
        fi
    fi
    if [[ -z "$DARK_THEME" ]]; then
        DARK_CANDIDATE="${BASE_NAME}-Dark"
        DARK_CSS=$(FIND_THEME_CSS "$DARK_CANDIDATE" "gtk.css")
        if [[ -n "$DARK_CSS" ]]; then
            DARK_THEME="$DARK_CANDIDATE"
        fi
    fi
elif [[ "$GTK_THEME" == *"-Dark" ]] || [[ "$GTK_THEME" == *"-dark" ]]; then
    DARK_THEME="$GTK_THEME"
    DARK_CSS=$(FIND_THEME_CSS "$DARK_THEME" "gtk-dark.css")
    
    LIGHT_CANDIDATE="${BASE_NAME}-Light"
    if [[ -n "$LIGHT_CANDIDATE" ]] && [[ "$LIGHT_CANDIDATE" != "$DARK_THEME" ]]; then
        LIGHT_CSS=$(FIND_THEME_CSS "$LIGHT_CANDIDATE" "gtk.css")
        if [[ -n "$LIGHT_CSS" ]]; then
            LIGHT_THEME="$LIGHT_CANDIDATE"
        fi
    fi
    if [[ -z "$LIGHT_THEME" ]]; then
        LIGHT_CANDIDATE="${BASE_NAME}-light"
        LIGHT_CSS=$(FIND_THEME_CSS "$LIGHT_CANDIDATE" "gtk.css")
        if [[ -n "$LIGHT_CSS" ]]; then
            LIGHT_THEME="$LIGHT_CANDIDATE"
        fi
    fi
else
    LIGHT_CSS=$(FIND_THEME_CSS "$GTK_THEME" "gtk.css")
    if [[ -n "$LIGHT_CSS" ]]; then
        LIGHT_THEME="$GTK_THEME"
    fi
    
    if [[ -z "$LIGHT_THEME" ]]; then
        LIGHT_CSS=$(FIND_THEME_CSS "${GTK_THEME}-Light" "gtk.css")
        if [[ -n "$LIGHT_CSS" ]]; then
            LIGHT_THEME="${GTK_THEME}-Light"
        fi
    fi
    if [[ -z "$LIGHT_THEME" ]]; then
        LIGHT_CSS=$(FIND_THEME_CSS "${GTK_THEME}-light" "gtk.css")
        if [[ -n "$LIGHT_CSS" ]]; then
            LIGHT_THEME="${GTK_THEME}-light"
        fi
    fi
    
    DARK_CSS=$(FIND_THEME_CSS "$GTK_THEME" "gtk-dark.css")
    if [[ -n "$DARK_CSS" ]]; then
        DARK_THEME="$GTK_THEME"
    fi
    
    if [[ -z "$DARK_THEME" ]]; then
        DARK_CSS=$(FIND_THEME_CSS "${GTK_THEME}-Dark" "gtk-dark.css")
        if [[ -n "$DARK_CSS" ]]; then
            DARK_THEME="${GTK_THEME}-Dark"
        fi
    fi
    if [[ -z "$DARK_THEME" ]]; then
        DARK_CSS=$(FIND_THEME_CSS "${GTK_THEME}-dark" "gtk-dark.css")
        if [[ -n "$DARK_CSS" ]]; then
            DARK_THEME="${GTK_THEME}-dark"
        fi
    fi
fi

if [[ -z "$LIGHT_CSS" ]] && [[ -z "$DARK_CSS" ]]; then
    echo "Error: Could not find GTK theme at: $GTK_THEME"
    exit 1
fi

NAMED_TO_HEX() {
    local color="$1"
    case "$color" in
        white) echo "#ffffff" ;;
        black) echo "#000000" ;;
        *) echo "$color" ;;
    esac
}

EXTRACT_COLORS() {
    local css_file="$1"
    
    BG_LINE=$(grep -E '^\.background\s*\{' "$css_file" | head -1)
    BG_COLOR=$(echo "$BG_LINE" | sed -n 's/.*background-color: \([^;]*\);.*/\1/p' | tr -d ' ')
    BG_COLOR=$(NAMED_TO_HEX "$BG_COLOR")

    TEXT_COLOR=$(echo "$BG_LINE" | sed -n 's/\.background { color: \([^;]*\);.*/\1/p' | tr -d ' ')
    TEXT_COLOR=$(NAMED_TO_HEX "$TEXT_COLOR")

    BACKDROP_LINE=$(grep -E '^\.background:backdrop\s*\{' "$css_file" | head -1)
    BACKDROP_TEXT_COLOR=$(echo "$BACKDROP_LINE" | sed -n 's/.*color: \([^;]*\); background-color.*/\1/p' | tr -d ' ')
    BACKDROP_TEXT_COLOR=$(NAMED_TO_HEX "$BACKDROP_TEXT_COLOR")
    BACKDROP_BG=$(echo "$BACKDROP_LINE" | sed -n 's/.*background-color: \([^;]*\);.*/\1/p' | tr -d ' ')
    BACKDROP_BG=$(NAMED_TO_HEX "$BACKDROP_BG")

    ACCENT_COLOR=$(grep -E '@define-color accent_color' "$css_file" | head -1 | sed -n 's/.*\([#][0-9a-fA-F]\{6\}\).*/\1/p')
    if [[ -z "$ACCENT_COLOR" ]]; then
        ACCENT_LINE=$(grep '\.accent {' "$css_file" | head -1)
        ACCENT_COLOR=$(echo "$ACCENT_LINE" | sed -n 's/.*color: \([^;]*\);.*/\1/p' | tr -d ' ')
        ACCENT_COLOR=$(NAMED_TO_HEX "$ACCENT_COLOR")
    fi
    if [[ -z "$ACCENT_COLOR" ]]; then
        ACCENT_LINE=$(grep -E 'selected[^}]*background' "$css_file" | head -1)
        ACCENT_COLOR=$(echo "$ACCENT_LINE" | sed -n 's/.*background-color: \([^;]*\);.*/\1/p' | tr -d ' ')
        ACCENT_COLOR=$(NAMED_TO_HEX "$ACCENT_COLOR")
    fi

    SIDEBAR_LINE=$(grep -E 'sidebar' "$css_file" | grep 'background-color' | head -1)
    SIDEBAR_BG=$(echo "$SIDEBAR_LINE" | sed -n 's/.*background-color: \([^;]*\);.*/\1/p' | tr -d ' ')
    SIDEBAR_BG=$(NAMED_TO_HEX "$SIDEBAR_BG")

    VIEW_LINE=$(grep '\.view' "$css_file" | grep 'background-color' | head -1)
    VIEW_BG=$(echo "$VIEW_LINE" | sed -n 's/.*background-color: \([^;]*\);.*/\1/p' | tr -d ' ')
    VIEW_BG=$(NAMED_TO_HEX "$VIEW_BG")

    echo "$BG_COLOR"
    echo "$TEXT_COLOR"
    echo "$ACCENT_COLOR"
    echo "$SIDEBAR_BG"
    echo "$VIEW_BG"
    echo "$BACKDROP_BG"
    echo "$BACKDROP_TEXT_COLOR"
}

HEX_TO_RGBA() {
    local hex="$1"
    local r g b
    hex=$(echo "$hex" | tr -d '#')
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))
    echo "rgba($r, $g, $b, 0.8)"
}

apply_colors() {
    local css_file="$1"
    local mode="$2"
    local bg="$3"
    local text="$4"
    local accent="$5"
    local sidebar="$6"
    local view="$7"
    local backdrop_bg="$8"
    
    if [[ ! -f "$css_file" ]]; then
        echo "Error: CSS file not found: $css_file"
        return 1
    fi

    if [[ -n "$bg" ]]; then
        sed -i "0,/--gnome-window-background:.*;/{s|--gnome-window-background:.*;|--gnome-window-background: $bg;|}" "$css_file"
    fi
    if [[ -n "$text" ]]; then
        TEXT_RGBA=$(HEX_TO_RGBA "$text")
        sed -i "0,/--gnome-window-color:.*;/{s|--gnome-window-color:.*;|--gnome-window-color: $TEXT_RGBA;|}" "$css_file"
    fi
    if [[ -n "$view" ]]; then
        sed -i "0,/--gnome-view-background:.*;/{s|--gnome-view-background:.*;|--gnome-view-background: $view;|}" "$css_file"
    fi
    if [[ -n "$sidebar" ]]; then
        sed -i "0,/--gnome-sidebar-background:.*;/{s|--gnome-sidebar-background:.*;|--gnome-sidebar-background: $sidebar;|}" "$css_file"
    fi
    if [[ -n "$bg" ]]; then
        sed -i "0,/--gnome-headerbar-background:.*;/{s|--gnome-headerbar-background:.*;|--gnome-headerbar-background: $bg;|}" "$css_file"
    fi
    if [[ -n "$backdrop_bg" ]]; then
        sed -i "0,/--gnome-secondary-sidebar-background:.*;/{s|--gnome-secondary-sidebar-background:.*;|--gnome-secondary-sidebar-background: $backdrop_bg;|}" "$css_file"
        sed -i "0,/--gnome-sidebar-background:.*#f2f2f4;/{s|--gnome-sidebar-background:.*#f2f2f4;|--gnome-sidebar-background: $backdrop_bg;|}" "$css_file" 2>/dev/null || true
    fi

    echo "Applied $mode colors to: $css_file"
}

echo "Theme: $GTK_THEME"
echo "Light variant: ${LIGHT_THEME:-none}"
echo "Dark variant: ${DARK_THEME:-none}"
echo "Current mode: $CURRENT_MODE"
echo ""

if [[ -n "$LIGHT_THEME" ]]; then
    echo "Extracting colors from: $LIGHT_THEME ($LIGHT_CSS)"
    IFS='|' read -r BG_L TEXT_L ACCENT_L SIDEBAR_L VIEW_L BACKDROP_BG_L BACKDROP_TEXT_L < <(
        EXTRACT_COLORS "$LIGHT_CSS" | tr '\n' '|'
    )
    echo "  Background: $BG_L"
    echo "  Text:      $TEXT_L"
    echo "  Sidebar:   $SIDEBAR_L"
    echo "  Backdrop:  $BACKDROP_BG_L"
    echo ""
    apply_colors "$THEME_DIR/theme/colors/light.css" "light" "$BG_L" "$TEXT_L" "$ACCENT_L" "$SIDEBAR_L" "$VIEW_L" "$BACKDROP_BG_L"
fi

if [[ -n "$DARK_THEME" ]]; then
    echo "Extracting colors from: $DARK_THEME ($DARK_CSS)"
    IFS='|' read -r BG_D TEXT_D ACCENT_D SIDEBAR_D VIEW_D BACKDROP_BG_D BACKDROP_TEXT_D < <(
        EXTRACT_COLORS "$DARK_CSS" | tr '\n' '|'
    )
    echo "  Background: $BG_D"
    echo "  Text:      $TEXT_D"
    echo "  Sidebar:   $SIDEBAR_D"
    echo "  Backdrop:  $BACKDROP_BG_D"
    echo ""
    apply_colors "$THEME_DIR/theme/colors/dark.css" "dark" "$BG_D" "$TEXT_D" "$ACCENT_D" "$SIDEBAR_D" "$VIEW_D" "$BACKDROP_BG_D"
fi

echo "Done! Restart Firefox to see changes."
