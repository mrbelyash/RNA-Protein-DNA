#!/bin/bash/

plomb="sample"

for file in `ls *circ`; do
  prot=`echo $file | cut -d'.' -f1`;
  sed 's/$plomb/$prot/g' circos.conf;
  plomb=$prot
  circos -outputfile ${prot}.png -noparanoid;
done
