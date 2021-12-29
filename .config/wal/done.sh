#!/bin/bash

set -e

if ! [[ -d "$HOME/.config/dunst" ]]; then
  mkdir -p "$HOME/.config/dunst"
fi

ln -sf "$HOME/.cache/wal/dunstrc" "$HOME/.config/dunst/dunstrc"
systemctl --user restart dunst

xrdb ~/.Xresources
