#!/bin/sh
#PBS -d .
#PBS -l walltime=200:00:00,mem=10gb

# INTERSECT UNFILTERED TRIADS WITH CHIP-SEQ TO GET VALIDATION

# file a - Unfiltered triads, b - ChIP-Seq data
intersectBed="/home/tools/bedtools/bedtools-v2.16.2/bin/intersectBed";

for PROT in `ls chipseq/*bed | sed 's/.bed//g' |sed 's/chipseq\///g'`; do
  mkdir triads/chipseq/${PROT}
  for chr in `ls redc_contacts/ | sed 's/K562.//g' | sed 's/.vote.tab//g'`; do
    $intersectBed -a triads/no_chipseq/${PROT}/${PROT}.tri1.${chr}.bed \
                  -b chipseq/chromosomes/${PROT}/${PROT}.${chr}.bed > triads/chipseq/${PROT}/${PROT}.tri.${chr}.bed;
  done
done

