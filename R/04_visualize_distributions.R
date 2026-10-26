#Sourcing
source("R/03_add_non_hei_data.R")

##Poverty Status Proportions by Insurance Status
health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>% 
  mutate(
    poverty_status = ifelse(family_income_to_poverty_ratio > 1, "Above Poverty Line", "At or Below Poverty Line")
  ) %>% 
  ggplot(mapping = aes(x = insurance_status, fill = poverty_status)) + 
  geom_bar(position = "fill") + 
  labs(title = "Poverty Status by Insurance Status",
       x = "Insurance Status",
       fill = "Poverty Status")

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/Poverty Status by Insurance Status.png")

#HEI Score Distribution
health_metrics_insurance %>%
  filter(!is.na(insurance_status_binary)) %>%
  ggplot(aes(x = total_hei_score)) +
  geom_density(aes(fill = insurance_status), alpha = 0.4) +
  labs(title = "HEI Scores by Insurance Status",
       x = "Total HEI Score",
       y = "Density",
       fill = "Group") +
  theme_minimal()

ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/HEI Scores by Insurance Status.png")
  
#Drinks Per Week Distribution
health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  ggplot(aes(x = est_drinks_per_week)) +
  geom_density(aes(fill = insurance_status), alpha = 0.4) +
  coord_cartesian(xlim = c(0,
                           quantile(health_metrics_insurance$est_drinks_per_week, 0.99, na.rm = TRUE))) +
  labs(title = "Drinks Per Week by Insurance Status",
       subtitle = "(Zoomed to First 99% of Data)",
       x = "Drinks Per Week",
       y = "Density",
       fill = "Group") +
  theme_minimal()
  
ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/Drinks Per Week by Insurance Status.png")

#Monthly Cigarette Consumption Distribution
health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  ggplot(aes(x = num_cigs_in_last_30_days)) +
  geom_density(aes(fill = insurance_status), alpha = 0.4) +
  coord_cartesian(xlim = c(0,
                           quantile(health_metrics_insurance$num_cigs_in_last_30_days, 0.99, na.rm = TRUE))) +
  labs(title = "Monthly Cigarette Consumption by Insurance Status",
       subtitle = "(Zoomed to First 99% of Data)",
       x = "Monthly Cigarette Consumption",
       y = "Density",
       fill = "Group") +
  theme_minimal()
  
ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/Monthly Cigarrette Consumption by Insurance Status.png")
  
             
#LTPA Distribution
health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  ggplot(aes(x = ltpa_min_weekly)) +
  geom_density(aes(fill = insurance_status), alpha = 0.4) +
  coord_cartesian(xlim = c(0,
                           quantile(health_metrics_insurance$ltpa_min_weekly, 0.99, na.rm = TRUE))) +
  labs(title = "Liesure Time Physical Activity (LTPA) by Insurance Status",
       subtitle = "(Zoomed to First 99% of Data)",
       x = "LTPA (Minutes)",
       y = "Density",
       fill = "Group") +
  theme_minimal()
  
ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/LTPA by Insurance Status.png")

#BMI Distribution
health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  ggplot(aes(x = bmi)) +
  geom_density(aes(fill = insurance_status), alpha = 0.4) +
  labs(title = "Body Mass Index (BMI) by Insurance Status",
       x = "BMI",
       y = "Density",
       fill = "Group") +
  theme_minimal()
 
ggsave("C:/Users/jimmy/OneDrive/Documents/R Projects/Nhanes HEI Project/Outputs/Plots/BMI by Insurance Status.png")