#!/bin/bash
for alphabet in B C D; do nohup phyml -i 'mtr'$alphabet'_NPYP.aln.phy' -q -d aa -m JTT -c 4 -a e -b 500; done

