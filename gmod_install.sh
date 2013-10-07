#!/bin/bash

# Var defaults
SESS_NAME=gmod
WINDOW_NAME=0
PANE_NAME=0
USER=srcds
SV_PASSWORD=''
RCON_PASSWORD='PaSsWoRd!'
MAX_PLAYERS=12
MAP=gm_flatgrass
GAMEMODE=sandbox
EXTRA_OPTIONS=''

# Grab vars from command line
while getopts ":M:S:u:s:r:m:o:hg:" opt; do
  case $opt in
    S)
      SESS_NAME="$OPTARG"
      ;;
    u)
      USER="$OPTARG"
      ;;
    s)
      SV_PASSWORD="$OPTARG"
      ;;
    r)
      RCON_PASSWORD="$OPTARG"
      ;;
    m)
      MAX_PLAYERS="$OPTARG"
      ;;
    M)
      MAP="$OPTARG"
      ;;
    o)
      EXTRA_OPTIONS="$OPTARG"
      ;;
    g)
      GAMEMODE="$OPTARG"
      ;;
    h)
      cat <<DELIM

    Usage: ./gmod_install.sh

    Option    Description                               Default
    --------------------------------------------------------------------
        -u    User to install the server under          srcds
        -s    Set the sv_password option
        -r    Sets the RCON password                    PaSsWoRd!
        -m    Maximum number of players on the server   12
        -g    Game mode                                 sandbox
        -M    Starting map                              gm_flatgrass
        -S    Session name for tmux                     gmod
        -o    Set extra options

DELIM
      exit -1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument" >&2
      exit 1
      ;;
  esac
done

HOMEDIR="/home/$USER"
ARCH=`uname -p`

echo "System Architecture: $ARCH"
echo "Username: $USER"
echo "SV Password: $SV_PASSWORD"
echo "RCON Password: $RCON_PASSWORD"
echo "Game Mode: $GAMEMODE"
echo "Starting Map: $MAP"
echo "Player Max: $MAX_PLAYERS"
echo "Tmux Session Name: $SESS_NAME"
echo "Extra Options: $EXTRA_OPTIONS"
echo ""

apt-get update

if [ "$ARCH" = "x86_64" ];
then
  dpkg --add-architecture i386
  apt-get update
  apt-get -y install ia32-libs
fi

apt-get -y install vim libevent-dev libncurses5-dev build-essential
wget http://downloads.sourceforge.net/tmux/tmux-1.8.tar.gz
tar xfz tmux-1.8.tar.gz
cd tmux-1.8
./configure
make install clean
chmod +x steamcmd.sh
mkdir -p "$HOMEDIR"
useradd $USER
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz -O $HOMEDIR/steamcmd_linux.tar.gz
tar xfz $HOMEDIR/steamcmd_linux.tar.gz -C $HOMEDIR
chown -R $USER:$USER $HOMEDIR
chmod 700 $HOMEDIR
su - -c "$HOMEDIR/steamcmd.sh +login anonymous +force_install_dir $HOMEDIR/gmod +app_update 4020 validate +quit" $USER
su - -c "$HOMEDIR/steamcmd.sh +login anonymous +force_install_dir $HOMEDIR/content/tf2 +app_update 232250 validate +quit" $USER
su - -c "$HOMEDIR/steamcmd.sh +login anonymous +force_install_dir $HOMEDIR/content/css +app_update 232330 validate +quit" $USER

# Build the options string
OPTSTRING=" -game garrysmod +maxplayers $MAX_PLAYERS +map $MAP +gamemode $GAMEMODE"

if [ -n "$SV_PASSWORD" ];
then
  OPTSTRING="$OPTSTRING sv_password $SV_PASSWORD"
fi

if [ -n "$RCON_PASSWORD" ];
then
  OPTSTRING="$OPTSTRING rcon_password $RCON_PASSWORD"
fi

if [ -n "$EXTRA_OPTIONS" ];
then
  OPTSTRING="$OPTSTRING $EXTRA_OPTIONS"
fi


# Spin up the tmux session
tmux new-session -A -d -s gmod

tmux send-keys -t "$SESS_NAME:$WINDOW_NAME.$PANE_NAME" C-z \
  "su - -c '$HOMEDIR/gmod/srcds_run -game garrysmod +maxplayers $MAX_PLAYERS +map gm_flatgrass +sv_password gmod +rcon_password gmod' $USER" Enter
