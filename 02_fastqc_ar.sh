#!/bin/bash
#PBS -d .
#PBS -l walltime=108:00:00,mem=10gb

# ARRAY 0-349 FASTQC FOR READS QUALITY CHECK

tmp=`expr 1976598 + $PBS_ARRAYID`
name_mask="SRR${tmp}"

cd reads;
module load gcc;
for FILE in `ls ${name_mask}*fastq`; do
  /mnt/lustre/tools/fastqc/FastQC-0.11.8/fastqc ${FILE};
done
