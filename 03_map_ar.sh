#!/bin/bash
#PBS -d .
#PBS -l walltime=108:00:00

# ARRAY 0-349 MAP READS TO REF GENOME WITH LOGS

hisat2='/home/tools/hisat/hisat2-2.2.1/hisat2'
module load gcc;

mkdir mapped_reads
mv reference/GRCh38* .
tmp=`expr 1976598 + $PBS_ARRAYID`;
name_mask="SRR${tmp}";

$hisat2 -p 10 -x GRCh38.p13 -1 reads/${name_mask}_1.fastq -2 reads/${name_mask}_2.fastq \
        --summary-file mapped_reads/log_hisat_${name_mask}.txt -S mapped_reads/mapped_${name_mask}_raw.sam; 

