# Load necessary libraries
library(data.table)
library(dplyr)
library(stringr)

# Define the base directory
base_directory <- "~/Downloads/BridgePRS-main_newest"

# List all folders in the base directory
folders <- list.dirs(base_directory, full.names = TRUE, recursive = FALSE)

filtered_folders <- folders[grep("_single$", basename(folders))]

# Initialize an empty list to store data frames
all_data <- list()

# Loop through each filtered folder
for (folder in filtered_folders) {
  # Define the specific file path for EUR data
  prs_single_dir <- file.path(folder, "prs-single_EUR/quantify/EUR_quantify_var_explained.txt")
  
  # Check if the file exists
  if (file.exists(prs_single_dir)) {
    # Print the file being processed
    cat("Processing file:", prs_single_dir, "\n")
    
    # Read the file into a data frame
    res <- as.data.frame(fread(prs_single_dir))
    
    # Check if the data frame is empty
    if (nrow(res) == 0) {
      cat("File is empty or not read properly:", prs_single_dir, "\n")
      next
    }
    
    # Extract the folder name from the file path
    folder_name <- basename(folder)
    
    # Add the folder name as the first column
    res_with_folder <- cbind(Phenotype = folder_name, res)
    
    # Append the data frame to the list
    all_data[[prs_single_dir]] <- res_with_folder
  } else {
    cat("File not found:", prs_single_dir, "\n")
  }
}

# Merge all data frames in the list
merged_data <- bind_rows(all_data)
merged_data <- merged_data %>% select(-V1)

head(merged_data)

merged_data <- merged_data %>%
  mutate(
    Ancestry = str_extract(Phenotype, "AFR|AMR"),  # Extract AFR or AMR
    Phenotype = str_remove(Phenotype, "_single"),  # Remove "_single"
    Phenotype = str_remove(Phenotype, "^(AFR|AMR)_")  # Remove "AFR_" or "AMR_" from the start
  )

# Add Significant column
merged_data <- merged_data %>%
  mutate(Significant = !(`2.5` <= 0 & `97.5` >= 0))

merged_data$Phenotype <- gsub("\\bED\\b", "Anorexia Nervosa", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bGI\\b", "Gastrointestinal Disease", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bIM\\b", "Immune System Disease", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bMS\\b", "Musculoskeletal System Disease", merged_data$Phenotype)

# Display the first few rows to check the new column
head(merged_data)

# Write the merged data frame to a new file
write.csv(merged_data, "~/Downloads/bridgeprs_single_results.txt", row.names = FALSE)


