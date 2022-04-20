#!/bin/bash
#PBS -d .
#PBS -l walltime=100:00:00

# ARRAY 0-349 GET RNA TYPES FOR THE CONTACTS TABLE

tmp=`expr 1976598 + $PBS_ARRAYID`
name_mask="SRR${tmp}"

awk '{print $6"\t"$5}' contacts/${name_mask}.bed | awk '!seen[$0] {print} {++seen[$0]}' > types/${name_mask}.types.tsv;
