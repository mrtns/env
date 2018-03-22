# i3wm

## Exit i3 from command line

```bash
i3-msg exit
```

# Fonts

* ```bash
  sudo apt-get install fonts-inconsolata
  sudo apt-get install fonts-roboto
  sudo apt-get install fonts-dejavu
  ```

* ```bash
  cd fonts/
  sudo cp *.ttf /usr/share/fonts/
  sudo fc-cache -vf
  ```

# xflux

* Install  
  ```bash
  wget https://justgetflux.com/linux/xflux64.tgz
  tar -xzvf xflux64.tgz
  sudo mv xflux /usr/local/bin/
  ```

* Run
  ```bash
  pkill -9 xflux ; xflux -z 90210 -k 4500 ; ps aux | grep xflux
  pkill -9 xflux ; xflux -l 52.5 -g 13.4 -k 4500 ; ps aux | grep xflux
  ```

# powerline-shell

* https://github.com/b-ryan/powerline-shell


# USB Tether

* Get id of USB network interface  
  ```bash
  ip link
  ``` 

* Enable DHCP on network interface  
  ```bash
  sudo dhclient enp0s20f0u2
  ```

# Wifi via command line

List status

```
nmcli general
```
```
STATE                   CONNECTIVITY  WIFI-HW  WIFI     WWAN-HW  WWAN    
connected (local only)  unknown       enabled  enabled  enabled  enabled 
```

```
nmcli networking
```
```
enabled
```

```
nmcli radio
```
```
WIFI-HW  WIFI     WWAN-HW  WWAN    
enabled  enabled  enabled  enabled 
```

```
nmcli connection
```
```
NAME     UUID                                  TYPE             DEVICE  
docker0  351344d5-4953-4c0d-95b7-aeb0a6d45b5c  bridge           docker0 
M        19fc81da-b937-4947-8286-01c2ffdec4c3  802-11-wireless  --      
```

```
nmcli device
```
```
DEVICE   TYPE      STATE         CONNECTION 
docker0  bridge    connected     docker0    
wlp2s0   wifi      disconnected  --         
lo       loopback  unmanaged     --       
```

* Turn off wifi

```
nmcli radio all off
```

* Connect to a wifi network
```
nmcli device wifi connect M
nmcli connection up id M
nmcli device wifi connect M wep-key-type phrase password x
```

# Networking

* Restart
  ```bash
  sudo /etc/init.d/dns-clean
  sudo service network-manager restart
  sudo service systemd-resolved restart
  ```

# Shutter (screenshot app)

* Install  
  ```
  sudo apt-get install shutter
  ```

* Create shortcut  
  ```
  sudo ln -s /usr/bin/shutter /usr/local/bin/grab_shutter
  ```

# colordiff

TODO


# Audio

* Start pulseaudio
  ```bash
  pulseaudio --start
  ```

* Switch audio to DragonFly
  ```bash
  pacmd list-sinks
  pacmd set-default-sink "alsa_output.usb-AudioQuest_AudioQuest_DragonFly_Black_v1.5_AQDFBL0100101010-01.analog-stereo"
  ```

* Control volume via command line
  ```bash
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  pactl set-sink-volume @DEFAULT_SINK@ +5%   
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  ```

