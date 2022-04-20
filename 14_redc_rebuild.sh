#!/bin/bash
#PBS -d .
#PBS -l walltime=100:00:00,mem=20gb

# PREPROCESS RED-C DATA

for file in `ls redc_contacts/`; do
  awk -F'\t' 'NR > 1 {print $1"\t"$2"\t"$3"\t"$4"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12}' redc_contacts/$file > redc_contacts/$file.tmp;
  mv redc_contacts/$file.tmp redc_contacts/$file;
done
