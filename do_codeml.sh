#! /bin/bash

process_fas_2_ACCN=/home/sswang/huche/archaea_GC/mtr_seq/aln/script/process_fas_2_ACCN.sh

bash $process_fas_2_ACCN --in $1 --model 2 --NSsites 0 --all_label --codeml
bash $process_fas_2_ACCN --in $1 --model 0 --NSsites 0,1,2,3,7,8 --codeml
