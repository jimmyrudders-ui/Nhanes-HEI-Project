#Sourcing
source("R/02_compute_hei.R")

#Create Combined Health Metric Data Frame (adding in diet information)
health_metrics_insurance <- nhanes_diet_per_person %>% 
  select(seqn, calories, protein_g, carbs_g, total_fat_g, sat_fat_g, 
         mono_fat_g, poly_fat_g, fiber_g, sugar_g, alcohol_g, total_hei_score)


#Join health insurance info
health_metrics_insurance <- health_metrics_insurance %>% 
  left_join(HIQ, by = "seqn") %>% 
  rename(
    seqn = seqn,
    covered_by_insurance = hiq011,
    covered_private = hiq032a,
    covered_medicare = hiq032b,
    covered_medigap = hiq032c,
    covered_medicaid = hiq032d,
    covered_chip = hiq032e,
    covered_military = hiq032f,
    covered_state_plan = hiq032h,
    covered_other_gov = hiq032i,
    months_no_insurance = hiq210
  ) %>% 
  mutate(
    insurance_status_binary = case_when( # 1 = has health insurance, 0 = has no health insurance
      covered_by_insurance == 1 ~ 1,
      covered_by_insurance == 2 ~ 0,
      .default = NA
    )
  )


#Join demographic info (gender, age, race, family income to poverty)
health_metrics_insurance <- health_metrics_insurance %>%
  left_join(
    (DV_SW %>% select("seqn", "riagendr", "ridageyr", "ridreth3", "indfmpir", "dmdeduc2")), 
    by = "seqn") %>% 
  rename(
    gender = riagendr, #1 = male, 2 = female
    age = ridageyr,
    race = ridreth3, #1 = mexican american, 2 = other hispanic, 3 = white, 4 = black, 7 = other
    family_income_to_poverty_ratio = indfmpir,
    education_level = dmdeduc2
  )


#Filter out calories under 600 and ages under 18
health_metrics_insurance <- health_metrics_insurance  %>% 
  filter_out(age < 18) %>% 
  filter_out(calories < 600)


#Join alcohol per week
ALQ <- ALQ %>%
  left_join(health_metrics_insurance %>% select("seqn", "age"), 
            by = "seqn") %>% 
  filter_out(age < 18) %>% #filter out youth
  mutate(
    days_per_year = case_when(
      alq121 == 0  ~ 0,
      alq121 == 1  ~ 365,
      alq121 == 2  ~ 300,
      alq121 == 3  ~ 182,
      alq121 == 4  ~ 104,
      alq121 == 5  ~ 52,
      alq121 == 6  ~ 30,
      alq121 == 7  ~ 12,
      alq121 == 8  ~ 9,
      alq121 == 9  ~ 4.5,
      alq121 == 10 ~ 1.5,
      TRUE ~ NA_real_
    ),
    drinks_per_drinking_day = case_when(
      alq130 == 15    ~ 15,      
      alq130 %in% c(1:14) ~ alq130,  
      TRUE ~ NA_real_     
    ),
    est_drinks_per_week = if_else(
      alq111 == 2 | alq121 == 0, 
      0,
      round((drinks_per_drinking_day * days_per_year) / 52, digits = 5)
    ))

health_metrics_insurance <- health_metrics_insurance %>% 
  left_join(
    ALQ %>% select("seqn", "est_drinks_per_week"),
    by = "seqn")


#Join cigarettes per week
SMQ <- SMQ %>% 
  left_join(health_metrics_insurance %>% select("seqn", "age"), 
            by = "seqn") %>% 
  filter_out(age < 18) %>%
  filter_out(smq621 %in% c(1:8,77,99) | smd630 %in% c(1:18,77,99)) %>% #filter out youth
  mutate(
   smoke_status = case_when(
      smq020 == 2 | smq040 == 3 ~ 0,  #Non Smoker
      smq020 == 1 & smq040 == 2 ~ 1,  #Smoker Some Days
      smq020 == 1 & smq040 == 1 ~ 2, #Daily Smoker
      TRUE ~ NA_real_
    ),
   num_cigs_in_last_30_days = case_when(
     (smq040 %in% c(7,9)) | (smd641 %in% c(77,99)) | (smd650 %in% c(777,999)) ~ NA_real_,
     smoke_status == 0 ~ 0,
     smoke_status == 1 & smd641 == 0 ~ 0,
     smoke_status == 1 & smd641 > 0 ~ smd641 * smd650,
     smoke_status == 2 ~ smd650 * 30,
     TRUE ~ NA_real_
   )
  )

health_metrics_insurance <- health_metrics_insurance %>% 
  left_join(
    SMQ %>% select("seqn", "num_cigs_in_last_30_days"),
    by = "seqn")


#Join exercise per week
PAQ <- PAQ %>% 
  mutate(
    moderate_ltpa_min_weekly = case_when(
      pad790q %in% c(7777,9999) | pad800 %in% c(7777, 9999) ~ NA_real_,
      pad790u == "D" ~ round(pad790q * pad800 * 7, 2),
      pad790u == "M" ~ round((pad790q * pad800 / 30) * 7, 2),
      pad790u == "W" ~ round(pad790q * pad800, 2),
      pad790u == "Y" ~ round((pad790q * pad800 / 365) * 7, 2),
      TRUE ~ NA_real_
    ),
    vigorous_ltpa_min_weekly = case_when(
      pad810q %in% c(7777,9999) | pad820 %in% c(7777, 9999) ~ NA_real_,
      pad810u == "D" ~ round(pad810q * pad820 * 7, 2),
      pad810u == "M" ~ round((pad810q * pad820 / 30) * 7, 2),
      pad810u == "W" ~ round(pad810q * pad820, 2),
      pad810u == "Y" ~ round((pad810q * pad820 / 365) * 7, 2),
      TRUE ~ NA_real_
    ),
    ltpa_min_weekly = if_else(  #Truncating reports of over 2500 minutes per week (implausible ~ over 6 hours a day)
      round(coalesce(moderate_ltpa_min_weekly, 0) + coalesce(vigorous_ltpa_min_weekly, 0), 2) > 2500,
      NA_real_,
      round(coalesce(moderate_ltpa_min_weekly, 0) + coalesce(vigorous_ltpa_min_weekly, 0), 2))
  )

health_metrics_insurance <- health_metrics_insurance %>% 
  left_join(
    PAQ %>% select("seqn", "ltpa_min_weekly"),
    by = "seqn")


#Join BMI
health_metrics_insurance <- health_metrics_insurance %>% 
  left_join(
    BMX %>% select("seqn", "bmxbmi"),
    by = "seqn") %>% 
  rename(
    bmi = bmxbmi
  )