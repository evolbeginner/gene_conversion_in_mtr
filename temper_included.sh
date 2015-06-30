#! /bin/bash

result_dir="./rbp/rbp_result/non_temperature/"
temperature_file="./rbp/rbp_script_dir/rbp/rbp_script_dir/rbp/rbp_script_dir/rbp/temperature/sorted_prok_temperature"

for file in S_rbp L_rbp non_rbp;
do
	sort -k 6 "$result_dir/$file" | join -t $'\t' "$temperature_file" - -1 1 -2 6 | awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,$4,$5,$6,$7}' > ${file}_taxaname; 
done


# sorted_prok_temperature is a file containing the information of living TEMP of prokaryotes located in TEMP file

