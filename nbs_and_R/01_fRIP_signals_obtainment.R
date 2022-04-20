library(tidyverse)
setwd("Desktop/bioinformatics_group/")

# COLLECT PROTEIN SIGNALS INTO DATASET

srr2prot <- read_tsv("srr2prot.txt", col_names = F)
colnames(srr2prot) <- c("protein", "start", "end")

srr2prot <- srr2prot %>% mutate(start = as.numeric(str_remove(start, "SRR")), 
                                end = as.numeric(str_remove(end, "SRR")))
# collect read signals from counts
for (i in 1:nrow(srr2prot)) {
  current_files <- paste0("counts/c_SRR", srr2prot$start[i]:srr2prot$end[i], ".txt")
  x <- read_tsv(current_files[1])
  colnames(x)[2] <- current_files[1]
  for (file in current_files) {
    tmp <- read_tsv(file)
    colnames(tmp)[2] <- file
    x <- full_join(x, tmp)
    remove(tmp)
  }
  x[is.na(x)] <- 0
  counts_avg <- x %>% rowwise() %>% 
    mutate(`srr2prot$protein[i]` = sum(c_across(where(is.numeric)))) %>% 
    select(RNA, `srr2prot$protein[i]`)
  power <- counts_avg %>% filter(RNA == "count") %>% pull(`srr2prot$protein[i]`)
  counts_avg <- counts_avg %>% mutate(`srr2prot$protein[i]` = `srr2prot$protein[i]`/{{power}})
  colnames(counts_avg)[2] <- srr2prot$protein[i]
  write_tsv(counts_avg, file = paste0("signal_", srr2prot$protein[i], ".txt"))
}
# count signal for proteins
proteins <- srr2prot$protein[2:nrow(srr2prot)]
joined_table <- read_tsv("signal_input.txt")

for (i in 1:length(proteins)) {
  protein_read_ratio <- read_tsv(paste0("signal_", proteins[i], ".txt"))
  joined_table <- full_join(joined_table, protein_read_ratio)
}
joined_table[is.na(joined_table)] <- 0.000001
test <- as.data.frame(rep(joined_table[,2], 24))
new_fRIP_signals <- cbind(joined_table[,1], as_tibble(joined_table[,3:ncol(joined_table)] / test))
write_tsv(new_fRIP_signals, file = "clean_fRIP.txt")
frip <- read_tsv("clean_fRIP.txt")

setwd("types")
files <- list.files()
types_df <- read_tsv(files[1], col_names = F)
for (i in 2:length(files)){
  tmp <- read_tsv(files[i], col_names = F)
  types_df <- full_join(types_df, tmp)
  remove(tmp)
}
colnames(types_df) <- c("RNA", "type")
signal_w_types <- inner_join(frip, types_df)
setwd("..")
write_tsv(signal_w_types, file = "clean_fRIP_types.txt")
