#Sourcing
source("R/04_visualize_distributions.R")

#HEI score T-test
hei_t_test <- health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  t.test(total_hei_score ~ insurance_status, data = .)

#Drinks Per Week Distribution
drinks_per_week_t_test <- health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  t.test(est_drinks_per_week ~ insurance_status, data = .)

#Monthly Cigarette Consumption Distribution
monthly_cigarette_consumption_t_test <- health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  t.test(num_cigs_in_last_30_days ~ insurance_status, data = .)

#LTPA Distribution
ltpa_t_test <- health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  t.test(ltpa_min_weekly ~ insurance_status, data = .)

#BMI Distribution
bmi_t_test <- health_metrics_insurance %>% 
  filter(!is.na(insurance_status_binary)) %>%
  t.test(bmi ~ insurance_status, data = .)