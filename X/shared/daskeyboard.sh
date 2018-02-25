#!/bin/bash

xinput -list | grep "daskeyboard" | awk -F'=' '{print $2}' | cut -c 1-2 | xargs -I{} setxkbmap -device {} -option "ctrl:nocaps,altwin:swap_lalt_lwin"
