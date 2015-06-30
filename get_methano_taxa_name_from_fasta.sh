awk '/^>Methano/{a[substr($0,match($0,/[^-]-[^-]+/)+2,RLENGTH-2)]++}END{for (i in a){{print i}}}' $1 | perl -pe 's/(?<=[^_])_(?=[^_])/ /g' | sed 's/__/-/g' 
