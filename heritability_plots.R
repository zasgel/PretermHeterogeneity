library(data.table)
library(ggplot2)
library(cowplot)

# Function to prepare the dataset
prepare_data <- function(file, phenotype_filter = "Preterm Birth (SPARK)", model_filter = c("h1^2", "h2^2")) {
  data <- as.data.frame(fread(file))
  data$CI_lower <- data$Val_obs - 1.96 * data$SE
  data$CI_upper <- data$Val_obs + 1.96 * data$SE
  data$significance <- data$`P(Z)` < 0.05
  subset(data, Phenotype %in% phenotype_filter & Model %in% model_filter)
}

# Function to create the heritability plot
create_plot <- function(data, title) {
  ggplot(data, aes(x = Val_obs, y = Phenotype, color = significance)) +
    geom_point(size = 3) +
    geom_errorbarh(aes(xmin = CI_lower, xmax = CI_upper), height = 0.2) +
    scale_color_manual(values = c("TRUE" = "red", "FALSE" = "blue")) +
    labs(
      title = title,
      x = "Estimate Value",
      y = "Trait",
      color = "Significance"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5)
    )
}

# Prepare data
amr_data <- prepare_data("merged_AMR.txt")
afr_data <- prepare_data("merged_AFR.txt")
meta_data <- prepare_data("merged_META.txt")

# Create plots
amr_plot <- create_plot(amr_data, "Heritability Estimates with Confidence Intervals for AMR")
afr_plot <- create_plot(afr_data, "Heritability Estimates with Confidence Intervals for AFR")
meta_plot <- create_plot(meta_data, "Heritability Estimates with Confidence Intervals for META")

# Combine and display
combined_plot <- plot_grid(amr_plot, afr_plot, meta_plot, ncol = 1)
print(combined_plot)
