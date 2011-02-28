#!/bin/bash

NEW_CLOC="/usr/lib/kbd/keytables/dvorak-se.map"
NEW_XLOC="/usr/share/X11/xkb/symbols/se_sv_dvorak"

cd /tmp
wget http://lundqvist.dyndns.org/sv_dvorak/drivers/se_sv_dvorak_new.xorg
wget http://lundqvist.dyndns.org/sv_dvorak/drivers/dvorak-se.map

sudo cp    se_sv_dvorak_new.xorg $NEW_XLOC
sudo chmod 0644                  $NEW_XLOC
sudo chown root:root             $NEW_XLOC

sudo cp    dvorak-se.map $NEW_CLOC
sudo chmod 0644          $NEW_CLOC
sudo chown root:root     $NEW_CLOC

# TODO: sed script to change /etc/default/keyboard
