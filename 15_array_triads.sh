#!/bin/sh
#PBS -d .
#PBS -l walltime=200:00:00

# ARRAY 0-23 MAKE RAW TRIADS

intersectBed="/home/tools/bedtools/bedtools-v2.16.2/bin/intersectBed";

while read num prot; do
  if [ "$num" = "$PBS_ARRAYID" ]; then
    PROT="$prot";
  fi;
done < reference/n2prot.txt;

mkdir triads/no_chipseq/${PROT}
for chr in `ls redc_contacts/ | sed 's/K562.//g' | sed 's/.vote.tab//g'`; do
  $intersectBed -a experiment_bed/chromosomes/${PROT}/${PROT}.${chr}.bed \
                -b redc_contacts/K562.${chr}.vote.tab -wb > triads/no_chipseq/${PROT}/${PROT}.tri.${chr}.bed;
done
