#! /bin/bash


modeltest_phylo(){
	input=$1
	modeltest_phylo.sh -i $1 --mode raxml --cpu_prottest 2 --cpu_phylo 2 --outdir modeltest --bootstrap 500
}


(modeltest_phylo mtrA_NPYP_10%-80%.aln) &

(for i in `ls mtr{B,C,D}*`; do modeltest_phylo $i; done) &

(for i in `ls mtr{E,F,G,H}*`; do modeltest_phylo $i; done) &

wait



