#!/bin/sh

#
# cleanup_scans.sh
#
# Bash script to deskew and deborder scanned images
#
# Copyright (C) 2008 Moreno Marzolla
#               2010 Stefan Kangas
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# Version 0.1, 2008/08/03
# Author: moreno.marzolla (at) pd.infn.it
# Modified by Stefan Kangas
# http://www.dsi.unive.it/~marzolla/


#
# This script is used to process a bunch of color, grayscale or B/W scans
# Syntax:
#
# cleanup_scans.sh <file1> <file2> ...
#
# This will process file1, file2... and produce file1.tiff file2.tiff...
# in the current directory.
#
# Color scans will be converted into color TIFFs; Grayscale or black/white 
# scans will be converted into B/W tiffs (unless the --forcecolor option 
# is used). Both color and grayscale pages are automatically deskewed.
#
# At the moment this script contains some hardcoded defaults, which need
# to be removed before using it as a general-purpose scan-to-tiff processor
#
# This script requires the following external applications:
# - ImageMagick (convert and mogrify)
# - netpbm, the current development version from svn (it uses the pamtilt
#   utility which is not included into the stable netpbm distribution)
# - perl (for evaluating a simple expression; I was unable to do that
#   using only bash)
#

convert=convert
pamtilt=pamtilt 
crop_geometry=2400x3250+0+0
deskew=yes
forcecolor=no
deborder=yes

function process_color_image() {
# Adjust color levels and crop
    local base=`basename $1 .image`
    local skew=0
    local deborder_cmd=(-fuzz 10% -fill white -draw "color 2540,3500 floodfill" )

    echo -n "Processing COLOR image $1..."

    if [ $deborder == "no" ]; then
        deborder_cmd=();
    fi

#     if [ $deskew == "yes" ]; then
#         echo -n "Tilt"    

# #            -crop $crop_geometry \
#         skew=`$convert -quiet $1 \
#             +repage \
#             -level 10%,80%,1 \
#             -monochrome \
#             "pnm:-" | $pamtilt`
        
#         skew=`perl -e "if (abs($skew)>0.1 && abs($skew)<3.0) { print (- $skew) } else { print 0 }"`
#         echo -n "(${skew})..."
#     fi        

    echo -n "converting..."
#        -crop $crop_geometry \
        # -rotate $skew \
    convert $1 \
        -background white \
        +matte "${deborder_cmd[@]}" \
        -level 10%,80%,1 \
        +repage \
        +matte \
        -format tiff \
        $base.tiff

    \rm -f $base.pnm
    echo "done"
}


function process_gray_image() {
    local base=`basename $1 .image`
    local skew=0
    local deborder_cmd=(-stroke black -fill black -draw "rectangle 0,0 50,3505" -draw "rectangle 0,0 2548,50" -draw "rectangle 0,3405 2548,3505" -draw "rectangle 2448,0 2548,3505" -fill white -draw "color 0,0 floodfill")

    if [ $deborder == "no" ]; then
        deborder_cmd=();
    fi

    echo -n "Processing GRAY image $1..."

# If the image is already black and white, then simpler operations must be performed
    # local bitssample=`tiffinfo $1 | grep Bits | tr -c -d [:digit:]`
    # if [ $bitssample -ne "1" ]; then
    echo -n "B/W (slow)..."
    $convert -quiet $1 \
        -colorspace gray \
        -level 10%,90%,1 \
        -blur 2 \
        +dither \
        -monochrome \
        -flatten "${deborder_cmd[@]}"
            # -crop $crop_geometry \

    # else
    #     echo -n "B/W (fast)..."
    #     $convert -quiet $1 "${deborder_cmd[@]}" \
    #         +repage \
    #         \( -write $base.pnm \) \
    #         +matte $base.tiff
            # -crop $crop_geometry \
    # fi

    # if [ $deskew == "yes" ]; then
    #     echo -n "Tilt"
    #     skew=`$pamtilt $base.pnm`
    #     skew=`perl -e "if (abs($skew)>0.1 && abs($skew)<3) { print (- $skew) } else { print 0 }"`
    #     echo -n "(${skew})..."
    # fi

    # echo -n "Rotate..."    
    # mogrify -quiet \
    #     +dither \
    #     -monochrome \
    #     +matte \
    #     -format tiff \
    #     -compress Group4 \
    #     $base.tiff
    #     # -rotate $skew \

    \rm -f $base.pnm
    echo "done"
}

function print_usage() {
cat<<EOF

Usage: $0 [--help] [--nodeskew] [--forcecolor] [--nodeborder] <inputfile> ...

--nodeskew   Do not deskew the image (default: deskew)
--forcecolor Do not convert grayscale images to B/W (default: convert to B/W)
--nodeborder Do not attempt to remove the black border (default: remove)
--help       Print this message

EOF

exit -1;
}

if [ $# -lt 1 ]; then
    print_usage;
fi

while [ $# -gt 0 ]; do
    file=$1

    shift;

    if [ $file == "--help" ]; then
        print_usage;
    fi

    if [ $file == "--nodeskew" ]; then
        deskew=no
        continue
    fi

    if [ $file == "--forcecolor" ]; then
        forcecolor=yes
        continue
    fi

    if [ $file == "--nodeborder" ]; then
        deborder="no";
        continue
    fi

    if [ ! -f $file ]; then
        echo "$file does not exist"
        continue
    fi

    if [ $forcecolor == "yes" ]; then
        process_color_image $file
    else        
        photoint=`tiffinfo ${file} | grep -i "Photometric Interpretation"`
        
        case $photoint in
            *"RGB color") process_color_image $file ;;
            *) process_gray_image $file ;;
        esac
    fi

done
