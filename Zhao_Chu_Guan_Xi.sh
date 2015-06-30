#!/bin/bash
for i in `ls *ffn`; do head -1 $i > dudu; i=`echo $i | sed -e 's/\..\+/\.1/'`; echo -en "$i\t"; sed -ne 's/.\+[|]:c\?[0-9]\+\-[0-9]\+ \([^,]\+\).\+$/\1/p' dudu | sed 's/ chromosome$//'; done;
