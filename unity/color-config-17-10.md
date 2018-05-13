# Boot screen

```bash
xhost +local: && sudo vim /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script
```

```
Window.SetBackgroundTopColor (0.0, 0.00, 0.0); # Nice colour on top of the screen fading to
Window.SetBackgroundBottomColor (0.0, 0.00, 0.0); # an equally nice colour on the bottom
```

```bash
sudo update-initramfs -u
```


# Login screen

```bash
xhost +local: && sudo vim /etc/alternatives/gdm3.css
```

```
#lockDialogGroup {
  /*
  background: #2c001e url(resource:///org/gnome/shell/theme/noise-texture.png);
  background-repeat: repeat; 
  */
  background: none;
  background-color: #000;}
```
