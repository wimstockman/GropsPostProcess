#!/bin/bash
# Script written by Wim Stockman on 2021-01-24
# Inspired by John Gardner response on 2021-01-23 in the gnu groff mailinglist subject "Huge Filesize of PS file 12M" 
# This script compresses the multiple /.notdef lines when including a font
# saving the different not /.notdef lines
# Usage: GropsLineCompress.sh filename > outputfile
awk '/\/.notdef/{ORS=" ";print $0; ORS=RS ; next;}{print $0}' $1 | \
sed 's/\/.notdef/\n\/.notdef\n/g' | sed '/^[[:space:]]*$/d' | \
awk '
Begin {
skiplines=0
}
/SUBENC.\[/ { 
	match($0, /(SUBENC.)(\[)/, enc)
	print $0"255{/.notdef}repeat";
	skiplines=NR+256
	next;
}
{
	if (NR <= skiplines) {
		if ($0 !~ /notdef/) k[NR]=enc[1]" "255+NR-skiplines $0 " put"
	next

	}
	if (NR == (skiplines+1)) {
		print $0
		for (i in k){ print k[i]}
		next
	}
	skiplines=0;
	print $0;	
}'

