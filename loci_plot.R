
library(ggplot2)


afr <- fread('GWAS_final/afr_SPARKfinal.txt')
amr <- fread('GWAS_final/amr_SPARKfinal.txt')
eur <- fread('GWAS_final/whit_SPARKfinal.txt')
meta <- fread('GWAS_final/METAANALYSIS1.txt')

afr$lower_ci <- afr$beta - 1.96 * afr$SE
afr$upper_ci <- afr$beta + 1.96 * afr$SE
head(afr)

amr$lower_ci <- amr$beta - 1.96 * amr$SE
amr$upper_ci <- amr$beta + 1.96 * amr$SE
head(amr)

eur$lower_ci <- eur$beta - 1.96 * eur$SE
eur$upper_ci <- eur$beta + 1.96 * eur$SE
head(eur)

meta$lower_ci <- meta$beta - 1.96 * meta$SE
meta$upper_ci <- meta$beta + 1.96 * meta$SE
head(meta)

# Assuming 'afr' is your data frame containing the summary statistics
# Set genome-wide significance threshold
significance_threshold <- 5e-8

# Filter SNPs that are significant
snps_amr <- amr[amr$P < significance_threshold, ]

# View the significant SNPs
head(snps_amr)

result_afr <- afr %>% filter(SNP == "rs77818427") %>%
  mutate(ancestry = "AFR", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_amr <- amr %>% filter(SNP == "rs77818427") %>%
  mutate(ancestry = "AMR", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_eur <- eur %>% filter(SNP == "rs77818427") %>%
  mutate(ancestry = "EUR", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- meta %>% filter(SNP == "rs77818427") %>%
  mutate(ancestry = "META", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- result_meta %>%
  rename(P = `p-value`)

# Combine the results into one data frame
df <- bind_rows(result_meta,result_afr, result_amr, result_eur)

# Print the combined result to verify
print(df)

df$ancestry <- factor(df$ancestry, levels = c( "META","AFR", "AMR", "EUR"))

ggplot(df, aes(x = effect_size, y = ancestry)) +
  geom_point(size = 3) +  # Point for effect size
  geom_errorbarh(aes(xmin = lower_ci, xmax = upper_ci), height = 0.2) +  # Horizontal error bars
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +  # Line at effect size = 0
  theme_minimal() +
  labs(x = "Effect Size", y = "Ancestry", title = "Effect Sizes Across Ancestries of rs77818427") +
  theme(
    axis.text.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    plot.title = element_text(face = "bold")
  )

###afr
# Filter SNPs that are significant
snps_afr <- afr[afr$P < significance_threshold, ]

# View the significant SNPs
head(snps_afr)

result_afr <- afr %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "AFR", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_amr <- amr %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "AMR", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_eur <- eur %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "EUR", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- meta %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "META", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- result_meta %>%
  rename( P = `P-value`)

# Combine the results into one data frame
df <- bind_rows(result_meta,result_afr, result_amr, result_eur)

# Print the combined result to verify
print(df)

df$ancestry <- factor(df$ancestry, levels = c( "META","AFR", "AMR", "EUR"))

ggplot(df, aes(x = effect_size, y = ancestry)) +
  geom_point(size = 3) +  # Point for effect size
  geom_errorbarh(aes(xmin = lower_ci, xmax = upper_ci), height = 0.2) +  # Horizontal error bars
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +  # Line at effect size = 0
  theme_minimal() +
  labs(x = "Effect Size", y = "Ancestry", title = "Effect Sizes Across Ancestries of rs117965482") +
  theme(
    axis.text.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    plot.title = element_text(face = "bold")
  )

