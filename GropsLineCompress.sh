#!/bin/bash
# Script written by Wim Stockman on 2021-01-24
# Inspired by Werner Lemberg response on 2021-01-21 in the gnu groff mailinglist subject "Huge Filesize of PS file 12M" 
# This script compresses the multiple consecutive DL (drawline) statements grops output to draw a single line to one DL statement
# Usage: GropsLineCompress.sh filename > outputfile
# Usage: cat file | GropsLineCompress.sh  > outputfile
awk '/ DL/{ORS=" ";print $0; ORS=RS ; next;}{print $0}' $1 | sed 's/ DL/ DL\n/g' | \
awk '
BEGIN {
	e = 0
}
{
	if( $NF == "DL"){
		if (stacking == 1) {
			if ( lijnmode == "H") {
			   if ((x1 == $(NF-2)) && (y1 == $(NF-3)) && (y2 == $(NF-1))) {
				line[e-4] = $(NF-4);
				x1 = $(NF-4)
				x2 = $(NF-2)
				}
			   else {
				for (i=1;i<=e;i++){
					str=str" "line[i]
				}
				print str
				str=""
				lijnmode=""
				for(k in line){delete line[k]}
				stacking=0;
				}
			 }
			if ( lijnmode == "V") {
			   if ((y1 == $(NF-1)) && (x1 == $(NF-4)) && (x2 == $(NF-2))) {
				line[e-3] = $(NF-3);
				y1 = $(NF-3)
				y2 = $(NF-1)
				}
			   else {
				for (i=1;i<=e;i++){
					str=str" "line[i]
				}
				print str
				str=""
				lijnmode=""
				for(k in line){delete line[k]}
				stacking=0;
				}
			}
		}
		if (stacking == 0) {
			for(i=NF;i>0;i--) {
				line[i]=$i
			}
			stacking = 1;
			e = NF;
			x1 = line[e-4]
			x2 = line[e-2]
			y1 = line[e-3]
			y2 = line[e-1]
			if( x1 == x2) lijnmode = "V";
			if( y1 == y2) {
				lijnmode = "H";
			}
		}
	}
	else {
		if(stacking == 1){
			for (i=1;i<=e;i++){
				str=str" "line[i]
			}
			print str
			str=""
			lijnmode=""
			for(k in line){delete line[k]}
			stacking=0
			print $0
		}
		else {
			print $0;
		}
	}
}
'
