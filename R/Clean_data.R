library(tidyverse)

Sex <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Sex") %>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Sex")

Ethnicity <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Ethnicity")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Ethnicity")

BMI <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "BMI")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "BMI")

Asthma <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Asthma")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Asthma")

Diabetes <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Diabetes")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Diabetes")

Chronic_kidney_disease <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Chronic kidney disease")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Chronic kidney disease")

Non_haematological_cancer <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Non-haematological cancer")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Non-haematological cancer")

Haematological_malignancy <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Haematological malignancy")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Haematological malignancy")

Other <- readxl::read_xlsx(here::here("Data/covid_workbook.xlsx"), sheet = "Other")%>%
    pivot_longer(cols = -age) %>%
    mutate(group = "Other")

Final_Risk <-
bind_rows(Sex,
          Ethnicity,
          BMI,
          Asthma,
          Diabetes,
          Chronic_kidney_disease,
          Non_haematological_cancer,
          Haematological_malignancy,
          Other)

readr::write_csv(Final_Risk, here::here("Data/tidy_risk.csv"))