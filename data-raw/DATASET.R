## code to prepare `DATASET` dataset goes here

Risk_data <- readr::read_csv(here::here("data-raw/app_data/Covid_data_postprocessedv5.csv")) %>%
  dplyr::mutate(name = dplyr::case_when(
    name == "Type 1 HbA1 <= 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 1 HbA1c less than or equal to 58 mmol/mol in past year",
    name == "Type 1 HbA1 > 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 1 HbA1c greater than 58 mmol/mol in past year",
    name == "Type 2 and other HbA1 <= 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 2 and other HbA1c less than or equal to 58 mmol/mol in past year",
    name == "Type 2 and other HbA1 > 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 2 and other HbA1c greater than 58 mmol/mol in past year",
    name == "40" & group == "BMI" ~ "Greater than or equal to 40",
    name == "Estimated < GFR 30 mL/min" & group == "Chronic kidney disease" ~ "Estimated GFR less than 30 mL/min (includes patients on dialysis)",
    name == "Diagnosed < 1 year ago" & group == "Non-haematological cancer" ~ "Diagnosed less than 1 year ago",
    name == "Diagnosed >= 5 years ago" & group == "Non-haematological cancer" ~ "Diagnosed greater than or equal to 5 years ago",
    TRUE ~ name
  ))

usethis::use_data(Risk_data, overwrite = TRUE)


Fatality_Rate <- readr::read_csv(here::here("data-raw/app_data/Fatailty_Rate.csv"))
usethis::use_data(Fatality_Rate, overwrite = TRUE)

Variable_lookup <- readr::read_csv(here::here("data-raw/app_data/Variable_lookup.csv")) 
usethis::use_data(Variable_lookup, overwrite = TRUE)

# DERIVE LOOKUP TABLES
Sex <- Risk_data %>% dplyr::filter(group == "Sex")
usethis::use_data(Sex, overwrite = TRUE)

Ethnicity <- Risk_data %>% dplyr::filter(group == "Ethnicity")
usethis::use_data(Ethnicity, overwrite = TRUE)

BMI <- Risk_data %>% dplyr::filter(group == "BMI")
usethis::use_data(BMI, overwrite = TRUE)

Asthma <- Risk_data %>% dplyr::filter(group == "Asthma")
usethis::use_data(Asthma, overwrite = TRUE)

Diabetes <- Risk_data %>% dplyr::filter(group == "Diabetes") 
usethis::use_data(Diabetes, overwrite = TRUE)

Chronic_kidney_disease <- Risk_data %>% dplyr::filter(group == "Chronic kidney disease")
usethis::use_data(Chronic_kidney_disease, overwrite = TRUE)

Non_haematological_cancer <- Risk_data %>% dplyr::filter(group == "Non-haematological cancer")
usethis::use_data(Non_haematological_cancer, overwrite = TRUE)

Haematological_cancer <- Risk_data %>% dplyr::filter(group == "Haematological cancer")
usethis::use_data(Haematological_cancer, overwrite = TRUE)

Heart <- Risk_data %>% dplyr::filter(group == "Heart")
usethis::use_data(Heart, overwrite = TRUE)

Other <- Risk_data %>% dplyr::filter(group == "Other")
usethis::use_data(Other, overwrite = TRUE)

