#!/bin/bash
for alphabet in E F; do nohup phyml -i 'mtr'$alphabet'_NPYP.aln.phy' -q -d aa -m JTT -c 4 -a e -b 500; done

