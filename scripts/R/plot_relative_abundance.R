# ============================================================
#  상위 N개 taxa 상대풍부도 stacked barplot
#  입력: MetaPhlAn merged_abundance.txt (또는 같은 형태의 taxa x sample 표)
#        metadata.tsv (sample_id, group 열)
#  출력: figures/relative_abundance_<level>.pdf / .png
# ============================================================
suppressPackageStartupMessages({
  library(tidyverse)
})

# ---- 설정 ----
abund_file <- "results/metaphlan/merged_abundance.txt"
meta_file  <- "metadata.tsv"
level      <- "g"     # "p"=phylum, "g"=genus, "s"=species
top_n      <- 15
out_prefix <- file.path("figures", paste0("relative_abundance_", level))

# ---- 읽기 ----
abund <- read_tsv(abund_file, comment = "#", show_col_types = FALSE) %>%
  rename(clade = 1)
meta <- read_tsv(meta_file, show_col_types = FALSE)

# 해당 level 만 남기기 (예: "g__" 로 끝나는 마지막 단계)
pattern <- paste0("\\|", level, "__[^|]+$")
tab <- abund %>%
  filter(str_detect(clade, pattern)) %>%
  mutate(taxon = str_extract(clade, paste0(level, "__[^|]+$")) %>%
           str_remove(paste0(level, "__"))) %>%
  select(-clade) %>%
  pivot_longer(-taxon, names_to = "sample_id", values_to = "abundance")

top_taxa <- tab %>%
  group_by(taxon) %>% summarise(mean_ab = mean(abundance)) %>%
  slice_max(mean_ab, n = top_n) %>% pull(taxon)

plot_df <- tab %>%
  mutate(taxon = if_else(taxon %in% top_taxa, taxon, "Others")) %>%
  group_by(sample_id, taxon) %>% summarise(abundance = sum(abundance), .groups = "drop") %>%
  left_join(meta, by = "sample_id") %>%
  mutate(taxon = fct_relevel(fct_reorder(taxon, abundance, .fun = sum, .desc = TRUE), "Others", after = Inf))

# ---- 그리기 ----
p <- ggplot(plot_df, aes(sample_id, abundance, fill = taxon)) +
  geom_col(width = 0.9) +
  facet_grid(~ group, scales = "free_x", space = "free_x") +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = NULL, y = "Relative abundance (%)", fill = NULL) +
  theme_bw(base_size = 11) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        panel.grid = element_blank(),
        strip.background = element_rect(fill = "grey95"))

dir.create("figures", showWarnings = FALSE)
ggsave(paste0(out_prefix, ".pdf"), p, width = 10, height = 5)
ggsave(paste0(out_prefix, ".png"), p, width = 10, height = 5, dpi = 300)
