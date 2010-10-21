#!/bin/bash

cd /tmp
wget http://lundqvist.dyndns.org/sv_dvorak/drivers/se_sv_dvorak_new.xorg
wget http://lundqvist.dyndns.org/sv_dvorak/drivers/dvorak-se.map

sudo cp se_sv_dvorak_new.xorg /usr/share/X11/xkb/symbols/se_sv_dvorak
chmod 0644 /usr/share/X11/xkb/symbols/se_sv_dvorak
chown root:root /usr/share/X11/xkb/symbols/se_sv_dvorak


sudo cp dvorak-se.map /usr/lib/kbd/keytables/dvorak-se.map

echo <<EOF
PATH=/sbin:/bin:/usr/sbin:/usr/bin

. /lib/lsb/init-functions

case $1 in
        start)
                log_daemon_msg "Changing keymap" "sv_dvorak"
                status=$?
                log_end_msg $status
                ;;
        stop)
                log_daemon_msg "Stopping NTP server" "ntpd"
                start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
                log_end_msg $?
                rm -f $PIDFILE
                ;;
        restart|force-reload)
                $0 stop && sleep 2 && $0 start
                ;;
        try-restart)
                if $0 status >/dev/null; then
                        $0 restart
                else
                        exit 0
                fi

EOF

update-rc.d foo defaults 19
