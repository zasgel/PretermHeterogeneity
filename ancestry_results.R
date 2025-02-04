# Load necessary libraries
library(data.table)
library(dplyr)
library(gridExtra)

# Define the base directory
base_directory <- "~/Downloads/BridgePRS-main_newest"

# List all folders in the base directory
folders <- list.dirs(base_directory, full.names = TRUE, recursive = FALSE)

# Filter folders to include only those starting with 'AMR_' or 'AFR_'
filtered_folders <- folders[grep("^AMR_|^AFR_", basename(folders))]

# Initialize an empty list to store data frames
all_data <- list()

# Loop through each filtered folder
for (folder in filtered_folders) {
  # Check both variations '_AFR' and '_AMR'
  prs_combined_dirs <- c(
    file.path(folder, "prs-combined_AFR-EUR"),
    file.path(folder, "prs-combined_AMR-EUR")
  )
  
  # Initialize a flag to check if any files are found
  files_found <- FALSE
  
  # Loop through each possible prs-combined directory
  for (prs_combined_dir in prs_combined_dirs) {
    # List all files in the prs-combined directory
    files <- list.files(prs_combined_dir, pattern = "weighted_combined_var_explained.txt$", full.names = TRUE)
    
    # Check if any files were found
    if (length(files) > 0) {
      files_found <- TRUE
      
      # Loop through each file
      for (file in files) {
        # Extract the folder name from the file path
        folder_name <- basename(folder)
        
        # Print the file being processed
        cat("Processing file:", file, "\n")
        
        # Read the file into a data frame
        res <- as.data.frame(fread(file))
        
        # Check if the data frame is empty
        if (nrow(res) == 0) {
          cat("File is empty or not read properly:", file, "\n")
          next
        }
        
        # Add the folder name as the first column
        res_with_folder <- cbind(Phenotype = folder_name, res)
        
        # Append the data frame to the list
        all_data[[file]] <- res_with_folder
      }
    }
  }
  
  if (!files_found) {
    cat("No files found in either 'prs-combined_AFR' or 'prs-combined_AMR' directories for folder:", folder, "\n")
  }
}



merged_data <- bind_rows(all_data)
names(merged_data)[names(merged_data) == "---"] <- "Model"


# Assuming merged_data is your data frame
merged_data <- merged_data %>%
  mutate(Significant = if_else(Prob < 0.05, TRUE, FALSE))

names(merged_data) <- gsub(" ", "_", names(merged_data))
names(merged_data) <- gsub("%", "", names(merged_data))

merged_data$Ancestry <- NA

# Update 'Ancestry' based on 'Phenotype' column values
merged_data$Ancestry <- ifelse(grepl("^AFR_", merged_data$Phenotype), "AFR",
                               ifelse(grepl("^AMR_", merged_data$Phenotype), "AMR", NA))
merged_data$Phenotype <- gsub("^AFR_|^AMR_", "", merged_data$Phenotype)


merged_data$Phenotype <- gsub("\\bANX\\b", "Anxiety Disorder", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bEP\\b", "Epilepsy", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bBIP\\b", "Bipolar Disorder", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bSCZ\\b", "Schizophrenia", merged_data$Phenotype)
merged_data$Phenotype <- gsub("\\bPT\\b", "Preterm Birth (external)", merged_data$Phenotype)

# Display the first few rows to check the new column
head(merged_data,20)



# Write the merged data frame to a new file
write.csv(merged_data, "~/Downloads/bridgeprs_ancestry_results.txt", row.names = FALSE)

