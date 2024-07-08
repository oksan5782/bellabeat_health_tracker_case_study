# Bellabeat Case Study Analysis

## Key Takeaways From The Analysis

### 1. Average Daily Steps Analysis

The average daily steps among users is 7346, which is less than the [CDC recommendation of 10,000 steps per day](https://www.cdc.gov/pcd/issues/2016/pdf/16_0111.pdf). There is significant variability in the daily steps across users, ranging from 658 to 8731 steps.

![Average_Daily_Steps](/plots/average_daily_steps.png)

### 2. Average Calories Burned

The majority of users (24%) burn around 1751-2000 calories per day. Additionally, more than 12% of users burn over 3000 calories a day, suggesting engagement in intense physical activity.

![Average_Calories_Burned](/plots/average_burned_calories_distribution.png)

### 3. Average Sleep Time

It was hypothesized that most users would sleep within the [recommended 7-9 hours](https://pubmed.ncbi.nlm.nih.gov/29073398/) per night (420-540 minutes) for adults. However, the average time asleep was found to be 6.9 hours, slightly below the minimum recommended range.

![Average_Sleep_Time_Distribution](/plots/total_hours_asleep_distribution.png)

### 4. Sleep Time and Time in Bed Correlation

There is a very strong correlation between sleep time and time in bed. 

![Sleep_Time_Time_in_Bed_Correlation](/plots/time_in_bed_minutes_asleep_correlation.png)

On average, users spend 37.5 minutes in bed not sleeping, which may indicate longer time to fall asleep or spending time in bed after waking up.

![Sleep_Time_Time_Density_plot](/plots/additional_time_in_bed.png)

### 5. Time Asleep and Total Steps Walked

Testing the hypothesis that people who walk more sleep longer, there was a discovery of a very weak negative correlation (r = -0.125). There is a slight tendency for higher step counts to be associated with lower minutes of sleep, but this relationship is weak and not statistically significant.

![Sleep_vs_Steps](/plots/steps_vs_hour_asleep.png)

### 6. Trends in Sleep Data Over Time

Average weekday sleep time is 410 minutes, while the average weekend sleep is 417 minutes. Thus, on average, users sleep 7 minutes more on the weekend compared to weekdays.

![Sleep_Trends_Over_Time](/plots/weekend_weekday_time_asleep.png)

### 7. Steps and Distance Correlation

Examination whether the count of steps always correlates with a longer distance walked. The correlation is extremely strong (r = 0.986), indicating that while not always, step counts are a good indicator of the distance walked.

![Steps_and_Distance_Correlation](/plots/steps_and_distance_correlation.png)

### 8. Average Steps by Day of the Week

On average, users walk the most on Thursday (7977 steps) and Saturday (7899 steps), with the least amount of steps on Sunday (6688 steps).

![Average_Steps_by_Day_of_Week](/plots/avg_steps_by_day_of_the_week.png)

### 9. Daily Intensities Analysis

Analyzing the distribution of very active, fairly active, and lightly active minutes, data revealed the following ratios:
- Very Active: 8.65%
- Fairly Active: 5.71%
- Lightly Active: 85.6%

If considered as a percentage of a 24-hour day:
- Very Active: 1.43%
- Fairly Active: 0.97%
- Lightly Active: 13.3%

![Daily_Intensities_Analysis](/plots/daily_intensities.png)

### 10. Identifying Inactive Periods

When calculating the distribution of sedentary hours per day of the week, the following was observed:
- Monday: 16.9 hours
- Tuesday: 16.1 hours
- Wednesday: 16.4 hours
- Thursday: 17.0 hours
- Friday: 16.9 hours
- Saturday: 16.0 hours
- Sunday: 16.4 hours

Users have the most sedentary activity on Thursday, Monday, and Friday.

![Sedentary_Hours_Per_Day_of_Week](/plots/sedentary_hours.png)

### 11. Activity and Burned Calories Correlations

The correlation matrix below shows relationships between different activities and calories burned. Notably, there is a strong positive correlation between Steps and Calories (r ~ 0.73).

|                     | AvgTotalSteps | AvgVeryActiveMin | AvgFairlyActiveMin | AvgLightlyActiveMin | AvgCalories |
|---------------------|---------------|------------------|--------------------|---------------------|-------------|
| **AvgTotalSteps**   | 1.0000000     | 0.6553292        | 0.2648278          | 0.6969417           | 0.7282354   |
| **AvgVeryActiveMin**| 0.6553292     | 1.0000000        | 0.1440203          | 0.1223328           | 0.4638171   |
| **AvgFairlyActiveMin**| 0.2648278   | 0.1440203        | 1.0000000          | 0.2033879           | 0.4729974   |
| **AvgLightlyActiveMin**| 0.6969417  | 0.1223328        | 0.2033879          | 1.0000000           | 0.6851063   |
| **AvgCalories**     | 0.7282354     | 0.4638171        | 0.4729974          | 0.6851063           | 1.0000000   |

![TotalSteps_and_Calories_Correlation](/plots/steps_calories_correlation.png)

### Summary

The analysis of the Bellabeat dataset revealed significant insights into user behaviors and trends. Understanding these patterns can help Bellabeat tailor its products and marketing strategies to better meet user needs and promote healthier lifestyles.
