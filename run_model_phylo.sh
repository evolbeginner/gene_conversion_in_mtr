#! /bin/bash

for i in mtrF_NPYP_20%.aln mtrG_NPYP_20%_18%.aln; do
	modeltest_phylo.sh -i $i --mode raxml --cpu_prottest 1 --cpu_phylo 2 --outdir modeltest --bootstrap 500
done


