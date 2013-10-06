GMod
====

GMod is a no-frills, one-command installer for a Garry's Mod dedicated server.
It is designed for Ubuntu 12.04 x86 (with x64 support coming soon). Other OSs
will almost certainly fail.

This script was written because I didn't want to pay for a GMod server 24/7.
I've been using the VPSs over at [Digital Ocean](http://www.digitalocean.com)
because you pay by the hour and they run on SSDs. They are, by far, the best
VPSs I've ever seen for that price and are perfect for this use.

Digital Ocean has an API; I might see if I can leverage that in the future for
new iterations of this script. 

Usage
=====

`ssh <user>@<host> -c "wget https://github.com/b-turchyn/gmod/raw/master/gmod_install.sh -O - | bash"`

What This Script Does
=====================

* Installs Vim (from `apt-get`) and Tmux 1.8 (from source, because Ubuntu's
  distributed package is old.
* Creates the `srcds` user (so we don't run the server as root -- bad!)
* Downloads all required files for Garry's Mod, Counter-Strike: Source, and
  Team Fortress 2. These games provide a bunch of good content that is required
  for most mods in Garry's Mod.
* Starts up the server in its own Tmux session (in session `gmod:0.0`)

TODO
====

* Mount the other games into Garry's Mod.
* Automatically install Prop Hunt.
* Accept parameters for things such as passwords, game modes, map, etc.

Warranty
========

None. Zilch. Nada. Don't expect this to work. If it does, be plesently
surprised.
