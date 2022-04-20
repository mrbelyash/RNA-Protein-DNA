#!/bin/bash
#PBS -d .
#PBS -l walltime=100:00:00

# ARRAY 0-349 COUNT FEATURES FOR QC ANALYSIS

tmp=`expr 1976598 + $PBS_ARRAYID`
name_mask="SRR${tmp}"

mkdir mapped_reads/binary
mkdir bed_reads
for file in mapped_reads/*${name_mask}*; do 
  samtools view -S -b $file > $file.bam;
done;

mv mapped_reads/*${name_mask}*bam mapped_reads/binary/

for FILE in mapped_reads/binary/*${name_mask}*raw.sam.bam; do 
  /home/tools/bedtools/bedtools-v2.16.2/bin/bamToBed -i $FILE > $FILE.bed;
done;

mv mapped_reads/binary/*${name_mask}*bed bed_reads/

rm -R mapped_reads/binary/*${name_mask}*

for bedfile in bed_reads/*${name_mask}*.bed; do
  awk '{print $1}' $bedfile | awk -F'.' '{print $1}' | awk -F'_0000' '{print "chr"$2 + 0}' > $bedfile.tmp.txt;
  sed 's/23/Y/' $bedfile.tmp.txt | sed 's/24/X/' > $bedfile.2.txt;
  mv $bedfile.2.txt $bedfile.tmp.txt;
  paste $bedfile.tmp.txt $bedfile > $bedfile.3.txt;
  awk '{print $1"\t"$3"\t"$4"\t"$7}' $bedfile.3.txt > $bedfile.res.bed;
  rm $bedfile.tmp.txt;
  rm $bedfile.3.txt;
done;

rm bed_reads/*${name_mask}*bam.bed;

for file in bed_reads/*${name_mask}*res.bed; do
  /home/tools/bedtools/bedtools-v2.16.2/bin/intersectBed -a $file -b /home/dkhlebnikov/new_fRIP/reference/v39.basic.bed -u > $file.intersected.bed;
done;

rm bed_reads/*${name_mask}*res.bed;
for file in bed_reads/*${name_mask}*intersected.bed; do
  wc -l $file >> annot_counts.txt;
done
rm bed_reads/*${name_mask}*intersected.bed;
