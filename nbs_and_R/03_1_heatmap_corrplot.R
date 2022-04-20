library(tidyverse)
library(pheatmap)
library(corrplot)

# MAKE HEATMAP AND CORRPLOT FOR TEXT

# load data
signals_matrix <- read_tsv("clean_fRIP_caRNA.txt")
redc_data <- read_tsv("K562.pvalue.tab") %>% select(gene_name_un, zscore)
for_corplot <- inner_join(signals_matrix, redc_data, by=c("RNA" = "gene_name_un"))
sign_prot <- read_tsv("signific_proteins.txt") %>% pull(proteins_frip)
caa_only <- for_corplot %>% select(all_of(c("RNA", sign_prot, "type"))) %>% 
  mutate(across(where(is.numeric), log2)) 
caa_only[caa_only <= 0] <- 0
remove(signals_matrix)

# make heatmap-digestable data
hm_df <- caa_only #tweak df here
for_hm <- hm_df %>%  rowwise() %>% filter(!(-Inf %in% c_across(where(is.numeric)))) %>% 
  distinct(RNA, .keep_all = T) %>% slice(1:100)
  

important_types <- c("protein_coding", "lncRNA", "snRNA", "miRNA", "snoRNA", "misc_RNA")
for_hm <- mutate(for_hm, type = ifelse(type %in% important_types, type,
                             ifelse(str_ends(type, "pseudogene"), "pseudogene", "other")))

ct_mtx <- for_hm %>% select(where(is.numeric)) %>% as.matrix()
rownames(ct_mtx) <- for_hm %>% pull(RNA)
colnames(ct_mtx) <- colnames(caa_only)[2:(ncol(caa_only) - 1)]
ct_mtx_sc <- t(scale(t(ct_mtx)))
ct_mtx_sc[is.nan(ct_mtx_sc)] <- 0
remove(ct_mtx)

#annotation for heatmap
meta <- for_hm %>% filter(RNA != "SCARNA10") %>% select(RNA, type) %>% as.data.frame()
meta$RNA <- factor(meta$RNA)
rownames(meta) <- meta$RNA
meta <- select(meta, -RNA)
annot_color <- list(type = c("lncRNA" = "#F7B801", "protein_coding" = "#080357", "snRNA" = "#723D46",
                             "miRNA" = "#F18701", "snoRNA" = "#1D2D44", "pseudogene" = "#701F0A", 
                             "misc_RNA" = "#3D348B", "other" = "#7678ED"))
cls <- c("#ffcfbd", "#ffb79e", "#ff9f7e", "#ff875f", "#FF7B4F", "#ff6f3f", "#ff5720", "#ff4b10", "#ff3f00")

pheatmap(ct_mtx_sc, scale = "none", color = cls, border_color = "#59656f", treeheight_col = 7,
         cellwidth = 10, cellheight = 6.7, fontsize = 8, annotation_row = meta, annotation_colors = annot_color,
         cutree_rows = 8, cutree_cols = 5)

#all caRNA heatmap
library(grid)
for_hm <- hm_df %>%  rowwise() %>% filter(!(-Inf %in% c_across(where(is.numeric)))) %>% 
  distinct(RNA, .keep_all = T) %>%
  mutate(mx_FC = max(c_across(where(is.numeric)))) %>%  
  ungroup() %>% arrange(desc(mx_FC)) %>% select(-mx_FC)
for_hm <- mutate(for_hm, type = ifelse(type %in% important_types, type,
                                       ifelse(str_ends(type, "pseudogene"), "pseudogene", "other")))

ct_mtx <- for_hm %>% select(where(is.numeric)) %>% as.matrix()
rownames(ct_mtx) <- for_hm %>% pull(RNA)
colnames(ct_mtx) <- colnames(caa_only)[2:(ncol(caa_only) - 1)]
ct_mtx_sc <- t(scale(t(ct_mtx)))
ct_mtx_sc[is.nan(ct_mtx_sc)] <- 0
remove(ct_mtx)
p<- pheatmap(ct_mtx_sc, color = cls, border_color = "#59656f", cellwidth = 20, cellheight = 0.6, 
         show_rownames = F, annotation_colors = annot_color, annotation_row = meta, cutree_rows = 10, 
         cutree_cols = 5, treeheight_col = 0, angle_col="315", fontsize = 15)
grid.draw(rectGrob(gp=gpar(fill="#f2f2f2", lwd=0)))
grid.draw(p)
ggsave(filename = "heatmap_sk2022.png", dpi = 320)
# make corrplot




col<- colorRampPalette(c("blue", "white", "red"))(200)
ct_mtx_corplot <- ct_mtx_sc[c(1, 3:51),]
M <- cor(t(ct_mtx_corplot))
testCor <- cor.mtest(M, conf.level = 0.95)
ret_type <- function(rna) {
  return(for_hm$type[for_hm$RNA == rna])
}
anot_names <- vector()
tmp_df <- as.data.frame(t(as.data.frame(annot_color[1])))
for (name in colnames(M)) {
  type <- ret_type(name)
  color <- as.character(tmp_df[1,type])
  anot_names <- append(anot_names, color)
}


par(bg="#f2f2f2")
corrplot(M, method = 'square', order = 'hclust', 
         p.mat = testCor$p, sig.level = c(0.001, 0.01, 0.05), pch.cex = 0.9,
         insig = 'label_sig', pch.col = 'grey20', type = 'lower', diag = T,
         col=col, tl.cex = 1,  tl.srt =30, bg="#ffffff", tl.col = anot_names)

as.data.frame(t(as.data.frame(tmp_df)))$lncRNA

grid.draw(rectGrob(gp=gpar(fill="#f2f2f2", lwd=0)))
grid.draw(cp)














