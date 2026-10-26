#Sourcing
source("R/05_t_tests.R")

#Visualize HEI T-Test
health_metrics_insurance %>%
  filter(!is.na(insurance_status)) %>%
  ggplot(aes(x = insurance_status, y = total_hei_score, fill = insurance_status)) +
  stat_summary(fun = mean, geom = "bar", width = 0.6) +
  stat_compare_means(method = "t.test", label.y = 60) +
  labs(x = "Insurance Status", y = "HEI Score", fill = "Insurance Status",
       title = "HEI Score T-Test Results")

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/HEI Score T-Test Results Bar Chart.png")

#Visualize Drink per Week T-Test
health_metrics_insurance %>%
  filter(!is.na(insurance_status)) %>%
  ggplot(aes(x = insurance_status, y = est_drinks_per_week, fill = insurance_status)) +
  stat_summary(fun = mean, geom = "bar", width = 0.6) +
  stat_compare_means(method = "t.test", label.y = 5) +
  labs(x = "Insurance Status", y = "Drinks per Week", fill = "Insurance Status",
       title = "Drinks per Week Score T-Test Results")

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/Drinks per Week Score T-Test Results Bar Chart.png")

#Visualize Monthly Cigarette Consumption T-Test
health_metrics_insurance %>%
  filter(!is.na(insurance_status)) %>%
  ggplot(aes(x = insurance_status, y = num_cigs_in_last_30_days, fill = insurance_status)) +
  stat_summary(fun = mean, geom = "bar", width = 0.6) +
  stat_compare_means(method = "t.test", label.y = 80) +
  labs(x = "Insurance Status", y = "Monthly Cigarette Consumption", fill = "Insurance Status",
       title = "Monthly Cigarette Consumption T-Test Results")

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/Monthly Cigarette Consumption T-Test Results Bar Chart.png")

#Visualize LTPA T-Test
health_metrics_insurance %>%
  filter(!is.na(insurance_status)) %>%
  ggplot(aes(x = insurance_status, y = ltpa_min_weekly, fill = insurance_status)) +
  stat_summary(fun = mean, geom = "bar", width = 0.6) +
  stat_compare_means(method = "t.test", label.y = 300) +
  labs(x = "Insurance Status", y = "Weeky LTPA Minutes", fill = "Insurance Status",
       title = "Weekly LTPA Minutes T-Test Results")

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/Weekly LTPA Minutes T-Test Results Bar Chart.png")

#Visualize BMI T-Test
health_metrics_insurance %>%
  filter(!is.na(insurance_status)) %>%
  ggplot(aes(x = insurance_status, y = bmi, fill = insurance_status)) +
  stat_summary(fun = mean, geom = "bar", width = 0.6) +
  stat_compare_means(method = "t.test", label.y = 35) +
  labs(x = "Insurance Status", y = "BMI", fill = "Insurance Status",
       title = "BMI T-Test Results")

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/BMI T-Test Results Bar Chart.png")
