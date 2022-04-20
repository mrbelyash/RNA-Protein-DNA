# Notebooks and R
This directory contains notebooks for data processing of QC metrics of read alignments as well as R scripts and Julia notebook for statistical analysis of data:
* ``QC_check.ipynb`` is a Python3 notebook to assess the quality of reads and their alignment and annotation onto the human hg38 genome;
* ``00_encode_data_parser.R`` is a script used for parsing ENCODE project db information on various interactomics data of proteins of interest;
* ``01_fRIP_signals_obtainment.R`` is a script that collects RNA-protein interactions signals from read counts;
* ``Thresholds.ipynb`` is a Julia notebook for threshold selection using rank statistics;
* ``02_protein_associativity.R`` is a script that performs Fisher's exact test on protein-RNA interactions data using said thresholds;
* ``03_1_heatmap_corrplot.R`` is a script that generates heatmaps and correlograms of RNA based on their protein interactions;
* ``03_2_upset_plots.R`` is a script that generates Upset-plots for fRIP-Seq data, and filtered to significant proteins fRIP-Seq data;
* ``03_filter_triads.R`` is a script to filter obtained triads for those RNA-protein interactions heving a signal above the corresponding threshold.
