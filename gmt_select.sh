#!/bin/bash

usage() { echo "Usage: $0 [-A <azimuth>] [-L <"BLat BLon ELat ELon">] [-F <INPUT FILE>][-W <width>][-C <"lon_column lat_column depth_column">]" 1>&2; exit 1; }
while getopts ":A:C:F:L:W:" opt; do
	case "${opt}" in
		A)
			az=${OPTARG}
			;;
		C)
			xyz=${OPTARG}
			;;
		F)
			in_f=${OPTARG}
			;;
		L)
			Loc=${OPTARG}
			;;
		W)
			Wid=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done	
shift $((OPTIND -1))

if [ -z "${in_f}" ] || [ -z "${Wid}" ] || [ -z "${Loc}" ] || [ -z "${xyz}" ];then
	usage
fi

Loc=(${Loc})
xyz=(${xyz})

if [ ${#Loc[@]} -ne 4 ];then
	echo "Loc length is ${#Loc[@]}"
	usage
fi

blat=${Loc[0]}
blon=${Loc[1]}
elat=${Loc[2]}
elon=${Loc[3]}

x=${xyz[0]}
y=${xyz[1]}
z=${xyz[2]}

if [ -z $az ];then
	command -v distaz >/dev/null 2>&1 || { echo >&2 "distaz is not installed"; exit 1;}
	az=`distaz  $blat $blon $elat $elon | awk '{print $2}'`
fi

echo "AZIMUTH: $az"
echo "INPUT File: $in_f"
echo "Width: $Wid"
echo "BLON: $blon BLAT: $blat ELON: $elon ELON: $elat"

gmt begin gmt_select pdf 
#awk 'NR>1{print $4, $3}' ev_loc.dat | gmt plot -Sc0.2c
gmt project -C$blon/$blat -A`echo "$az+90"|bc` -L-$Wid/$Wid -G$Wid -Q > rect.txt
gmt project -C$elon/$elat -A`echo "$az-90"|bc` -L-$Wid/$Wid -G$Wid -Q >> rect.txt
awk 'NR==1{print $0}' rect.txt >> rect.txt
#gmt project $in_f -i1,2,3  -C$blon/$blat -E$elon/$elat -Q -W-$Wid/$Wid -Fxyz > ev_select.dat
gmt select $in_f -i$x,$y,$z -Frect.txt > ev_select.dat
gmt end
