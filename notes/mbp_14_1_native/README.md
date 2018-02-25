
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
