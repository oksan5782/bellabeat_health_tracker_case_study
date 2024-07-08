# This script processes CSV files from specified folders, 
# performs statistical summarization, 
# and writes the summaries to output text files. 

# Install and load packages
install.packages("tidyverse")
library(readr)
library(dplyr)
library(skimr)

# Summarize CSV files in a folder and write to a text file
summarize_csv_files <- function(folder_path, output_file) {
  
  # Check if the output directory exists, if not stop the process
  output_dir <- dirname(output_file)
  if (!dir.exists(output_dir)) {
    stop("The directory for the output file does not exist.")
  }
  
  # Get a list of CSV files in the directory
  csv_files <- list.files(folder_path, pattern = "\\.csv$", full.names = TRUE)
  
  # Open connection to the output text file in 'append' mode
  write_file <- file(output_file, "a")
  
  # Iterate over each CSV file
  for (file_name in csv_files) {
    
    # Read the CSV file into a data frame
    data <- read_csv(file_name)
    
    # Perform statistical observations
    col_names <- colnames(data)
    data_summary <- capture.output(summary(data))
    data_glimpse <- capture.output(print(glimpse(data)))
    data_skim <- capture.output(print(skim(data)))
    na_counts <- colSums(is.na(data))
    duplicate_counts <- sum(duplicated(data))
    id_count <- length(unique(data$Id))
    
    # Prepare results to write to output text file
    result <- paste("File Name:", file_name, "\n",
                    "Column Names:", paste(col_names, collapse = ", "), "\n\n",
                    "Summary:\n", paste(data_summary, collapse = "\n"), "\n\n",
                    "Glimpse:\n", paste(data_glimpse, collapse = "\n"), "\n\n",
                    "Skim:\n", paste(data_skim, collapse = "\n"), "\n\n",
                    "NA Counts:", paste(na_counts, collapse = ", "), "\n\n",
                    "Duplicated Rows:", duplicate_counts, "\n\n",
                    "Id Count:", id_count, "\n\n\n")
    
    # Write results to the output file
    writeLines(result, write_file)
  }
  
  # Close the connection to the output file
  close(write_file)
}

# Call the function for two different folder paths
folder_path_1 <- "path/to/the/first/folder"
output_file_1 <- "path/to/the/output/folder/data_sources_summary_1.txt"
summarize_csv_files(folder_path_1, output_file_1)

folder_path_2 <- "path/to/the/second/folder"
output_file_2 <- "path/to/the/output/folder/data_sources_summary_2.txt"
summarize_csv_files(folder_path_2, output_file_2)
