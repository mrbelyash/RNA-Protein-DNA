#!/bin/bash
#PBS -d .
#PBS -l walltime=108:00:00,mem=10gb

# ITERATIVE CHROMOSOME SPLIT EXPERIMENT caRNA

mkdir experiment_bed/chromosomes

for PROT in `ls experiment_bed/*bed | sed 's/.bed//g' | sed 's/experiment\///g'`; do
  mkdir experiment_bed/chromosomes/${PROT}
  for chr in `cut -f 1 experiment_bed/${PROT}.bed | sort | uniq`; do
                grep -w $chr experiment_bed/${PROT}.bed > experiment_bed/chromosomes/${PROT}/${PROT}.${chr}.bed
  done
done
