#!/bin/bash
#PBS -d .
#PBS -l walltime=108:00:00,mem=20gb

# PREPROCESS REFERENCE GENOME ANNOTATION

awk -F'\t' '$3!="transcript"' reference/gencode.v39.annotation.gtf | awk -F'\t' '{print $9}' | awk -F'gene_type "' '{print $2}' | awk -F'";' '{print $1}' > reference/types.txt;
awk -F'\t' '$3!="transcript"' reference/gencode.v39.annotation.gtf | awk -F'\t' '{print $9}' | awk -F'gene_name "' '{print $2}' | awk -F'";' '{print $1}' > reference/names.txt;
awk -F'\t' '$3!="transcript"' reference/gencode.v39.annotation.gtf | awk -F'\t' '{print $1"\t"$4"\t"$5"\t"$7}' > reference/coords.txt;

paste reference/coords.txt reference/types.txt reference/names.txt > reference/v39.basic.bed;
