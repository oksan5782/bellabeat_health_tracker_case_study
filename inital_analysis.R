# Load cleaning_functions.R 
source("cleaning_functions.R")

# Daily Activity Trends
daily_activity_path_1 <- "path/archive/mturkfitbit_export_3.12.16-4.11.16/Fitabase Data 3.12.16-4.11.16/dailyActivity_merged.csv"
daily_activity_path_2 <- "path/archive/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv"
daily_activity_1 <- clean_data(daily_activity_path_1)
daily_activity_2 <- clean_data(daily_activity_path_2)

# Merge data from the first and second month
daily_activity <- rbind(daily_activity_1, daily_activity_2)

# Filter records removing outliers 
daily_activity <- daily_activity %>%
  filter(ActivityDate >= as.Date("2016-03-13") & ActivityDate <= as.Date("2016-05-11"))

# Calculate average TotalSteps per day
daily_activity_avg <- daily_activity %>%
  group_by(ActivityDate) %>%
  summarise(avg_TotalSteps = mean(TotalSteps, na.rm = TRUE))

# Get average TotalSteps 
average_steps <- round(mean(daily_activity$TotalSteps, na.rm = TRUE))  
# 7346

# Find min and max of avg_TotalSteps
min_avg <- round(min(daily_activity_avg$avg_TotalSteps))
# 658

max_avg <- round(max(daily_activity_avg$avg_TotalSteps))
# 8731

# Plot the average TotalDistance per day as a bar chart
ggplot(daily_activity_avg, aes(x = ActivityDate, y = avg_TotalSteps)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Average Daily Steps", x = "Date", y = "Average Total Steps") +
  scale_x_date(date_labels = "%d/%m", breaks = scales::date_breaks("4 day")) +
  geom_hline(yintercept = average_steps, color = "coral", linetype = "solid") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 



# Burned Calories
daily_calories_path <- "path/archive/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/dailyCalories_merged.csv"
daily_calories <- clean_data(daily_calories_path)

average_calories <- daily_calories %>%
  group_by(Id) %>%
  summarize(avg_calories = mean(Calories, na.rm = TRUE))

custom_breaks <- c(-Inf, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3250, Inf)

# Adjust labels to match the number of breaks minus one
labels = c("<1500", "1500-1750", "1751-2000", "2001-2250", "2251-2500", "2501-2750", "2751-3000", "3001-3250", "3251+")

# Bin the average calories into custom categories
average_calories <- average_calories %>%
  mutate(calories_bin = cut(avg_calories, breaks = custom_breaks, include.lowest = TRUE, right=TRUE))

# Plot histogram of average calories per user with custom bins
ggplot(average_calories, aes(x = calories_bin)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Average Burned Calories",
       x = "Average Calories Burned per Day", y = "Number of Users") +
  scale_x_discrete(labels = labels) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate labels by 45 degrees and align to the right
