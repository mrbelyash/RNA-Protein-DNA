#!/bin/bash
#PBS -d .
#PBS -l walltime=108:00:00,mem=10gb

# ARRAY 0-349 COUNT READS

tmp=`expr 1976598 + $PBS_ARRAYID`
name_mask="SRR${tmp}"

module load python/python-3.8.2;
python3.8 09__pys2.py ${name_mask}.bed;
