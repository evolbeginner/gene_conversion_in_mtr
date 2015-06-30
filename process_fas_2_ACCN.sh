# /bin/bash

export PATH=~/huche/archaea_GC/perl_useful/:$PATH
eliminate_low_bootstrap_tool=~/tools/self_bao_cun/phylo_mini/eliminate_low_bootstrap_nodes.pl

#########################################################
while [ $# -gt 0 ]; do
	case $1 in 
		--fasta|--in|-i)	fasta_file=$2; shift;
		;;
		--NSsites)		NSsites=$2; shift;
		;;
		--model)		model=$2; shift;
		;;
		--all_label)		is_all_label=1;
		;;
		--codeml)		is_codeml=1;
		;;
	esac
	shift;
done
if [ ! -f $fasta_file ]; then
	echo "fasta_file $fasta_file does not exist"
	exit
fi

#########################################################
tmp_fasta=fasta
tmp_phy=$tmp_fasta.phy
tmp_paml=paml
tmp_tree=tree
codeml_result_dir=codeml_$fasta_file
paml_model_cmd="-model=$model"
paml_NSsites_cmd="-NSsites=$NSsites"

#########################################################
if [ -e $codeml_result_dir -a $is_force ]; then
	rm -rf $codeml_result_dir
fi
mkdir $codeml_result_dir 2>/dev/null

cd $codeml_result_dir

mkdir codeml_file.$paml_model_cmd.$paml_NSsites_cmd

cp ../$fasta_file ./

cd codeml_file.$paml_model_cmd.$paml_NSsites_cmd

# special modifications of seq_titles
sed 's/.\+\([YNZW]P_\)/>\1/g' ../$fasta_file > $tmp_fasta

MFAtoPHY.pl $tmp_fasta

phyml -i $tmp_phy -m GTR -a e -f m -v e
tmp_tree=${tmp_phy}_phyml_tree.txt
 
# special modifications of OTUs
sed -i 's/)[^:;]\+/)/g' $tmp_tree

muscle_paml.pl $tmp_fasta > $tmp_paml
create_codemlctl.pl -seqfile=$tmp_paml -treefile=$tmp_tree $paml_NSsites_cmd $paml_model_cmd --force
mv $tmp_fasta ../
cp $tmp_paml $tmp_tree ../

if [ ! -z $is_all_label ]; then
	perl $eliminate_low_bootstrap_tool --in $tmp_tree --branch_length 10000 --label | sponge $tmp_tree
fi

[ ! -z $is_codeml ] && codeml

