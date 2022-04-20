#!/bin/bash -l
#PBS -d .
#PBS -l walltime=200:00:00

# ARRAY 0-23 PIRANHA CALL PEAKS

conda activate macs2;
module load python/python-3.8.2;
module load gcc;

while read num prot; do
  if [ "$num" = "$PBS_ARRAYID" ]; then
    PROT="$prot";
  fi
done < reference/n2prot.txt

Piranha exp_for_peaks/${PROT}.bed -o experiment_bed/peaks/${PROT}_peak.bed -s -p 0.05 -z 100;
