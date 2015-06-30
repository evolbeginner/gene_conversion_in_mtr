#! /bin/sh
for i in `ls *phyml_tree`; do new=${i//.aln*/}; if [ ! -e $new'_'CDS ]; then mkdir $new'_'CDS; fi; cp phyml_tree/$i $new'_'CDS ; done

