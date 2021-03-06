
# References

* [State of Linux on the MacBook Pro 2016](https://github.com/Dunedan/mbp-2016-linux)


# Configuration

## Touchpad

* Install [cb22/macbook12-spi-driver](https://github.com/cb22/macbook12-spi-driver)

* Install [p2rkw/xf86-input-mtrack](https://github.com/p2rkw/xf86-input-mtrack)

* Configure

  * ```bash
    sudo cp X/mbp_14_1/50-mtrack.conf /usr/share/X11/xorg.conf.d/
    ```

  * References
    * [Toward a Linux touchpad as smooth as Macbook Pro](https://williambharding.com/blog/technology/toward-a-linux-touchpad-as-smooth-as-macbook-pro/) 

## Display Brightness

* ```bash
  git clone https://github.com/Hummer12007/brightnessctl
  ``` 

* ```bash
  cd brightnessctl
  ``` 

* ```bash
  INSTALL_UDEV_RULES=1 make
  ``` 

* ```bash
  sudo INSTALL_UDEV_RULES=1 make install
  ``` 

* Update i3wm config:
  ```
  bindsym XF86MonBrightnessUp exec --no-startup-id "brightnessctl s +5%"
  bindsym XF86MonBrightnessDown exec --no-startup-id "brightnessctl s 5%-"
  ```

## Keyboard Function Keys

* Default to media keys:
  ```bash
  echo 1 | sudo tee /sys/module/applespi/parameters/fnmode
  ```

* Default to function keys:
  ```bash
  echo 2 | sudo tee /sys/module/applespi/parameters/fnmode
  ```
