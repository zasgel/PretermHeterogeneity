library(ggplot2)
library(gridExtra)
# Define the main directory where data files are stored
main_dir <- "~/Downloads/BridgePRS-main_newest"  # Adjust this path if necessary
all_dirs <- list.dirs(path = main_dir, full.names = TRUE)

#### single
afr_folders <- all_dirs[grepl("^.*/AFR_.*_single$", all_dirs)]
amr_folders <- all_dirs[grepl("^.*/AMR_.*_single$", all_dirs)]

cases <- read.table("premature_cases.txt")
colnames(cases)[1] <- "FID"
colnames(cases)[2] <- "IID"

# Initialize lists for AFR and AMR phenotype datasets
AFR_files <- c()
AMR_files <- c()

# Function to load data based on folder list
load_prs_data <- function(folders, ancestry_files) {
  for (folder in folders) {
    prs_combined_path <- file.path(folder, "prs-single_EUR/predict")
    
    if (dir.exists(prs_combined_path)) {
      file_path <- file.path(prs_combined_path, "EUR_predict_best_pred_valid.dat")
      
      if (file.exists(file_path)) {
        data <- tryCatch(
          {
            read.table(file_path, header = TRUE, sep = ',')
          },
          error = function(e) {
            message(paste("Error reading file:", file_path, ":", e$message))
            return(NULL)
          }
        )
        
        if (!is.null(data)) {
          phenotype <- sub("^EUR_", "", basename(folder))
          data$phenotype <- ifelse(data$IID %in% cases$IID, 1, 0)
          
          assign(phenotype, data, envir = .GlobalEnv)
          ancestry_files <- c(ancestry_files, phenotype)
          message(paste("Loaded data from:", file_path, "as variable:", phenotype))
        }
      }
    }
  }
  return(ancestry_files)
}

# Load AFR and AMR datasets separately
AFR_files <- load_prs_data(afr_folders, AFR_files)
AMR_files <- load_prs_data(amr_folders, AMR_files)

# Separate PRS values for AFR and AMR
preterm_prs_AFR <- list()
term_prs_AFR <- list()
preterm_prs_AMR <- list()
term_prs_AMR <- list()

for (phenotype in AFR_files) {
  prs <- get(phenotype)
  preterm_prs_AFR[[phenotype]] <- prs$PRS[prs$phenotype == 1]
  term_prs_AFR[[phenotype]] <- prs$PRS[prs$phenotype == 0]
}

for (phenotype in AMR_files) {
  prs <- get(phenotype)
  preterm_prs_AMR[[phenotype]] <- prs$PRS[prs$phenotype == 1]
  term_prs_AMR[[phenotype]] <- prs$PRS[prs$phenotype == 0]
}

# Define descriptive names
new_names_AFR <- c("ADHD", "ASD", "Anorexia Nervosa", "Gastrointestinal Disease",
                   "Immune System Disease", "Musculoskeletal System Disease")

new_names_AMR <- c("ADHD", "ASD", "Anorexia Nervosa", "Gastrointestinal Disease",
                   "Immune System Disease", "Musculoskeletal System Disease")

# Function to create violin plots
create_violin_plots <- function(preterm_prs, term_prs, new_names) {
  plots <- list()
  for (i in seq_along(preterm_prs)) {
    phenotype <- names(preterm_prs)[i]
    df <- data.frame(
      Phenotype = factor(c(rep("Pre-term", length(preterm_prs[[i]])), rep("Term", length(term_prs[[i]])))),
      PRS = c(preterm_prs[[i]], term_prs[[i]])
    )
    
    p <- ggplot(df, aes(x = Phenotype, y = PRS, fill = Phenotype)) +
      geom_violin(trim = FALSE) +
      geom_boxplot(width = 0.1, fill = "white", outlier.size = 0.5) +
      labs(title = paste("PRS Distribution for", new_names[i])) +
      xlab("Group") + ylab("Weighted PRS Values") +
      scale_fill_manual(values = c("Pre-term" = "lightblue", "Term" = "orange")) +
      theme_minimal() +
      theme(plot.title = element_text(size = 12))
    
    plots[[i]] <- p
  }
  return(plots)
}

# Generate plots for AFR and AMR separately
plots_AFR <- create_violin_plots(preterm_prs_AFR, term_prs_AFR, new_names_AFR)
plots_AMR <- create_violin_plots(preterm_prs_AMR, term_prs_AMR, new_names_AMR)

##AMR###
folders <- all_dirs[grepl("^AMR_", basename(all_dirs))]

# Initialize empty lists for each phenotype dataset
AMR_files <- c()  

# Load datasets into individual variables
for (folder in folders) {
  prs_combined_path <- file.path(folder, "prs-combined_AMR-EUR")
  
  # Check if the prs-combined_AMR folder exists
  if (dir.exists(prs_combined_path)) {
    file_path <- file.path(prs_combined_path, "AMR_weighted_combined_preds.dat")
    
    # Check if the file exists
    if (file.exists(file_path)) {
      data <- tryCatch(
        {
          read.table(file_path, header = TRUE)
        },
        error = function(e) {
          message(paste("Error reading file:", file_path, ":", e$message))
          return(NULL)
        }
      )
      
      if (!is.null(data)) {
        # Extract phenotype name by removing the "AMR_" prefix
        phenotype <- sub("^AMR_", "", basename(folder))
        
        # Assign data to a separate variable with the phenotype name
        assign(phenotype, data)
        AMR_files <- c(AMR_files, phenotype)  # Keep track of the phenotype names
        message(paste("Loaded data from:", file_path, "as variable:", phenotype))
      }
    } else {
      message(paste("File not found:", file_path))
    }
  } else {
    message(paste("Folder not found:", prs_combined_path))
  }
}

# Initialize lists to store PRS values for Pre-term and Term
preterm_prs <- list()
term_prs <- list()

# Loop through each loaded dataset and extract PRS values for Pre-term and Term
for (phenotype in AMR_files) {
  prs <- get(phenotype)  # Retrieve the dataset by its variable name
  
  # Separate Weighted values for Pre-term (pheno == 1) and Term (pheno == 0)
  preterm_prs[[phenotype]] <- prs$Weighted[prs$pheno == 1]
  term_prs[[phenotype]] <- prs$Weighted[prs$pheno == 0]
}

# Define descriptive names for the phenotypes
new_names <- AMR_files  # Keeping the phenotype names as is for now
new_names <- c("Anxiety Disorder","Bipolar Disorder","Epilepsy",
                "Preterm Birth","Schizophrenia")

# Create violin plots comparing PRS for Pre-term and Term for each phenotype
plots <- list()
for (i in seq_along(preterm_prs)) {
  phenotype <- names(preterm_prs)[i]
  
  # Combine PRS values into a data frame
  df <- data.frame(
    Phenotype = factor(c(rep("Pre-term", length(preterm_prs[[i]])), rep("Term", length(term_prs[[i]])))),
    PRS = c(preterm_prs[[i]], term_prs[[i]])
  )
  
  # Create violin plot
  p <- ggplot(df, aes(x = Phenotype, y = PRS, fill = Phenotype)) +
    geom_violin(trim = FALSE) +
    geom_boxplot(width = 0.1, fill = "white", outlier.size = 0.5) +  # Add boxplot for better representation
    labs(title = paste("PRS Distribution for", new_names[i])) +  # Use new names here
    xlab("Group") + ylab("Weighted PRS Values") +
    scale_fill_manual(values = c("Pre-term" = "lightblue", "Term" = "orange")) +
    theme_minimal() +
    theme(plot.title = element_text(size = 12))
  
  plots[[i]] <- p
}



# Combine previous plots with new plots
combined_plots_AMR <- c(plots, plots_AMR)

# Arrange and print all combined plots
grid.arrange(grobs = combined_plots_AMR, ncol = 3)



##AFR###
folders <- all_dirs[grepl("^AFR_", basename(all_dirs))]


# Initialize empty lists for each phenotype dataset
AFR_files <- c()

# Load datasets into individual variables
for (folder in folders) {
  prs_combined_path <- file.path(folder, "prs-combined_AFR-EUR")
  
  # Check if the prs-combined_AFR folder exists
  if (dir.exists(prs_combined_path)) {
    file_path <- file.path(prs_combined_path, "AFR_weighted_combined_preds.dat")
    
    # Check if the file exists
    if (file.exists(file_path)) {
      data <- tryCatch(
        {
          read.table(file_path, header = TRUE)
        },
        error = function(e) {
          message(paste("Error reading file:", file_path, ":", e$message))
          return(NULL)
        }
      )
      
      if (!is.null(data)) {
        # Extract phenotype name by removing the "AFR_" prefix
        phenotype <- sub("^AFR_", "", basename(folder))
        
        # Assign data to a separate variable with the phenotype name
        assign(phenotype, data)
        AFR_files <- c(AFR_files, phenotype)  # Keep track of the phenotype names
        message(paste("Loaded data from:", file_path, "as variable:", phenotype))
      }
    } else {
      message(paste("File not found:", file_path))
    }
  } else {
    message(paste("Folder not found:", prs_combined_path))
  }
}

# Initialize lists to store PRS values for Pre-term and Term
preterm_prs <- list()
term_prs <- list()

# Loop through each loaded dataset and extract PRS values for Pre-term and Term
for (phenotype in AFR_files) {
  prs <- get(phenotype)  # Retrieve the dataset by its variable name
  
  # Separate Weighted values for Pre-term (pheno == 1) and Term (pheno == 0)
  preterm_prs[[phenotype]] <- prs$Weighted[prs$pheno == 1]
  term_prs[[phenotype]] <- prs$Weighted[prs$pheno == 0]
}

# Define descriptive names for the phenotypes
new_names <- AFR_files  # Keeping the phenotype names as is for now
new_names <- c("ADHD","Anxiety Disorder","ASD","Bipolar Disorder","Anorexia Nervosa",
               "Epilepsy", "Preterm Birth","Schizophrenia")

# Create violin plots comparing PRS for Pre-term and Term for each phenotype
plots <- list()
for (i in seq_along(preterm_prs)) {
  phenotype <- names(preterm_prs)[i]
  
  # Combine PRS values into a data frame
  df <- data.frame(
    Phenotype = factor(c(rep("Pre-term", length(preterm_prs[[i]])), rep("Term", length(term_prs[[i]])))),
    PRS = c(preterm_prs[[i]], term_prs[[i]])
  )
  
  # Create violin plot
  p <- ggplot(df, aes(x = Phenotype, y = PRS, fill = Phenotype)) +
    geom_violin(trim = FALSE) +
    geom_boxplot(width = 0.1, fill = "white", outlier.size = 0.5) +  # Add boxplot for better representation
    labs(title = paste("PRS Distribution for", new_names[i])) +  # Use new names here
    xlab("Group") + ylab("Weighted PRS Values") +
    scale_fill_manual(values = c("Pre-term" = "lightblue", "Term" = "orange")) +
    theme_minimal() +
    theme(plot.title = element_text(size = 12))
  
  plots[[i]] <- p
}



combined_plots <- c(plots, plots_AFR)
grid.arrange(grobs = combined_plots, ncol = 3)

