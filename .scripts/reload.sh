#!/bin/bash
find . -type f -name "*.html" -o -name "*.css" -o -name "*.js" | entr xdotool search --onlyvisible --class "Firefox" key "ctrl+r"
