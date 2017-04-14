sudo -i
su lightdm -s /bin/bash
gsettings set com.canonical.unity-greeter play-ready-sound "false"
gsettings set com.canonical.unity-greeter draw-user-backgrounds 'false'
gsettings set com.canonical.unity-greeter background '/dev/null'    
gsettings set com.canonical.unity-greeter background-color '#000000'
gsettings set com.canonical.unity-greeter draw-grid 'false'
exit
