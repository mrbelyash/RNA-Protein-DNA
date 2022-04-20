library(tidyverse)
library(ComplexUpset)

# MAKE UPSET-PLOTS FOR TEXT

thrs <- read_tsv("prot2thr.txt")
get_thr <- function(pr) {
  return(thrs$threshold[thrs$protein == pr])
}
# use caa_only <- signals_matrix for all proteins, and standard for signif
#UpSetR plot
signals_matrix <- read_tsv("clean_fRIP_types.txt")
sign_prot <- read_tsv("signific_proteins.txt") %>% pull(proteins_frip)
caa_only <- signals_matrix %>% select(all_of(c("RNA", sign_prot, "type")))
remove(signals_matrix)
RNA <- caa_only$RNA
type <- caa_only$type
for (x in colnames(caa_only)[2:17]) {
  caa_only[[x]] = ifelse(caa_only[[x]] > get_thr(x), T, F)
}
caa_only <- as_tibble(caa_only)
caa_only$RNA <- RNA
caa_only$type <- type
remove(RNA, type)

important_types <- c("protein_coding", "lncRNA", "snRNA", "miRNA", "snoRNA")
caa_only <- mutate(caa_only, type = ifelse(type %in% important_types, type,
                                       ifelse(str_ends(type, "pseudogene"), "pseudogene", "other")))
remove(important_types)
caa_only <- caa_only %>% mutate(across(where(is.numeric), as.logical))

clrs <- c("protein_coding" = "#87BCDE", "lncRNA" = "#E55381", "snRNA" = "#5A0002", 
          "miRNA" = "#A40606", "snoRNA" = "#D98324", "pseudogene" = "#D7CF07", "other" = "#37FF8B")
  
# for caRNA
signals_matrix <- read_tsv("clean_fRIP_caRNA.txt")
sign_prot <- read_tsv("signific_proteins.txt") %>% pull(proteins_frip)
caa_only <- signals_matrix %>% select(all_of(c("RNA", sign_prot, "type")))
remove(signals_matrix)
RNA <- caa_only$RNA
type <- caa_only$type
for (x in colnames(caa_only)[2:17]) {
  caa_only[[x]] = ifelse(caa_only[[x]] > get_thr(x), T, F)
}
caa_only$RNA <- RNA
caa_only$type <- type
remove(RNA, type)

important_types <- c("protein_coding", "lncRNA", "snRNA", "miRNA", "snoRNA")
caa_only <- mutate(caa_only, type = ifelse(type %in% important_types, type,
                                           ifelse(str_ends(type, "pseudogene"), "pseudogene", "other")))
remove(important_types)
caa_only <- caa_only %>% mutate(across(where(is.numeric), as.logical))

clrs <- c("protein_coding" = "#87BCDE", "lncRNA" = "#E55381", "snRNA" = "#5A0002", 
          "miRNA" = "#A40606", "snoRNA" = "#D98324", "pseudogene" = "#D7CF07", "other" = "#37FF8B")

# all proteins
upset(sample_n(caa_only, 57244, replace = F), 
      colnames(caa_only)[2:25], name='protein',
      base_annotations=list(
        'Intersection size'=intersection_size(
          counts=FALSE,
          mapping=aes(fill=type)
        ) + scale_fill_manual(values=clrs)),
      width_ratio = 0.1, min_size = 200,
      set_sizes=(
        upset_set_size(
          geom=geom_bar(
            aes(fill=type),width=0.8), 
          position='right')),
      guides='over')
upset(caa_only, 
      colnames(caa_only)[2:25], name='protein',
      base_annotations=list(
        'Intersection size'=intersection_size(
          counts=FALSE,
          mapping=aes(fill=type)
        ) + scale_fill_manual(values=clrs)),
      width_ratio = 0.1, min_size = 3,
      set_sizes=(
        upset_set_size(
          geom=geom_bar(
            aes(fill=type),width=0.8), 
          position='right')),
      guides='over')

# significant proteins)
upset(sample_n(caa_only, 57244, replace = F), 
      sign_prot, name='protein',
      base_annotations=list(
        'Intersection size'=intersection_size(
          counts=FALSE,
          mapping=aes(fill=type)
        ) + scale_fill_manual(values=clrs)),
      width_ratio = 0.1, min_size = 200,
      set_sizes=(
        upset_set_size(
          geom=geom_bar(
            aes(fill=type),width=0.8), 
          position='right')),
      guides='over')
upset(caa_only, 
      sign_prot, name='protein',
      base_annotations=list(
        'Intersection size'=intersection_size(
          counts=FALSE,
          mapping=aes(fill=type)
        ) + scale_fill_manual(values=clrs)),
      width_ratio = 0.1, min_size = 3,
      set_sizes=(
        upset_set_size(
          geom=geom_bar(
            aes(fill=type),width=0.8), 
          position='right')),
      guides='over')
  
  
