# pixel_native

Running Ubuntu on the Chromebook Pixel 2 LS (Samus) natively.


# Install ectool

```
git clone https://chromium.googlesource.com/chromiumos/platform/ec
cd ec
sed -i 's/\(COMMON_WARN =\)/\1 -Wno-error=maybe-uninitialized/' Makefile.toolchain
make BOARD=samus build/samus/util/ectool
```

# Install `raphael/linux-samus` kernel

* Check current kernel
  ```
  $ uname -a
  Linux neutrino 4.8.0-22-generic #24-Ubuntu SMP Sat Oct 8 09:15:00 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
  ```

* Install linux-samus kernel
  ```
  git clone --depth=1 https://github.com/raphael/linux-samus
  cd linux-samus/build/debian
  sudo dpkg -i *.deb

  sudo update-grub
  sudo shutdown -r now
  ```

* Verify new kernel
  ```
  $ uname -a
  Linux neutrino 4.9.6-ph+ #17 SMP Fri Jan 27 11:38:18 PST 2017 x86_64 x86_64 x86_64 GNU/Linux
  ```

# Fan control

Dependencies:

* "Install ectool" section

Steps:

* Turn off all fans
  ```
  sudo ~/env/ec/build/samus/util/ectool --interface=lpc fanduty 0
  ```

# External display

* The cable
  * [Google USB-C to Displayport Cable](https://store.google.com/product/usb_type_c_to_displayport_cable)

* Plugging in the cable
  * It's directional, lol:
    https://github.com/raphael/linux-samus/issues/162#issuecomment-252401338

* Configuring xrandr modes
  * Laptop Monitor On, External Monitor On
    ```
    xrandr --output "eDP-1" --primary --auto --output "DP-1" --right-of "eDP-1" --auto
    ```

  * Laptop Monitor Off, External Monitor On
    ```
    xrandr --output "eDP-1" --off --output "DP-1" --primary --auto
    ```

  * Laptop Monitor On, External Monitor Off
    ```
    xrandr --output "DP-1" --off --output "eDP-1" --primary --auto
    ```

  * References
    * https://wiki.archlinux.org/index.php/xrandr

* Configuring different DPIs
  * References
    * http://askubuntu.com/questions/393400/is-it-possible-to-have-two-different-dpi-configurations-for-two-different-screen


# X11 acceleration

Dependencies:

* [linux-samus `xaccel.sh` script](https://github.com/raphael/linux-samus)

Steps:

* Install dependencies
  ```
  $ sudo apt-get install xserver-xorg-video-intel
  ```

* Run the setup script
  ```
  $ cd ~/env/linux-samus/scripts/setup/xorg
  $ ./xaccel.sh
  ```

# Trackpad

Dependencies:

* [linux-samus `scripts/setup/brightness/*` scripts](https://github.com/raphael/linux-samus)

* 'Trackpad' section of ["crouton unity i3wm" gist](https://gist.github.com/mrtns/1331733dcf93376bc145)

Steps:

* RUn the `enable-atmel.sh` script
  ```
  cd ~/env/linux-samus/scripts/setup/touchpad/

  ./enable-atmel.sh
  ```

* Install and configure `touchpad-cmt-samus`
  ```
  sudo add-apt-repository --remove ppa:longsleep/pixel-extras
  sudo apt-get update
  sudo apt-get install libevdevc libgestures xf86-input-cmt

  sudo mv /usr/share/X11/xorg.conf.d/50-synaptics.conf /usr/share/X11/xorg.conf.d/50-synaptics.conf.old
  sudo cp /usr/share/xf86-input-cmt/50-touchpad-cmt-samus.conf /usr/share/X11/xorg.conf.d/
  ```

* Verify configuration
  ```
  cat /usr/share/X11/xorg.conf.d/50-touchpad-cmt-samus.conf
  cat /usr/share/X11/xorg.conf.d/40-touchpad-cmt.conf

  xinput list-props 'Atmel maXTouch Touchpad'
  ```

# Keyboard

## Laptop keyboard

```bash
ll X/pixel_native/keyboards
```

```bash
cat ~/.xsessionrc
xkbcomp ${HOME}/env/keyboard/server-0.xkb.pixel_ubuntu_samuskernel_mod ${DISPLAY} 
```

## External keyboard

References

* http://askubuntu.com/a/337431


# Display brightness controls

Dependencies:

* [linux-samus `scripts/setup/brightness/*` scripts](https://github.com/raphael/linux-samus)

Steps:

* Use `linux-samus`
  ```
  cd ~/env/linux-samus/scripts/setup/brightness/
  ```

* Run the setup script
  ```
  ./setup.systemd.sh
  ```

* Enable the service
  ```
  systemctl enable enable-brightness.service
  ```

* Configure keyboard keys via i3.
  Add to `~/.config/i3/config`:
  ```
  bindsym XF86MonBrightnessUp exec brightness --increase
  bindsym XF86MonBrightnessDown exec brightness --decrease
  ```

# Keyboard LED

Dependencies:

* All steps in "Display brightness controls"

Scripts:

* Turn off keyboard LED
  ```
  echo 0 > "/sys/class/leds/chromeos::kbd_backlight/brightness"
  ```
