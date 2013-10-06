#!/bin/bash

SESS_NAME=gmod
WINDOW_NAME=0
PANE_NAME=1

apt-get -y install vim libevent-dev libncurses-dev
wget http://downloads.sourceforge.net/tmux/tmux-1.8.tar.gz
tar xfz tmux-1.8.tar.gz
cd tmux_1.8
./configure
make install clean
chmod +x steamcmd.sh
mkdir -p /home/srcds
useradd srcds
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz -O /home/srcds/steamcmd_linux.tar.gz
tar xfz /home/srcds/steamcmd_linux.tar.gz -C /home/srcds
chown -R srcds:srcds /home/srcds
chmod 700 /home/srcds
su - -c "/home/srcds/steamcmd.sh +login anonymous +force_install_dir /home/srcds/gmod +app_update 4020 validate +quit" srcds
su - -c "/home/srcds/steamcmd.sh +login anonymous +force_install_dir /home/srcds/content/tf2 +app_update 232250 validate +quit" srcds
su - -c "/home/srcds/steamcmd.sh +login anonymous +force_install_dir /home/srcds/content/css +app_update 232330 validate +quit" srcds

# Spin up the tmux session
tmux new-session -A -d -s gmod

tmux send-keys -t "$SESS_NAME:0.1" C-z 'su - srcds; gmod/srcds_run -game garrysmod +maxplayers 12 +map gm_flatgrass'
