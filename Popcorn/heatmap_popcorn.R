# Required libraries
library(data.table)
library(reshape2)
library(ggplot2)
library(tidyr)

# Load LDSC Data
rg <- fread("combined_rg_summary.txt")
rg$significance <- rg$p < 0.05
rg$rg[is.na(rg$rg)] <- 0

# Prepare LDSC Heatmap Data
heatmap_matrix_ldsc <- acast(rg, Phenotype1 ~ Phenotype2, value.var = "rg")
heatmap_data_ldsc <- as.data.frame(heatmap_matrix_ldsc)
heatmap_data_ldsc$Trait <- rownames(heatmap_data_ldsc)
heatmap_data_long_ldsc <- gather(heatmap_data_ldsc, key = "Preterm_Group", value = "Genetic Correlation", -Trait)


# Load and Process Popcorn Data
AMR <- fread("merged_AMR.txt")
AMR$significance <- AMR$`P(Z)` < 0.05
pge_subset <- AMR[AMR$Model == "pge", ]
pge_subset$Phenotype2 <- "AMR"

meta <- fread("merged_META.txt")
meta$significance <- meta$`P(Z)` < 0.05
meta_subset <- meta[meta$Model == "pge", ]
meta_subset$Phenotype2 <- "Meta"

AFR <- fread("merged_AFR.txt")
AFR$significance <- AFR$`P(Z)` < 0.05
pge_subset_AFR <- AFR[AFR$Model == "pge", ]
pge_subset_AFR$Phenotype2 <- "AFR"

# Combine Subsets
pge_subset_selected <- pge_subset[, .(Phenotype, Phenotype2, Val_obs, significance)]
meta_subset_selected <- meta_subset[, .(Phenotype, Phenotype2, Val_obs, significance)]
pge_subset_selected_afr <- pge_subset_AFR[, .(Phenotype, Phenotype2, Val_obs, significance)]
merged_data <- rbind(pge_subset_selected, meta_subset_selected, pge_subset_selected_afr)

heatmap_data_long_ldsc$Analysis <- "LDSC"
heatmap_matrix <- acast(merged_data, Phenotype ~ Phenotype2, value.var = "Val_obs")
heatmap_data <- as.data.frame(heatmap_matrix)
heatmap_data$Trait <- rownames(heatmap_data)

heatmap_data_long <- tidyr::gather(heatmap_data, key = "Preterm_Group", value = "Genetic Correlation", -Trait)
head( heatmap_data_long)

library(scales)

# Cap extreme values and leave NAs as is
heatmap_data_long$`Genetic Correlation` <- ifelse(
  is.na(heatmap_data_long$`Genetic Correlation`), 
  NA, 
  ifelse(heatmap_data_long$`Genetic Correlation` < -2, -2,
         ifelse(heatmap_data_long$`Genetic Correlation` > 2, 2, heatmap_data_long$`Genetic Correlation`))
)

# Create the heatmap
popcorn_plot <- ggplot(heatmap_data_long, aes(x = Preterm_Group, y = Trait, fill = `Genetic Correlation`)) +
  geom_tile() +
  labs(title = "Popcorn Results Heatmap",
       x = "Preterm SPARK",
       y = "Trait",
       fill = "Genetic Correlation") +
  scale_fill_gradientn(
    colors = c("blue", "white", "red"),
    values = scales::rescale(c(-2, 0, 2)),
    limits = c(-2, 2),
    na.value = "gray"  # Gray for NAs
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 18),
    axis.text = element_text(size = 18),
    plot.title = element_text(size = 20),
    legend.title = element_text(size = 18),
    legend.text = element_text(size = 13)
  )

ldsc_plot <- ggplot(heatmap_data_long_ldsc, aes(x = Preterm_Group, y = Trait, fill = `Genetic Correlation`)) +
  geom_tile() +
  labs(title = "LDSC Analysis Results Heatmap",
       x = "Preterm SPARK",
       y = "Trait",
       fill = "Genetic Correlation") +
  scale_fill_gradientn(colors = colorRampPalette(c("blue", "white", "red"))(100)) +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 18),       # Increase axis title size
    axis.text = element_text(size = 18),        # Increase axis text size
    plot.title = element_text(size = 20),       # Increase plot title size
    legend.title = element_text(size = 18),     # Increase legend title size
    legend.text = element_text(size = 13)       # Increase legend text size
  )

library(gridExtra)
grid.arrange(ldsc_plot, popcorn_plot, ncol = 1)
