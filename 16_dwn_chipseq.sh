#!/bin/bash -l
#PBS -d .
#PBS -l walltime=200:00:00,mem=23gb

# CHIP-SEQ DOWNLOAD AND PREPROCESS

# download and unzip
while read name link; do
  wget -O chipseq/${name}.bed.gz $link --no-check-certificate;
  gzip -d chipseq/${name}.bed.gz
done < reference/chipseq_links.txt;

# other format parsing
rm chipseq/\#no.bed.gz;
awk '{print $1"\t"$2"\t"$3"\t"$5}' chipseq/wdr5.bed > chipseq/wdr.tmp; mv chipseq/wdr.tmp wdr5.bed;

# filter and parse ENCODE peaks
for peaks in `ls chipseq*/*.bed`; do
  awk '{print $1"\t"$2"\t"$3"\t"$7"\t"$9}' $peaks > $peaks.tmp;
  mv $peaks.tmp $peaks;
done;

mv wdr5.bed chipseq/wdr5.bed;

# chr split for faster downstream work
#mkdir chipseq/chromosomes;

for PROT in `ls chipseq/*bed | sed 's/.bed//g' | sed 's/chipseq\///g'`; do
#  mkdir chipseq/chromosome/${PROT}
  for chr in `cut -f 1 chipseq/${PROT}.bed | sort | uniq`; do
                grep -w $chr chipseq/${PROT}.bed > chipseq/chromosomes/${PROT}/${PROT}.${chr}.bed
  done
done

rm chipseq/chromosomes/*/*KI*
rm chipseq/chromosomes/*/*Un*
rm chipseq/chromosomes/*/*random*
