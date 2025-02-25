library(data.table)  

# Define a reusable function for QQ plot and lambda GC calculation
process_qq_plot <- function(file_path, main_title) {
  # Load data
  data <- fread(file_path)
  
  # Extract p-values and remove NAs
  p_values <- na.omit(data$`p-value`)
  
  # Check if there are enough p-values to create a QQ plot
  if (length(p_values) < 10) {
    cat("Not enough p-values in", file_path, "to generate a QQ plot.\n")
    return(NULL)
  }
  
  # Calculate observed and expected -log10(p-values)
  obs <- -log10(sort(p_values))
  n <- length(p_values)
  exp <- -log10((1:n) / (n + 1))
  
  # Calculate lambda GC
  chisq <- qchisq(1 - p_values, df = 1)
  lambda_gc <- median(chisq) / qchisq(0.5, df = 1)
  
  # Plot the QQ plot
  plot(exp, obs, pch = 19, cex = 0.6, col = "blue",
       xlab = "Expected -log10(p)", ylab = "Observed -log10(p)",
       main = main_title)
  abline(0, 1, col = "red")  # Add y=x line for reference
  
  # Add lambda GC value on the plot
  mtext(paste("Lambda GC:", round(lambda_gc, 3)), side = 3, line = -1, adj = 0.95, 
        col = "black", font = 2, cex = 0.8)  # Reduced text size
  
  cat("Lambda GC for", main_title, ":", lambda_gc, "\n")
  
  return(lambda_gc)
}

# File paths and titles for the QQ plots
file_info <- list(
  list(file = "filtered/afr_final_new.txt", title = "QQ Plot: AFR"),
  list(file = "filtered/afr_final_new_beta.txt", title = "QQ Plot: AFR Filtered"),
  list(file = "filtered/amr_final_new.txt", title = "QQ Plot: AMR"),
  list(file = "filtered/amr_final_new_beta.txt", title = "QQ Plot: AMR Filtered"),
  list(file = "filtered/eur_final_new.txt", title = "QQ Plot: EUR"),
  list(file = "filtered/eur_final_new_beta.txt", title = "QQ Plot: EUR Filtered")
)


# Loop through each file and generate QQ plots
png("qq_plots.png", width = 1200, height = 1800, res = 150)
par(mfrow = c(3, 2))
lambda_gc_results <- list()  # Store lambda GC results
for (info in file_info) {
  cat("\nProcessing:", info$file, "\n")
  lambda_gc <- process_qq_plot(info$file, info$title)
  lambda_gc_results[[info$title]] <- lambda_gc
}

dev.off()
