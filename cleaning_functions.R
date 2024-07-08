# Contains functions to clean and transform datasets
# Ensures filtering duplicates, N/A values and proper data formatting

# Load necessary packages
library(tidyverse)
library(lubridate)

# Transform date format based on file name
transform_date_format <- function(data, file_path) {
  if (grepl("Daily", file_path, ignore.case = TRUE)) {
    data <- data %>%
      mutate(across(where(is.character), ~ mdy(.x)))
  } else {
    data <- data %>%
      mutate(across(where(is.character), ~ mdy_hms(.x)))
  }
  return(data)
}

# Clean data
clean_data <- function(file_path) {
  data <- read_csv(file_path)
  data <- na.omit(data)
  data <- data[!duplicated(data), ]
  data <- transform_date_format(data, file_path)
  return(data)
}