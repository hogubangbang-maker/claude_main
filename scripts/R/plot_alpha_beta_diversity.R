# ============================================================
#  α-diversity (Shannon, Observed) boxplot + β-diversity PCoA (Bray–Curtis)
#  입력: taxa x sample abundance 표 (첫 열 = taxon), metadata.tsv (sample_id, group)
#  출력: figures/alpha_diversity.pdf, figures/pcoa_bray.pdf
# ============================================================
suppressPackageStartupMessages({
  library(tidyverse)
  library(vegan)
})

abund_file <- "results/species_table.tsv"
meta_file  <- "metadata.tsv"

mat  <- read_tsv(abund_file, show_col_types = FALSE) %>% column_to_rownames(var = names(.)[1])
meta <- read_tsv(meta_file, show_col_types = FALSE)
comm <- t(as.matrix(mat))                       # sample x taxa
meta <- meta[match(rownames(comm), meta$sample_id), ]

# ---- α-diversity ----
# Observed 는 count 기반일 때 의미가 정확합니다 (상대풍부도면 '검출 taxa 수'로 해석)
alpha <- tibble(
  sample_id = rownames(comm),
  Shannon   = diversity(comm, index = "shannon"),
  Observed  = rowSums(comm > 0)
) %>% left_join(meta, by = "sample_id") %>%
  pivot_longer(c(Shannon, Observed), names_to = "metric")

p_alpha <- ggplot(alpha, aes(group, value, fill = group)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.15, size = 1.5) +
  facet_wrap(~ metric, scales = "free_y") +
  labs(x = NULL, y = NULL) +
  theme_bw() + theme(legend.position = "none")

# ---- β-diversity ----
bc   <- vegdist(comm, method = "bray")
pcoa <- cmdscale(bc, k = 2, eig = TRUE)
var_exp <- round(100 * pcoa$eig[1:2] / sum(pcoa$eig[pcoa$eig > 0]), 1)

perm <- adonis2(bc ~ group, data = meta, permutations = 999)
lab  <- sprintf("PERMANOVA R² = %.3f, p = %.3f", perm$R2[1], perm$`Pr(>F)`[1])

pcoa_df <- as_tibble(pcoa$points, rownames = "sample_id") %>%
  setNames(c("sample_id", "PC1", "PC2")) %>% left_join(meta, by = "sample_id")

p_beta <- ggplot(pcoa_df, aes(PC1, PC2, colour = group)) +
  geom_point(size = 2.5) +
  stat_ellipse(linetype = 2) +
  labs(x = paste0("PCoA1 (", var_exp[1], "%)"),
       y = paste0("PCoA2 (", var_exp[2], "%)"),
       subtitle = lab, colour = NULL) +
  theme_bw()

dir.create("figures", showWarnings = FALSE)
ggsave("figures/alpha_diversity.pdf", p_alpha, width = 6, height = 4)
ggsave("figures/pcoa_bray.pdf", p_beta, width = 6, height = 5)
