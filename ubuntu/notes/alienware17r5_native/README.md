# alienware17r5_native

Running Ubuntu natively on the 'Alienware 17 R5'.

# Configuration

## Touchpad

* An override file exists with custom configs (acceleration, tap to click):
  ```
  cat ubuntu/X/alienware17r5/50-libinput-touchpad-martin.conf
  ```

* Install the override config via:
  ```
  sudo cp ubuntu/X/alienware17r5/50-libinput-touchpad-martin.conf /usr/share/X11/xorg.conf.d/
  ```

## Keyboard

* Caps Lock as Control, and swap left Alt and left Super:
  ```
  cat ubuntu/X/alienware17r5/.xsessionrc
  ```

* Fn+Left and Fn+Right as Home and End:
  ```
  cat ubuntu/X/alienware17r5/.Xmodmap
  ```

## Displays

* Switch DPI between the internal display (144) and an external display (110).
  Each script swaps in the matching `~/.Xresources` and `~/.xinitrc`, then ends the session:
  ```
  ubuntu/X/alienware17r5/dpi-internal.sh
  ubuntu/X/alienware17r5/dpi-external.sh
  ```

* Switch which monitors are on (`DP-0` internal, `DP-1` external):
  ```
  ubuntu/X/alienware17r5/monitor-internal.sh
  ubuntu/X/alienware17r5/monitor-external.sh
  ubuntu/X/alienware17r5/monitor-both.sh
  ```

## i3wm

* Config and status bar:
  ```
  ubuntu/i3/alienware17r5/config
  ubuntu/i3/alienware17r5/.i3status.conf
  ```
