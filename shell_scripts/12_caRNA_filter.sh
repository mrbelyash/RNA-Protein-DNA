#!/bin/bash
#PBS -d .
#PBS -l walltime=208:00:00

# ARRAY 0-23 FILTER EXPERIMENT FOR caRNA ONLY

while read num prot; do
  if [ "$num" = "$PBS_ARRAYID" ]; then
    PROT="$prot";
  fi
done < reference/n2prot.txt

mapfile caRNA < reference/caRNA.txt

awk -v c="${caRNA[*]}" -F '\t' '
    BEGIN { n=split(c,a," "); for (i=1;i<=n;++i) ca[a[i]] }
    $5 in ca' <experiment_bed/${PROT}.bed >experiment_bed/${PROT}.bedca;
mv experiment_bed/${PROT}.bedca experiment_bed/${PROT}.bed;

