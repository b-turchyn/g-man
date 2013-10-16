G-Man
====

G-Man is a no-frills, one-command installer for a Garry's Mod dedicated server.
It is designed for Ubuntu 12.04 x86 and x64 support. Other OSs will almost
certainly fail, although you may get lucky with Debian.

This script was written because I didn't want to pay for a GMod server 24/7.
I've been using the VPSs over at [Digital Ocean](http://www.digitalocean.com)
because you pay by the hour and they run on SSDs. They are, by far, the best
VPSs I've ever seen for that price and are perfect for this use.

Digital Ocean has an API; I might see if I can leverage that in the future for
new iterations of this script.

Usage
=====

Standard Install:

`ssh <user>@<host> "wget https://github.com/b-turchyn/g-man/raw/master/gmod_install.sh -O - | bash"`

Customized Install:

    ssh <user>@<host> "wget https://github.com/b-turchyn/g-man/raw/master/gmod_install.sh -O - | \
      bash /dev/stdin [options]"




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

What This Script Does
=====================

* Installs Vim (from `apt-get`) and Tmux 1.8 (from source, because Ubuntu's
  distributed package is old.
* Creates the `srcds` user (so we don't run the server as root -- bad!)
* Downloads all required files for Garry's Mod, Counter-Strike: Source, and
  Team Fortress 2. These games provide a bunch of good content that is required
  for most mods in Garry's Mod.
* Mounts the other games into Garry's Mod.
* Starts up the server in its own Tmux session (in session `gmod:0.0`)

TODO
====

* Automatically install Prop Hunt (because Prop Hunt is awesome).

Warranty
========

None. Zilch. Nada. Don't expect this to work. If it does, be plesently
surprised.
