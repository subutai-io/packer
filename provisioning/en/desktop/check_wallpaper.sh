#!/bin/bash
if [ -f ~/wallpaper.jpg ]; then
    mv -f ~/wallpaper.jpg ~/.config/wallpaper.jpg
    gsettings set org.mate.background picture-filename ~/.config/wallpaper.jpg
fi
# vim: ts=4 et nowrap autoindent