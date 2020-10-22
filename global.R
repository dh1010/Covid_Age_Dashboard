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


# LOAD DATA
Risk_data <- readr::read_csv(here::here("Data/Covid_data_postprocessedv5.csv"))

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





  


