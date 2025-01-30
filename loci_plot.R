
library(ggplot2)


afr <- fread('filtered/afr_final_new.txt')
amr <- fread('filtered/amr_final_new.txt')
eur <- fread('filtered/eur_final_new.txt')
meta <- fread('filtered/final_meta.txt')

afr$lower_ci <- afr$LOG - 1.96 * afr$SE
afr$upper_ci <- afr$LOG + 1.96 * afr$SE
head(afr)


amr$lower_ci <- amr$LOG - 1.96 * amr$SE
amr$upper_ci <- amr$LOG + 1.96 * amr$SE
head(amr)

eur$lower_ci <- eur$LOG - 1.96 * eur$SE
eur$upper_ci <- eur$LOG + 1.96 * eur$SE
head(eur)

meta$lower_ci <- meta$beta - 1.96 * meta$SE
meta$upper_ci <- meta$beta + 1.96 * meta$SE
head(meta)

# Assuming 'afr' is your data frame containing the summary statistics
# Set genome-wide significance threshold
significance_threshold <- 5e-8

# Filter SNPs that are significant
snps_amr <- amr[amr$'p-value' < significance_threshold, ]

# View the significant SNPs
head(snps_amr)

###
# Filter SNPs that are significant
snps_eur <- eur[eur$'p-value' < significance_threshold, ]

# View the significant SNPs
head(snps_eur)

# Filter SNPs that are significant
snps_meta <- meta[meta$'p-value' < significance_threshold, ]

# View the significant SNPs
head(snps_meta)

###afr
# Filter SNPs that are significant
snps_afr <- afr[afr$'p-value' < significance_threshold, ]

# View the significant SNPs
head(snps_afr)

result_afr <- afr %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "AFR", effect_size = LOG, lower_ci = lower_ci, upper_ci = upper_ci)

result_amr <- amr %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "AMR", effect_size = LOG, lower_ci = lower_ci, upper_ci = upper_ci)

result_eur <- eur %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "EUR", effect_size = LOG, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- meta %>% filter(SNP == "rs117965482") %>%
  mutate(ancestry = "META", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- result_meta %>%
  rename( P = `p-value`)

# Combine the results into one data frame
df <- bind_rows(result_afr, result_eur)

# Print the combined result to verify
print(df)

df$ancestry <- factor(df$ancestry, levels = c( "AFR", "EUR"))

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

####rs78395263
result_afr <- afr %>% filter(SNP == "rs78395263") %>%
  mutate(ancestry = "AFR", effect_size = LOG, lower_ci = lower_ci, upper_ci = upper_ci)

result_amr <- amr %>% filter(SNP == "rs78395263") %>%
  mutate(ancestry = "AMR", effect_size = LOG, lower_ci = lower_ci, upper_ci = upper_ci)

result_eur <- eur %>% filter(SNP == "rs78395263") %>%
  mutate(ancestry = "EUR", effect_size = LOG, lower_ci = lower_ci, upper_ci = upper_ci)

result_meta <- meta %>% filter(SNP == "rs78395263") %>%
  mutate(ancestry = "META", effect_size = beta, lower_ci = lower_ci, upper_ci = upper_ci)


# Combine the results into one data frame
df2 <- bind_rows(result_afr, result_eur)


df2$ancestry <- factor(df2$ancestry, levels = c( "AFR", "EUR"))

ggplot(df2, aes(x = effect_size, y = ancestry)) +
  geom_point(size = 3) +  # Point for effect size
  geom_errorbarh(aes(xmin = lower_ci, xmax = upper_ci), height = 0.2) +  # Horizontal error bars
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +  # Line at effect size = 0
  theme_minimal() +
  labs(x = "Effect Size", y = "Ancestry", title = "Effect Sizes Across Ancestries of rs78395263") +
  theme(
    axis.text.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    plot.title = element_text(face = "bold")
  )

