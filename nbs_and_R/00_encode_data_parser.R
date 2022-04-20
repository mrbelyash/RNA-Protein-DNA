library(tidyverse)
library(googlesheets4)

# PARSE ENCODE FOR DATA
meta <- read_tsv("encode_metadata.tsv")
colnames(meta) <- c("ID", "experiment", "target", "target2", "cell_line")
meta <- meta %>% filter(experiment != "Control eCLIP") %>% 
  select(-target2, -ID) %>% 
  select(target, cell_line, experiment) %>% 
  arrange(desc(target), experiment)
info <- meta %>% pivot_wider(names_from = experiment, 
                          values_from = experiment, 
                          values_fn = list(experiment = ~1), 
                          values_fill = list(experiment = 0)) %>%
              pivot_wider(names_from = cell_line, 
                          values_from = cell_line, 
                          values_fn = list(cell_line = ~1), 
                          values_fill = list(cell_line = 0))
flt <- function(x, vec) {
  x %>% filter(K562 == vec[1], HepG2 == vec[2], 
               `S2R+` == vec[3], GM12878 == vec[4], `adrenal gland` == vec[5])
}
info %>% filter(`adrenal gland` == 1)

gs_auth(new_user = TRUE)
gs4_create("ENCODE data availability", sheets = list(ENCODE = info))
