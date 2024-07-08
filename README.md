# Bellabeat Case Study

## Overview

This project is a case study of the dataset provided by a high-tech manufacturer of health-focused products, Bellabeat. The objective is to analyze smart device data to gain insights into how consumers are using their smart devices. This analysis aims to find trends and patterns in the data, which consists of a collection of CSV files for approximately 30 women over two months.

## Data Source

The dataset used for this project is sourced from Kaggle. You can find the dataset at the following link:
[Kaggle Dataset](https://www.kaggle.com/datasets/arashnic/fitbit/data)

## Structure

The project consists of the following files:

1. Data Source. The raw data files sourced from Kaggle.

2. `exploration.R` containing initial exploration and understanding of the data. It includes basic statistics to get an overview of the dataset.

3. `cleaning_functions.R` containing functions to clean and preprocess the data, including handling missing values, correcting data formats, and merging datasets.

4. `inital_analysis.R` script that performs general exploration and analysis of the dataset, focusing on overall trends and patterns.

5. `sleep_analysis.R` script that delves into the sleep data, analyzing sleep patterns, duration, and correlations with other variables.

6. `activity_analysis.R` script that analyzes the activity data, including steps, distance, and active minutes, and their correlations with other metrics.

7. `trends_and_patterns_foundings.md` Markdown file that provides a comprehensive summary of the analysis, including key findings, visualizations, and conclusions.

## Key Takeaways

The analysis revealed several significant insights:

1. **Average Daily Steps**: The average daily steps among users are 7346, which is below the CDC recommendation of 10,000 steps per day.
2. **Average Calories Burned**: The majority of users burn around 1751-2000 calories per day, with a notable proportion burning over 3000 calories, suggesting intense physical activity.
3. **Sleep Patterns**: The average time asleep is 6.9 hours, slightly below the recommended range of 7-9 hours.
4. **Sleep and Steps Correlation**: There is a very weak negative correlation between steps and sleep duration.
5. **Activity Intensities**: Users spend a significant portion of their active time in light activity, with a smaller proportion in very active and fairly active minutes.
6. **Sedentary Hours**: Users have the most sedentary activity on Thursday, Monday, and Friday.
7. **Activity and Calories Correlation**: There is a strong positive correlation between total steps and calories burned.

## Usage

To run the analysis, ensure you have R and RStudio installed. Load the necessary libraries and run the scripts in the following order:

1. Load and explore the data using `exploration.R`.
2. Clean and preprocess the data using `cleaning_functions.R`.
3. Perform general exploration using `inital_analysis.R`.
4. Analyze sleep data using `sleep_analysis.R`.
5. Analyze activity data using `activity_analysis.R`.
6. View the analysis summary using `trends_and_patterns_foundings.md`.

## Conclusion

The Bellabeat Case Study provides valuable insights into user behaviors and trends. These findings can help Bellabeat tailor its products and marketing strategies to better meet user needs and promote healthier lifestyles.


