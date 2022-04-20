#!/bin/sh
#PBS -d .
#PBS -l walltime=200:00:00

# REPLACE DNA COORDS WITH RNA COORDS FOR INTERSECT AFTERWARDS

for PROT in `ls experiment_bed/*bed | sed 's/.bed//g' |sed 's/experiment\///g'`; do
  for chr in `ls redc_contacts/ | sed 's/K562.//g' | sed 's/.vote.tab//g'`; do
    awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$9"\t"$10"\t"$11"\t"$12"\t"$14"\t"$15}' \
        triads/no_chipseq/${PROT}/${PROT}.tri.${chr}.bed | awk \
        '$4 == $5 {print $6"\t"$7"\t"$8"\t"$1"\t"$2"\t"$3"\t"$4"\t"$9"\t"$10}' > triads/no_chipseq/${PROT}/${PROT}.tri.${chr}.tmp;
    mv triads/no_chipseq/${PROT}/${PROT}.tri.${chr}.tmp triads/no_chipseq/${PROT}/${PROT}.tri.${chr}.bed;
  done
done
