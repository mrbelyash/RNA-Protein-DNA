#!/bin/bash
#PBS -d .
#PBS -l walltime=100:00:00,mem=8gb

# DOWNLOAD READS FROM SRA WITH SPLIT OF PAIRED READS

mkdir reads
sort -u reference/sra_list.txt | parallel -j 24 "/mnt/lustre/tools/sratoolkit/sratoolkit.2.8.0-centos_linux64/bin/fastq-dump.2.8.0 --split-files {}"
mv *fastq reads/
