#!/bin/bash
#PBS -d .
#PBS -l walltime=100:00:00

# ARRAY 0-23 REARRANGE UNFILTERED TRIADS

while read num prot; do
  if [ "$num" = "$PBS_ARRAYID" ]; then
    PROT="$prot";
  fi;
done < reference/n2prot.txt;

cat triads/no_chipseq/${PROT}/* > triads/no_chipseq/${PROT}.unf.bed

for chr in `cut -f 1 triads/no_chipseq/${PROT}.unf.bed | sort | uniq`; do
  grep -w $chr triads/no_chipseq/${PROT}.unf.bed > triads/no_chipseq/${PROT}/${PROT}.tri1.${chr}.bed
done
