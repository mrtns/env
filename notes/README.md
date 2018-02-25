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
