source("cleaning_functions.R")

# Hours Asleep
sleep_data_path <- "path/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv"
sleep_data <- clean_data(sleep_data_path)

# Filter out outliers and multiple counts of sleep records per day
sleep_data <- filter(sleep_data, TotalSleepRecords < 2 & TotalMinutesAsleep < 720)

# Create a new column for hours asleep
sleep_data <- sleep_data %>%
  mutate(TotalHoursAsleep = TotalMinutesAsleep / 60)

# Calculate average of minutes asleep
mean_minutes_asleep <- mean(sleep_data$TotalMinutesAsleep)
# 411.3978

# Convert average from minutes to hours
mean_hours_asleep <- mean_minutes_asleep / 60
# 6.85663

# Histogram with the average sleep time distribution per user
ggplot(sleep_data, aes(x = TotalHoursAsleep)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Total Hours Asleep",
       x = "Total Hours Asleep", y = "Frequency") +
  geom_vline(aes(xintercept = mean_hours_asleep), color = "purple", linetype = "solid", linewidth = 0.7) +
  annotate("text", x = min(sleep_data$TotalHoursAsleep), y = Inf, 
           label = paste("Average:", round(mean_hours_asleep, 1), "hours"),
           vjust = 3, hjust = -0.3, color = "purple") 


# Total time in bed and total minutes asleep correlation with scatter plot
ggplot(sleep_data, aes(x = TotalTimeInBed, y = TotalMinutesAsleep)) +
  geom_point(color = "blue") +  # Scatter plot points
  geom_smooth(method = "lm", color = "red") +  # Regression line
  labs(title = "Time in Bed and Minutes Asleep Correlation",
       x = "Time in Bed (minutes)", y = "Minutes Asleep (minutes)")

# Add a column for time in bed spent not sleeping 
sleep_data <- sleep_data %>%
  mutate(AdditionalTimeInBed = TotalTimeInBed - TotalMinutesAsleep)

# Calculate the average additional time spent in bed compared to sleep time
average_additional_time_in_bed <- mean(sleep_data$AdditionalTimeInBed)
# 37.5 minutes 

# Density plot with % of users spending certain time in bed not sleeping 
ggplot(sleep_data, aes(x = AdditionalTimeInBed)) +
  geom_density(aes(y = after_stat(density) * 100), fill = "skyblue", color = "black") +
  geom_vline(xintercept = mean_additional_time_in_bed, color = "coral3", linetype = "dashed") +
  annotate("text", x = mean_additional_time_in_bed, y = 1, 
           label = paste("Mean -", round(mean_additional_time_in_bed, 1)), 
           color = "coral4", vjust = 0, hjust = -0.2) +  labs(title = "Frequency of Additional Time in Bed",
       x = "Additional Time in Bed (minutes)", 
       y = "Percentage of Observations") 



# Steps and sleep time correlation 

# Get daily steps data
steps_data_path <- "path/archive/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailySteps_merged.csv"
daily_steps <- clean_data(steps_data_path)

merged_data <- inner_join(sleep_data, daily_steps, by = c("Id", "SleepDay" = "ActivityDay"))

# Scatter plot to visualize the relationship between StepsTotal and TotalMinutesAsleep
ggplot(merged_data, aes(x = StepTotal, y = TotalHoursAsleep)) +
  geom_point(color = "blue") +
  labs(title = "Steps vs. Hours Asleep",
       x = "Steps Count",
       y = "Hours Asleep") +
  geom_smooth(method = "lm", se = FALSE, color = "coral1") 

# Calculate the correlation coefficient
correlation <- cor(merged_data$StepTotal, merged_data$TotalMinutesAsleep)
# -0.1250959 


# Find trends in sleep data over time 

# Classify days as Weekday or Weekend and calculate average sleep duration for Weekdays and Weekends
sleep_summary <- sleep_data %>%
  mutate(DayOfWeek = weekdays(SleepDay),
         WeekdayOrWeekend = ifelse(DayOfWeek %in% c("Saturday", "Sunday"), "Weekend", "Weekday")) %>%
  group_by(WeekdayOrWeekend) %>%
  summarize(AverageMinutesAsleep = mean(TotalMinutesAsleep, na.rm = TRUE)) %>%
  mutate(AverageHoursAsleep = AverageMinutesAsleep / 60)

# Create the plot
ggplot(sleep_summary, aes(x = WeekdayOrWeekend, y = AverageMinutesAsleep, fill = WeekdayOrWeekend)) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_text(aes(label = paste0(round(AverageMinutesAsleep), " min\n", round(AverageHoursAsleep, 2), " hrs")),
            position = position_stack(vjust = 0.5), size = 5, color = "black") +
  labs(title = "Avg Time Asleep: Weekdays vs Weekends",
      y = "Average Minutes Asleep") +
  scale_fill_manual(values = c("Weekday" = "skyblue", "Weekend" = "orange")) +
  theme(legend.position = "none", axis.title.x = element_blank()) # Hide the legend and x axis name as it's redundant with the labels
