#! /bin/bash

input_dir=$1;
output_dir=$2;

for i in `ls "$input_dir"`
do
	echo $i;
	k=0;
	unset $del;
	enc_output="$output_dir/${i}.enc"
	tmp_file="$output_dir/tmp/${i}.tmp"

	[[ `grep '^>' $input_dir/$i | wc -l` -lt 1000 ]] && continue;
	mkdir -p $output_dir/tmp;
	[[ -e $tmp_file ]] && rm "$tmp_file";
	cat "$input_dir/$i" | while read line
	do
		k=$(($k+1));
		[[ $line =~ '>' ]] && title=$line;
		if [[ ! $line =~  '>' ]]
		then
			[[ ${#line} -gt 300 ]] && echo -ne "${title}\n${line}\n" >> "$tmp_file";
		fi
	done
	enc -gc -gc3s -silent $tmp_file $enc_output
	date;
done




