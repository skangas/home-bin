#!/bin/bash

# Translates words English<->Swedish by using the lexin at http://lexin.nada.kth.se/cgi-bin/sve-eng/
# Copyright (C) 2004  Jonas Lundgren, neonman @ EFnet

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


# If you find any bugs in this script, mail me at nospam1@local.se
# or contact me at #linux.se on EFnet, nick neonman.

# Maximum number of matches to be displayed (Number of lines)
MAX_MATCHES=4

# Print a message saying that output has been supressed? (yes/no)
PRINT_SUPRESS_MESSAGE="yes"

function help_me {
    echo "Usage: $0 <-s>/<-e> <svenskt/engelskt ord>"
    echo -e "-s\tSvenska->Engelska"
    echo -e "-e\tEngelska->Svenska"
}

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" == "-h" ]
then
help_me
exit 1
fi

# Don't change these.
SV_COUNT=0
EN_COUNT=0

function e2s {
LANG="Engelska -> Svenska"
ORD=$1
i=0
                                                                                                                     # Workaround for a bug. Ugly, I know.
echo "sprak=målspråk&uppslagsord=$ORD"|lynx -post_data http://lexin.nada.kth.se/cgi-bin/sve-eng/|sed -e s/"Förklara"/"Svenskt uppslagsord\nFörklara"/g|
while read line
do
    if [ "$( echo $line|grep "Ordet $ORD finns inte i lexikonet!" )" ]
    then
        echo 'Ordet finns inte med i lexikonet!'
        break
    fi
    
    if [ "$( echo $line|grep "Översättning av: $ORD" )" ]
    then
        CONTINUE="yes"
    elif  [ "$( echo $line|grep "Förklara" )" ]
    then
        CONTINUE=no
    fi
    
    if [ "$CONTINUE" == "yes" ]
    then
        #Skaffa översättningen
        if [ "$GET_NEXT_LINE_SV" == "yes" ]
        then
            if [ ! "$( echo -e "$line"|egrep '__________________________________________|Exempel|Stående uttryck|Engelsk översättning|Engelskt uppslagsord|Sammansättningar/avledningar' )" ]
            then
                SVENSKT_ORD="$SVENSKT_ORD $line"
            else
                GET_NEXT_LINE_SV="no"
                SV_DONE="yes"
            fi
        fi
        
        if [ "$( echo $line|egrep 'Svensk översättning|Svenskt uppslagsord' )" ]
        then
            GET_NEXT_LINE_SV="yes"
        fi

    fi

        # Skaffa engelska uppslagsordet
        if [ "$GET_NEXT_LINE_EN" == "yes" ]
        then
            if [ ! "$( echo -e "$line"|egrep '__________________________________________|Exempel|Stående uttryck|Svensk översättning|Svenskt uppslagsord|Sammansättningar/avledningar' )" ]
            then
                ENGELSKT_ORD="$ENGELSKT_ORD $line"
            else
                GET_NEXT_LINE_EN="no"
                EN_DONE="yes"
            fi
        fi
        
        if [ "$( echo $line|egrep 'Engelsk översättning|Engelskt uppslagsord' )" ]
        then
            GET_NEXT_LINE_EN="yes"
        fi
        

        case yes in
            $EN_DONE)
                    EN_RETURN[$EN_COUNT]="$ENGELSKT_ORD"
                    (( EN_COUNT++ ))
                    EN_DONE="no"
                    ENGELSKT_ORD=""
                 ;;
            $SV_DONE)
                    SV_RETURN[$SV_COUNT]="$SVENSKT_ORD"
                    (( SV_COUNT++ ))
                    SV_DONE="no"
                    SVENSKT_ORD=""
                 ;;
        esac
        if [ "${#SV_RETURN[*]}" -ge "$MAX_MATCHES" ] && [ "${#EN_RETURN[*]}" -ge "$MAX_MATCHES" ]
        then
            CONTINUE=no
            SUPRESSED_MATCHES="yes"
        fi
            
    # If continue = no then all data is parsed, output it! Then break.
    # Change the output here.
    if [ "$CONTINUE" == "no" ]
    then
        i=0
        echo "Sökning ($LANG): $ORD"
        while [ "${#SV_RETURN[*]}" -gt "$i" ]
        do
            let c=$i+1
            echo "(SV)->[$c] ${SV_RETURN[$i]})"
            echo "(EN)->[$c] ${EN_RETURN[$i]}"
            (( i++ ))
        done
        if [ "$SUPRESSED_MATCHES" == "yes" ] && [ "$PRINT_SUPRESS_MESSAGE" == "yes" ]
        then
            echo "Maximum number of matches set to $MAX_MATCHES, output supressed."
        fi
        break
    fi
done
}

function s2e {
LANG="Svenska -> Engelska"
ORD=$1
i=0
echo "sprak=källspråk&uppslagsord=$ORD"|lynx -post_data http://lexin.nada.kth.se/cgi-bin/sve-eng/|sed -e s/"Förklara"/"Svenskt uppslagsord\nFörklara"/g|
while read line
do
    if [ "$( echo $line|grep "Ordet $ORD finns inte i lexikonet!" )" != "" ]
    then
        echo 'Ordet finns inte med i lexikonet!'
        break
    fi
    
    if [ "$( echo $line|grep "Översättning av: $ORD" )" != "" ]
    then
        CONTINUE="yes"
    elif  [ "$( echo $line|grep "Förklara" )" ]
    then
        CONTINUE=no
    fi

    if [ "$CONTINUE" == "yes" ]
    then
        # Skaffa Svenska uppslagsordet
        if [ "$GET_NEXT_LINE_SV" == "yes" ]
        then
            if [ ! "$( echo -e "$line"|egrep '__________________________________________|Exempel|Stående uttryck|Engelsk översättning|Engelskt uppslagsord|Sammansättningar/avledningar' )" ]
            then
                SVENSKT_ORD="$SVENSKT_ORD $line"
            else
                GET_NEXT_LINE_SV="no"
                SV_DONE="yes"
            fi
        fi
        
        if [ "$( echo $line|egrep 'Svensk översättning|Svenskt uppslagsord' )" ]
        then
            GET_NEXT_LINE_SV="yes"
        fi
        
        #Skaffa översättningen
        if [ "$GET_NEXT_LINE_EN" == "yes" ]
        then
            if [ ! "$( echo -e "$line"|egrep '__________________________________________|Exempel|Stående uttryck|Svensk översättning|Svenskt uppslagsord|Sammansättningar/avledningar' )" ]
            then
                ENGELSKT_ORD="$ENGELSKT_ORD $line"
            else
                GET_NEXT_LINE_EN="no"
                EN_DONE="yes"
            fi
        fi
        
        if [ "$( echo $line|egrep 'Engelsk översättning|Engelskt uppslagsord' )" ]
        then
            GET_NEXT_LINE_EN="yes"
        fi
    fi

            case yes in
            $EN_DONE)
                    EN_RETURN[$EN_COUNT]="$ENGELSKT_ORD"
                    (( EN_COUNT++ ))
                    EN_DONE="no"
                    ENGELSKT_ORD=""
                 ;;
            $SV_DONE)
                    SV_RETURN[$SV_COUNT]="$SVENSKT_ORD"
                    (( SV_COUNT++ ))
                    SV_DONE="no"
                    SVENSKT_ORD=""
                 ;;
        esac
        if [ "${#SV_RETURN[*]}" -ge "$MAX_MATCHES" ] && [ "${#EN_RETURN[*]}" -ge "$MAX_MATCHES" ]
        then
            CONTINUE=no
            SUPRESSED_MATCHES="yes"
        fi

    # If continue = no then all data is parsed, output it! Then break.
    # Change the output here.
    if [ "$CONTINUE" == "no" ]
    then
        i=0
        echo "Sökord ($LANG): $ORD"
        while [ "${#SV_RETURN[*]}" -gt "$i" ]
        do
            let c=$i+1
            echo "(SV)->[$c] ${SV_RETURN[$i]})"
            echo "(EN)->[$c] ${EN_RETURN[$i]}"
            (( i++ ))
        done
        if [ "$SUPRESSED_MATCHES" == "yes" ] && [ "$PRINT_SUPRESS_MESSAGE" == "yes" ]
        then
            echo "Maximum number of matches set to $MAX_MATCHES, some output may be supressed."
        fi
        break
    fi
done
}

case $1 in
    -e)
    e2s $2
    ;;
    -s)
    s2e $2
    ;;
    *)
    echo "Argument passed to $0: not supported."
    echo
    help_me
    exit 1
    ;;
esac

exit 0
