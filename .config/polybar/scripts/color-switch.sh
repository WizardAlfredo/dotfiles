#!/usr/bin/env bash

SDIR="$HOME/.config/polybar/scripts"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $SDIR/rofi/styles.rasi \
<<< "poly1|poly2|poly3|poly4|")"
            case "$MENU" in
				## Change polybars 
				*poly1) "$SDIR"/colors-light.sh --amber ;;
				*poly2) "$SDIR"/colors-light.sh --blue ;;
				*poly3) "$SDIR"/colors-light.sh --blue-gray ;;
				*poly4) "$SDIR"/colors-light.sh --blue-gray ;;
            esac
