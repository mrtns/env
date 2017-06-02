# pixel_crouton

Running Ubuntu on the Chromebook Pixel 2 LS (Samus) via the Chromium OS Universal Chroot Environment.

# i3wm

## Install

    # login to the root shell for one 'echo' command
    sudo -i
    echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list
    logout
    # we've returned to our user account
    sudo apt-get update
    sudo apt-get --allow-unauthenticated install sur5r-keyring
    sudo apt-get update
    sudo apt-get install i3

## Configure

To configure i3 to auto launch:

    echo "exec i3" >> ~/.xinitrc

## Launching pixelunity and i3wm:

    sudo enter-chroot -n pixelunity xinit


## References

* http://walther.io/how-to-replace-unity-with-i3-window-manager-on-ubuntu-1204/

* http://www.draconianoverlord.com/2014/05/26/from-xmonad-to-i3.html


# Keyboard

## Crouton Keyboard Target

    /etc/default/keyboard
    XKBMODEL="chromebook"

    cat ~/.Xmodmap


    clear control
    clear mod4
    clear mod1

    keycode 133 = Control_L
    keycode 64 = Super_L

    add control = Control_L Control_R

    add mod4 = Super_L
    add mod1 = Alt_L Alt_R


    keycode 37 = Overlay1_Enable


    cat ~/.xinitrc
    xmodmap ~/.Xmodmap

## References

* https://github.com/dnschneid/crouton/wiki/Keyboard
* http://askubuntu.com/questions/24916/how-do-i-remap-certain-keys-or-devices

# HiDPI

    cat ~/.Xresources
    Xft.dpi: 144

    cat ~/.xinitrc
    xrandr --dpi 144 && xrdb -merge ~/.Xresources

    gsettings set org.gnome.desktop.interface scaling-factor 1
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.5

# Trackpad

## Resources

    I replaced the synaptics touchpad driver with the ChromeOS  driver (thank you Hugegreenbug!) on my trusty chroot (Pixel 2) and have had a much smoother experience. I thought I'd share the steps I took:

    Please thank Hugh Greenberg for all his work!

    sudo add-apt-repository ppa:hugegreenbug/cmt2

    sudo apt-get update

    sudo apt-get install libevdevc libgestures xf86-input-cmt

    sudo mv /usr/share/X11/xorg.conf.d/50-synaptics.conf /usr/share/X11/xorg.conf.d/50-synaptics.conf.old

    sudo cp /usr/share/xf86-input-cmt/50-touchpad-cmt-samus.conf /usr/share/X11/xorg.conf.d/

    I also added these lines to the 50-touchpad-cmt-samus.conf file, but you may not be as annoyed with the right click area:

    Option          "Button Right Click Zone Enable" "0"
    Option          "Australian Scrolling" "1"

    To disable other common options:

    Option          "Tap Enable" "0"﻿
    Option          "Keyboard Palm Prevent Timeout" "0"﻿

    For even more options! Try this:

    xinput --list-props 8

    Where 8 is the device ID of the Atmel maXTouch Touchpad on my pixel 2, listed in xinput with no parameters, like this:

    xinput﻿

    or

    xinput list-props 'Atmel maXTouch Touchpad'

    Pointer sensitivity:

    xinput set-prop 'Atmel maXTouch Touchpad' 'Pointer Sensitivity' 6

* https://plus.google.com/+ClayCaldovino/posts/beM8HnKMQ64


# Audio

## i3 Key Bindings

Pre-requisites:

* The crouton `audio` target is installed

In `~/.i3/config`:

```
bindsym XF86AudioRaiseVolume exec volume up 1
bindsym XF86AudioLowerVolume exec volume down 1
bindsym XF86AudioMute exec volume mute toggle
```

## References

* https://faq.i3wm.org/question/125/how-to-change-the-systems-volume.1.html


# Final `.xinitrc`

    cat ~/.xinitrc
    xmodmap ~/.Xmodmap && xrandr --dpi 144 && xrdb -merge ~/.Xresources && exec i3

