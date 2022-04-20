library(tidyverse)

# FILTER TRIADS FOR RNA ABOVE THRESHOLD

signals <- read_tsv("clean_fRIP.txt")
thrs <- read_tsv("prot2thr.txt")
threshold <- 1.69
proti <- c("cbp", "chd4", "dnmt1", "ezh2", "hnrnph", "pcaf", "phf8", "rbbp5", "suz12", "wdr5")
for (prot in proti) {
  tmp <- signals %>% select(RNA, as.name(prot))
  rnas <- tmp[tmp[2] > as.numeric(thrs[thrs[1] == prot, 2]),] %>% pull(RNA)
  triads <- read_tsv(paste0("signals/", prot, ".tri.bed"), col_names = F, show_col_types = F)
  colnames(triads) <- c("dna_chr", "dna_start", "dna_end", "rna_chr", "rna_start", "rna_end", "chain", "RNA", "type")
  tr <- triads %>% filter(RNA %in% rnas) %>% select(rna_chr:rna_end, dna_chr:dna_end) %>%
    mutate(dna_chr = str_replace(dna_chr, "chr", "hs"), rna_chr = str_replace(rna_chr, "chr", "hs"))
  write_tsv(tr, file = paste0(prot, ".circ"))
}