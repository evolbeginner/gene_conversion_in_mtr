#! /bin/bash

new_file_name=$1.beautiful
new_file_name_space=$1.beautiful.space
bootstrap_max=$2

#########################################################

[ $# -lt 2 ] && echo -e "USAGE:\n\t $0	file_name  bootstrap_max" && exit

script_path=$(cd "$(dirname "$0")"; pwd)

export PATH=$PATH:$script_path

change_OTUname_in_nwk.pl $1 | sponge $new_file_name

proportion_bootstrap.pl $new_file_name $2 | sponge $new_file_name

rm_space.sh $new_file_name | sponge $new_file_name_space

