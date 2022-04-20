#!/bin/bash -l
#PBS -d .
#PBS -l walltime=200:00:00,mem=23gb

# MULTIQC FOR MAP AND READS QUALITY CHECK

conda activate macs2;
module load python/python-3.8.2;
module load gcc;

multiqc --dirs reads mapped_reads
