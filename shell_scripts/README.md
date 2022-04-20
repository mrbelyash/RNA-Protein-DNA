# Shell Scripts
This directory contains (mostly) shell scripts for reads analysis and triads collection:
* ``01_download.sh`` is a script to download fRIP-Seq data;
* ``02_fastqc_ar.sh`` is a script to check reads quality;
* ``03_map_ar.sh`` is a script to map reads to reference genome;
* ``04_multiqc.sh`` is a script to asses the quality of mapping;
* ``05_ref2bed.sh`` is a script to convert GTF/GFF3 annotation files to bed;
* ``06_bam_to_sbed_ar.sh`` is a script to intersect reads with annotation to get contacts;
* ``07_sort2hts.sh`` is a script to assess read annotation quality;
* ``08_signalsCounter_ar.sh`` is a script to count reads in contacts;
* ``08__pyscript.py`` is an additional script for ``08_signalsCounter_ar.sh``;
* ``09_RNAtypes.sh`` is a script to get RNA types (workaround);
* ``10_collectExp.sh`` is a script to collect replicas into single files;
* ``11_piranha_array.sh`` is a script to call RNA-protein interactions peaks (**not working!!**);
* ``12_caRNA_filter.sh`` is a script to filter contacts for caRNA only;
* ``13_f_chrspl.sh`` is a script to split experiments into chromosomes for memory efficiency;
* ``14_redc_rebuild.sh`` is a script to preprocess Red-C data;
* ``15_array_triads.sh`` is a script to collect unfiltered triads - basically to intersect Red-C and fRIP-Seq;
* ``16_dwn_chipseq.sh`` is a script to download and preprocess available ChIP-Seq data;
* ``17_rearr_triads.sh`` is a script to arrange unfiltered data for further intersection with ChIP-Seq peaks;
* ``18_dna_chr.sh`` is a script that continues ``17_rearr_triads.sh`` work;
* ``19_triad_cs.sh``is a script to collect RNA-protein-DNA triads validated by ChIP-Seq.

