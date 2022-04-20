library(tidyverse)
library(googlesheets4)

# DETERMINE PROTEIN CARNA ASSOCIATION USING FOUND THRESHOLDS

#load Red-C and fRIP data
setwd("C:/Users/danii/frip_signals")
redc <- read_tsv("K562.pvalue.tab") %>% filter(ensg != "no")
frip_redc <- read_tsv("clean_fRIP_types.txt") %>% filter(RNA %in% redc$gene_name_un)
redc$p.adj <- p.adjust(redc$pval, method="BH")
thresholds <- read_tsv("prot2thr.txt")
k <- mean(thresholds$threshold)
ca_rna_redc <- redc %>% filter(zscore > 1.753) # caRNA red-c
nca_rna_redc <- redc %>% filter(zscore < 1.753) # ncaRNA Red-C

pvals_vector <- vector()
proteins_frip <- names(frip_redc[c(2:25)])
for (ind in 2:25) {
  cur_df <- cbind(frip_redc[1], frip_redc[ind])
  ca_react <-     nrow(cur_df %>% filter(RNA %in%  ca_rna_redc$gene_name_un) %>% filter(.[[2]] > k))
  nca_react <-    nrow(cur_df %>% filter(RNA %in% nca_rna_redc$gene_name_un) %>% filter(.[[2]] > k))
  ca_no_react <-  nrow(cur_df %>% filter(RNA %in%  ca_rna_redc$gene_name_un) %>% filter(.[[2]] < k))
  nca_no_react <- nrow(cur_df %>% filter(RNA %in% nca_rna_redc$gene_name_un) %>% filter(.[[2]] < k))
  table_for_fisher <- data.frame(c(ca_react, ca_no_react), c(nca_react, nca_no_react))
  print(table_for_fisher)
  pvals_vector <- append(pvals_vector, fisher.test(table_for_fisher)$p.value)
}

pvals_adj <- p.adjust(pvals_vector, method="BH")
fisher_res <- data.frame(proteins_frip, pvals_vector, pvals_adj) %>% arrange(pvals_adj)
sign_fish <- subset(fisher_res, pvals_adj < 0.05)
write_tsv(sign_fish, file = "signific_proteins.txt")

write_tsv(frip_redc %>% filter(RNA %in% ca_rna_redc$gene_name_un), file = "clean_fRIP_caRNA.txt")
remove(ca_rna_redc, nca_rna_redc)
