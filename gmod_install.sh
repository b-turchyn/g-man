#!/bin/bash

apt-get -y install tmux vim
tar xfz steamcmd_linux.tar.gz
chmod +x steamcmd.sh
mkdir -p /home/srcds
adduser srcds
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz -O /home/srcds/steamcmd_linux.tar.gz
tar xfz /home/srcds/steamcmd_linux.tar.gz /home/srcds
chown -R srcds:srcds /home/srcds
chmod 700 /home/srcds
su - -c "/home/srcds/steamcmd.sh +login anonymous +force_install_dir /home/srcds/gmod +app_update 4020 validate +force_install_dir /home/srcds/content/css +app_update 232330 validate +force_install_dir /home/srcds/content/tf2 +app_update 232250 validate +quit" srcds
