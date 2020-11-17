# LIBRARIES
library(shiny)
library(tidyr)
library(dplyr)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(reactable)
library(lubridate)
library(readr)
library(tidyselect)
library(ggplot2)
library(scales)
library(ggtext)
library(shinyBS)


# LOAD DATA
Risk_data <- readr::read_csv(here::here("Data/Covid_data_postprocessedv5.csv")) %>%
  mutate(name = case_when(name == "Type 1 HbA1 <= 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 1 HbA1c less than or equal to 58 mmol/mol in past year",
                   name == "Type 1 HbA1 > 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 1 HbA1c greater than 58 mmol/mol in past year",
                   name == "Type 2 and other HbA1 <= 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 2 and other HbA1c less than or equal to 58 mmol/mol in past year",
                   name == "Type 2 and other HbA1 > 58 mmol/mol in past year" & group == "Diabetes" ~ "Type 2 and other HbA1c greater than 58 mmol/mol in past year",
                   name == "40" & group == "BMI" ~ "Greater than or equal to 40",
                   name == "Estimated < GFR 30 mL/min" & group == "Chronic kidney disease" ~ "Estimated GFR less than 30 mL/min (includes patients on dialysis)",
                   name == "Diagnosed < 1 year ago" & group == "Non-haematological cancer" ~ "Diagnosed less than 1 year ago",
                   name == "Diagnosed >= 5 years ago" & group == "Non-haematological cancer" ~ "Diagnosed greater than or equal to 5 years ago",
                   TRUE ~ name))

Fatality_Rate <- readr::read_csv(here::here("Data/Fatailty_Rate.csv"))

Variable_lookup <- readr::read_csv(here::here("Data/Variable_lookup.csv")) 
  

# DERIVE LOOKUP TABLES
Sex <- Risk_data %>% filter(group == "Sex")

Ethnicity <- Risk_data %>% filter(group == "Ethnicity")

BMI <- Risk_data %>% filter(group == "BMI")

Asthma <- Risk_data %>% filter(group == "Asthma")

Diabetes <- Risk_data %>% filter(group == "Diabetes") 

Chronic_kidney_disease <- Risk_data %>% filter(group == "Chronic kidney disease")

Non_haematological_cancer <- Risk_data %>% filter(group == "Non-haematological cancer")

Haematological_cancer <- Risk_data %>% filter(group == "Haematological cancer")

Heart <- Risk_data %>% filter(group == "Heart")

Other <- Risk_data %>% filter(group == "Other")





  


