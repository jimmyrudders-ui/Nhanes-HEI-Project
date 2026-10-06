#Sourcing
source("R/01_import_data.R")

#Join food codes and calculate FPED values using FPED equivalents
foods_fped <- DI_IF_FD %>% #Begin with "Dietary Interview - Individual Foods, First Day"
  left_join(DI_TS_FC, by = c("dr1ifdcd" = "drxfdcd")) %>% #Joins the "Dietary Interview Technical Support File - Food Codes"
  left_join(fped_2017_2020, by = c("dr1ifdcd" = "foodcode")) %>% #Joins the FPED 100-gram-equivalent information
  mutate( #Calculate Components of HEI using grams from DI_IF_FD and 100 gram equivalents from fped_2017_2020
    total_fruits = f_total_cup_eq * dr1igrms / 100,
    whole_fruits = (f_total_cup_eq - f_juice_cup_eq) * dr1igrms / 100,
    total_vegetables = v_total_cup_eq * dr1igrms / 100,
    greens_and_beans = (v_drkgr_cup_eq + v_legumes_cup_eq) * dr1igrms / 100,
    whole_grains = g_whole_oz_eq * dr1igrms / 100,
    dairy = d_total_cup_eq * dr1igrms / 100,
    total_protein_foods = pf_total_oz_eq * dr1igrms / 100,
    seafood_and_plant_proteins = (pf_seafd_hi_oz_eq + pf_seafd_low_oz_eq +
                                    pf_soy_oz_eq + pf_nutsds_oz_eq + pf_legumes_oz_eq) * dr1igrms / 100,
    refined_grains = g_refined_oz_eq * dr1igrms / 100,
    sodium = dr1isodi,
    oils_g = oils_grams * dr1igrms / 100,
    added_sugars_tsp = add_sugars_tsp_eq * dr1igrms / 100
  )


#Calculate Per Person Values
nhanes_diet_per_person <- foods_fped %>% #Begin with foods_fped (contains HEI components calculated per entry)
  group_by(seqn) %>% #Group by ID number
  summarise( #calculate per-person HEI components as well as other useful nutrition info
    
    #general nutrition totals
    n_foods = n(),
    total_grams = sum(dr1igrms, na.rm = TRUE),
    
    calories = sum(dr1ikcal, na.rm = TRUE),
    protein_g = sum(dr1iprot, na.rm = TRUE),
    carbs_g = sum(dr1icarb, na.rm = TRUE),
    total_fat_g = sum(dr1itfat, na.rm = TRUE),
    
    sat_fat_g = sum(dr1isfat, na.rm = TRUE),
    mono_fat_g = sum(dr1imfat, na.rm = TRUE),
    poly_fat_g = sum(dr1ipfat, na.rm = TRUE),
    
    fiber_g = sum(dr1ifibe, na.rm = TRUE),
    sugar_g = sum(dr1isugr, na.rm = TRUE),
    alcohol_g = sum(dr1ialco, na.rm = TRUE),
    cholesterol_mg = sum(dr1ichol, na.rm = TRUE),
    total_oils_g = sum(oils_g, na.rm = TRUE),
    
    #HEI Adequacy components
    total_fruits_cup = sum(total_fruits, na.rm = TRUE),
    total_fruits_cup_per_1000kcal = total_fruits_cup * (1000 / calories),
    
    whole_fruits_cup = sum(whole_fruits, na.rm = TRUE),
    whole_fruits_cup_per_1000kcal = whole_fruits_cup * (1000 / calories),
    
    total_vegetables_cup = sum(total_vegetables, na.rm = TRUE),
    total_vegetables_cup_per_1000kcal = total_vegetables_cup * (1000 / calories),
    
    greens_and_beans_cup = sum(greens_and_beans, na.rm = TRUE),
    greens_and_beans_cup_per_1000kcal = greens_and_beans_cup * (1000 / calories),
    
    whole_grains_oz = sum(whole_grains, na.rm = TRUE),
    whole_grains_oz_per_1000kcal = whole_grains_oz * (1000 / calories),
    
    dairy_cup = sum(dairy, na.rm = TRUE),
    dairy_cup_per_1000kcal = dairy_cup * (1000 / calories),
    
    total_protein_oz = sum(total_protein_foods, na.rm = TRUE),
    total_protein_oz_per_1000kcal = total_protein_oz * (1000 / calories),
    
    seafood_plant_oz = sum(seafood_and_plant_proteins, na.rm = TRUE),
    seafood_plant_oz_per_1000kcal = seafood_plant_oz * (1000 / calories),
    
    fatty_acid_ratio = (mono_fat_g + poly_fat_g) / sat_fat_g,
    
    #HEI moderation components
    sat_fat_cal = sat_fat_g * 9,
    
    refined_grains_oz = sum(refined_grains, na.rm = TRUE),
    refined_grains_oz_per_1000kcal = refined_grains_oz * (1000 / calories),
    
    sodium_mg = sum(dr1isodi, na.rm = TRUE),
    sodium_mg_per_1000kcal = sodium_mg * (1000 / calories),
    
    added_sugars_cals = sum(added_sugars_tsp, na.rm = TRUE) * 16,
    added_sugar_cal_percentage = (added_sugars_cals / calories) * 100
  )



#Calculate HEI scores
nhanes_diet_per_person <- nhanes_diet_per_person %>% #Begin with per person diets
  mutate(
    #Adequacy scores (score proportionally by using pmin() and case_when)
    total_fruits_score =
      pmin(5, 5 * (total_fruits_cup_per_1000kcal / 0.8)),
    
    whole_fruits_score =
      pmin(5, 5 * (whole_fruits_cup_per_1000kcal / 0.4)),
    
    total_vegetables_score =
      pmin(5, 5 * (total_vegetables_cup_per_1000kcal / 1.1)),
    
    greens_and_beans_score =
      pmin(5, 5 * (greens_and_beans_cup_per_1000kcal / 0.2)),
    
    whole_grains_score =
      pmin(10, 10 * (whole_grains_oz_per_1000kcal / 1.5)),
    
    dairy_score =
      pmin(10, 10 * (dairy_cup_per_1000kcal / 1.3)),
    
    total_protein_score =
      pmin(5, 5 * (total_protein_oz_per_1000kcal / 2.5)),
    
    seafood_plant_score =
      pmin(5, 5 * (seafood_plant_oz_per_1000kcal / 0.8)),
    
    fatty_acid_score = case_when(
      fatty_acid_ratio >= 2.5 ~ 10,
      fatty_acid_ratio <= 1.2 ~ 0,
      TRUE ~ 10 * ((fatty_acid_ratio - 1.2) / (2.5 - 1.2))
    ),
    
    
    #Moderation scores (score proportionally using case_when())
    
    saturated_fat_score = case_when(
      (sat_fat_cal / calories) * 100 <= 8  ~ 10,
      (sat_fat_cal / calories) * 100 >= 16 ~ 0,
      TRUE ~ 10 * ((16 - ((sat_fat_cal / calories) * 100)) / (16 - 8))
    ),
    
    refined_grains_score = case_when(
      refined_grains_oz_per_1000kcal <= 1.8 ~ 10,
      refined_grains_oz_per_1000kcal >= 4.3 ~ 0,
      TRUE ~ 10 * ((4.3 - refined_grains_oz_per_1000kcal) / (4.3 - 1.8))
    ),
    
    sodium_score = case_when(
      sodium_mg_per_1000kcal <= 1100 ~ 10,
      sodium_mg_per_1000kcal >= 2000 ~ 0,
      TRUE ~ 10 * ((2000 - sodium_mg_per_1000kcal) / (2000 - 1100))
    ),
    
    added_sugars_score = case_when(
      added_sugar_cal_percentage <= 6.5 ~ 10,   
      added_sugar_cal_percentage >= 26 ~ 0,   
      TRUE ~ 10 * ((26 - added_sugar_cal_percentage) / (26 - 6.5))
    ),
    
    total_hei_score =
      (total_fruits_score +
      whole_fruits_score +
      total_vegetables_score +
      greens_and_beans_score +
      whole_grains_score +
      dairy_score +
      total_protein_score +
      seafood_plant_score +
      fatty_acid_score +
      saturated_fat_score +
      refined_grains_score +
      sodium_score +
      added_sugars_score)
  )
