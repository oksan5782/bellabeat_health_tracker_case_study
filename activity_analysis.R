source("cleaning_functions.R")

# Activity Analysis 
daily_activity_path_1 <- "path/archive/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv"
daily_activity_path_2 <- "path/archive/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv"
daily_activity_1 <- clean_data(daily_activity_path_1)
daily_activity_2 <- clean_data(daily_activity_path_2)

# Merge two datasets
daily_activity <- rbind(daily_activity_1, daily_activity_2)

# Filter records removing outliers 
daily_activity <- daily_activity %>%
  filter(ActivityDate >= as.Date("2016-04-01") & ActivityDate <= as.Date("2016-05-11"))


# Steps and Distance correlation plot
ggplot(daily_activity, aes(x = TotalSteps, y = TotalDistance)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title ="Steps and Distance Correlation",
       x = "Total Steps",
       y = "Total Distance (km)")

# Find correlation value
correlation <- cor(daily_activity$TotalSteps, daily_activity$TotalDistance, use = "complete.obs")


# Format date 
daily_activity$ActivityDate <- as.POSIXct(daily_activity$ActivityDate, format="%Y-%m-%d")

# Create a column for day of the week 
daily_activity$DayOfWeek <- weekdays(daily_activity$ActivityDate)

# Get average steps by day of the week
weekly_activity <- daily_activity %>%
  group_by(DayOfWeek) %>%
  summarise(AvgSteps = mean(TotalSteps))

# Reorder factor levels
weekly_activity$DayOfWeek <- factor(weekly_activity$DayOfWeek, 
                                    levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Bar plot with average steps by day of the week 
ggplot(weekly_activity, aes(x=DayOfWeek, y=AvgSteps, fill=DayOfWeek)) +
  geom_bar(stat="identity") +
  geom_text(aes(label = round(AvgSteps, 0)), vjust = 3, size = 4) +
  labs(title="Average Steps by Day of the Week", x="Day of the Week", y="Average Steps") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + # Rotate labels by 45 degrees and align to the right
  theme(legend.position = "none", axis.title.x = element_blank()) # Hide the legend as it's redundant with the labels


# Daily Intensities
# Create a column for intensity level 
intensity_data <- daily_activity %>%
  select(Id, ActivityDate, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes) %>%
  gather(key = "IntensityLevel", value = "Minutes", VeryActiveMinutes:LightlyActiveMinutes) %>%
  mutate(IntensityLevel = factor(IntensityLevel, levels = c("LightlyActiveMinutes", "FairlyActiveMinutes", "VeryActiveMinutes"),
                                 labels = c("Lightly Active", "Fairly Active", "Very Active")))

# Bar chart with specified stacking order and labeled fill colors
ggplot(intensity_data, aes(x = ActivityDate, y = Minutes, fill = IntensityLevel, group = IntensityLevel)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = c("Very Active" = "red", "Fairly Active" = "orange", "Lightly Active" = "yellow"),
                    name = "Intensity Level") +  # Rename the legend
  theme_minimal() +
  labs(title = "Daily Intensities Analysis", y = "Minutes") +
  theme(legend.text = element_text(size = 8), axis.title.x = element_blank()) 

# Create a column for total active minutes
daily_activity <- daily_activity %>%
  mutate(TotalActiveMinutes = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes)

# Calculate average percentage distribution
average_distribution_active <- daily_activity %>%
  summarise(
    AvgVeryActive = mean(VeryActiveMinutes / TotalActiveMinutes * 100, na.rm = TRUE),
    AvgFairlyActive = mean(FairlyActiveMinutes / TotalActiveMinutes * 100, na.rm = TRUE),
    AvgLightlyActive = mean(LightlyActiveMinutes / TotalActiveMinutes * 100, na.rm = TRUE)
  )
# Active = 100%
# AvgVeryActive =  8.65%
# AvgFairlyActive = 5.71%
# AvgLightlyActive = 85.6%

# Calculate average percentage distribution considering a 1440-minute day
average_distribution_day <- daily_activity %>%
  summarise(
    AvgVeryActiveDay = mean(VeryActiveMinutes / 1440 * 100, na.rm = TRUE),
    AvgFairlyActiveDay = mean(FairlyActiveMinutes / 1440 * 100, na.rm = TRUE),
    AvgLightlyActiveDay = mean(LightlyActiveMinutes / 1440 * 100, na.rm = TRUE)
  )
# Day = 100%
# AvgVeryActive = 1.43%
# AvgFairlyActive = 0.969%
# AvgLightlyActive = 13.3%


# Identify Inactive Periods
# Convert Sedentary Minutes to hours
inactive_periods <- daily_activity %>%
  mutate(ActivityDate = as.Date(ActivityDate)) %>%  # Ensure ActivityDate is Date class
  group_by(ActivityDate) %>%
  summarise(TotalSedentaryHours = mean(SedentaryMinutes) / 60)  # Convert minutes to hours

# Add day of week label
inactive_periods$DayOfWeek <- weekdays(inactive_periods$ActivityDate)

# Line plot of average sedentary hours 
ggplot(inactive_periods, aes(x = ActivityDate, y = TotalSedentaryHours)) +
  geom_line(color = "blue") +
  labs(title = "Sedentary Hours Over Time", x = "Date", y = "Sedentary Hours") +
  scale_x_date(date_breaks = "3 days", date_labels = "%b %d (%a)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

# Calculate average sedentary hours by day of the week
average_sedentary_hours <- inactive_periods %>%
  group_by(DayOfWeek) %>%
  summarise(AvgSedentaryHours = mean(TotalSedentaryHours)) %>%
  arrange(match(DayOfWeek, c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")))

#DayOfWeek AvgSedentaryHours
#<chr>                 <dbl>
# Monday                 16.9
# Tuesday                16.1
# Wednesday              16.4
# Thursday               17.0
# Friday                 16.9
# Saturday               16.0
# Sunday                 16.4

# Reorder DayOfWeek to plot in the correct order
average_sedentary_hours$DayOfWeek <- factor(average_sedentary_hours$DayOfWeek, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Plotting the line chart with the average sedentary hours by day of the week
ggplot(average_sedentary_hours, aes(x = DayOfWeek, y = AvgSedentaryHours, group = 1)) +
  geom_line(color = "blue") +
  labs(title = "Avg Sedentary Time by Weekday", y = "Avg Sedentary Hours") +
  theme(axis.title.x = element_blank(), 
        axis.text.x = element_text(angle = 45, hjust = 1))


# Activity and Burned Calories correlations
# Calculate averages by ActivityDate
correlations_data <- daily_activity %>%
  group_by(ActivityDate) %>%
  summarise(
    AvgTotalSteps = mean(TotalSteps),
    AvgVeryActiveMinutes = mean(VeryActiveMinutes),
    AvgFairlyActiveMinutes = mean(FairlyActiveMinutes),
    AvgLightlyActiveMinutes = mean(LightlyActiveMinutes),
    AvgCalories = mean(Calories)
  )

# Calculate correlations
correlations <- cor(correlations_data[, c("AvgTotalSteps", "AvgVeryActiveMinutes", 
                                          "AvgFairlyActiveMinutes", "AvgLightlyActiveMinutes", 
                                          "AvgCalories")])

View(correlations)
#                           AvgTotalSteps     AvgVeryActiveMin    AvgFairlyActiveMin   AvgLightlyActiveMin    AvgCalories 
# AvgTotalSteps              1.0000000            0.6553292           0.2648278             0.6969417          0.7282354
# AvgVeryActiveMin           0.6553292            1.0000000           0.1440203             0.1223328          0.4638171
# AvgFairlyActiveMin         0.2648278            0.1440203           1.0000000             0.2033879          0.4729974
# AvgLightlyActiveMin        0.6969417            0.1223328           0.2033879             1.0000000          0.6851063
# AvgCalories                0.7282354            0.4638171           0.4729974             0.6851063          1.0000000


# Plot a correlation between TotalSteps and Calories 
ggplot() +
  geom_point(data = correlations_data, aes(x = AvgTotalSteps, y = AvgCalories)) +
  geom_smooth(data = correlations_data, aes(x = AvgTotalSteps, y = AvgCalories),
              method = "lm", se = FALSE, color = "blue") +  # Add linear regression line
  labs(title = "Steps and Calories Correlation",
       x = "Average Steps per Day",
       y = "Average Calories Burned per Day") +
  annotate("text", x = max(correlations_data$AvgTotalSteps) * 0.95, y = max(correlations_data$AvgCalories) * 0.95,
           label = paste("r: ", round(correlations["AvgTotalSteps", "AvgCalories"], 2)),
           hjust = 5, vjust = 7, color = "coral3", size = 4, fontface = "bold")

# 0.728 - A Strong positive correlation 
