# install vim

sudo apt-get install vim

# install git

sudo apt-get install git

# install google-chrome-stable

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install google-chrome-stable



# install i3
# http://www.brentwalther.net/blog/how-to-replace-unity-with-i3-window-manager-on-ubuntu-1204

sudo -i
echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list
logout
sudo apt-get update
sudo apt-get --allow-unauthenticated install sur5r-keyring
sudo apt-get update
sudo apt-get install i3


# install python-pip

sudo apt-get install python-pip

# install quickswitch-for-i3
# https://github.com/proxypoke/quickswitch-for-i3

sudo pip install i3-py
sudo pip install quickswitch-i3
vim ~/.i3/config
bindsym control+space exec /usr/local/bin/quickswitch.py -d "dmenu -i -l 20"

# install oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh

sudo apt-get install git
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sudo apt-get install zsh
chsh -s /bin/zsh


# install powerline-fonts
# http://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv PowerlineSymbols.otf /usr/share/fonts/
sudo fc-cache -vf
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/


# install powerline

cd ~/dev/env
git clone https://github.com/milkbikis/powerline-shell.git
cd powerline-shell
cp config.py.dist config.py
./install.py

vim ~/.zshrc

    function powerline_precmd() {
      export PS1="$(~/dev/env/powerline-shell/powerline-shell.py $? --shell zsh 2> /dev/null)"
    }

    function install_powerline_precmd() {
      for s in "${precmd_functions[@]}"; do
        if [ "$s" = "powerline_precmd" ]; then
          return
        fi
      done
      precmd_functions+=(powerline_precmd)
    }

    install_powerline_precmd


# install vim-spf13

TODO


# set up ~/.common_profile

TODO

# set up app aliases

sudo ln -s /usr/bin/gnome-terminal /usr/local/bin/t
sudo ln -s /usr/bin/google-chrome /usr/local/bin/c
