#!/bin/sh
#PBS -d .
#PBS -l walltime=100:00:00,mem=23gb

# COLLECT RUNS INTO EXPERIMENTS [REPLICAS COMBINED]

mkdir experiment_bed
cd contacts
set -- *.bed

while read -r group first last; do
        collect=false

        for name do
                if ! "$collect"; then
                        [ "$name" = "$first.bed" ] || continue
                        collect=true
                fi

                if "$collect"; then
                        cat -- "$name"
                        [ "$name" = "$last.bed" ] && break
                fi
        done >../exp_for_peaks/"$group.bed"

done <../reference/srr2prot.txt

for file in `ls exp_for_peaks/`; do
  awk '!seen[$0]++' exp_for_peaks/$file > exp_for_peaks/$file.tmp;
  mv exp_for_peaks/$file.tmp experiment_bed/$file;
done

