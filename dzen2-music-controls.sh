# FW="mpc seek +5"      # 5 sec forwards
# RW="mpc seek -5"      # 5 sec backwards
# NEXTS="mpc next"      # previous song
# PREVS="mpc prev"      # next song
# TOGGS="mpc toggle"    # play/pause
#
# CAPTION="^i(/home/deifl/bitmaps/music.xbm)"
#
# MAXPOS="100"
#
# POS=`mpc | sed -ne 's/^.*(\([0-9]*\)%).*$/\1/p'`
# POSM="$POS $MAXPOS"
# echo -n "$CAPTION "
# echo "`mpc | sed -n '1p'`" | tr '\n' ' '
# echo "$POSM" | dzen2-gdbar -h $GH -w $GW -fg $GFG -bg $GBG
#
# echo "button4=exec:$RW;button5=exec:$FW;button1=exec:$PREVS;button3=exec:$NEXTS;button2=exec:$TOGGS"
