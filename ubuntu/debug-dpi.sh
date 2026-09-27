#!/bin/bash

# via https://askubuntu.com/a/272172/657703

xdpyinfo | grep dots
xrdb -query | grep dpi
xrandr | grep -w connected
gsettings get org.gnome.desktop.interface text-scaling-factor
gsettings get org.gnome.desktop.interface scaling-factor

# xrandr --output Virtual1 --mode 1920x1200 --dpi 96
