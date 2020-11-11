
library(shinydashboard)

dashboardPage(
    
    dashboardHeader(title = span(img(src="logo.jpg", width = "200px")),#"Covid Age",
                    tags$li(div(h4("Covid-age"),
                              style = "padding-top:10px; paddingbottom:10px;margin-right:30px;color:white"),
                            class = "dropdown")),
    
    dashboardSidebar(collapsed = T, 
                     tags$script(JS("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';"))),
    
    dashboardBody(
        tags$style("#covid_age {font-size:20px;
                display:block; }"),
        
        tags$style(HTML(
            '.skin-blue .main-sidebar {
            background-color: white;}',
            
            '.skin-blue .main-header .logo {
            background-color: #018bd3;}',
            
            '.skin-blue .main-header .navbar {
            background-color: #018bd3}',
            
            '.skin-blue .main-header .logo:hover {
            background-color: #018bd3;}',
            
            '.box.box-primary {
                border-top-color: #018bd3;
            }',
            
            '.div .light-blue {
            background-color: #018bd3;;
            }',
            
            '.bg-light-blue, .label-primary, .modal-primary .modal-body {
            background-color: #018bd3 !important;
            }'
        )),
        tags$style(HTML("

                    .box.box-solid.box-primary>.box-header {
                    color:#018bd3;
                    background:#018bd3
                    }

                    .box.box-solid.box-primary{
                    border-bottom-color:#018bd3;
                    border-left-color:#018bd3;
                    border-right-color:#018bd3;
                    border-top-color:#018bd3;
                    background:#018bd3
                    }

                    ")),
        
        fluidRow(column(width = 12,
        box(width = 12,
            HTML("<h4>Details of the Covid-age project, evidence-base and warnings are published at <a href='https://alama.org.uk/covid-19-medical-risk-assessment/'>https://alama.org.uk/covid-19-medical-risk-assessment/</a>
            Users are strongly advised to read the guidance on the ALAMA website before using the Covid-age tool.
                 The evidence reviewed allows calculation of indicative Covid-age for adults aged 20-75. 
                 Clinical judgement should be used to adjust the Covid-age value for workers outside this age range.<h4>")))),
        fluidPage(
        column(width = 6,
               box(width = 12, status = "primary",
                        numericInput("age_in",
                                     "Please input the person’s age in years (if under 20, enter 20 and if over 75 enter 75)",
                                     value = min(unique(Risk_data$age)),
                                     min = min(unique(Risk_data$age)),
                                     max = max(unique(Risk_data$age))),

                        radioButtons("sex_in", "Sex",
                                     choices = c("Female", "Male")),

                        pickerInput("eth_in", "Ethnicity",
                                     choices = unique(Ethnicity$name)),
                   
                        actionButton("calc_bmi", "Calculate BMI"),
                   
                        textOutput("bmi_print"),

                        pickerInput("bmi_in", "Or input BMI manually", selected = NULL,
                                    choices = c("Please select", "<30", unique(BMI$name))),

                        pickerInput("asthma_in", "Asthma", selected = "None",
                                     choices = c("None", "Mild", "Severe")),

                        pickerInput("diabetes_in", "Diabetes", selected = "None",
                                    choices = c("None", 
                                                "Type 1 HbA1 <= 58 mmol/mol in past year",
                                                "Type 1 HbA1 > 58 mmol/mol in past year",
                                                "Type 1 HbA1c unknown",
                                                "Type 2 and other HbA1 <= 58 mmol/mol in past year",
                                                "Type 2 and other HbA1 > 58 mmol/mol in past year",
                                                "Type 2 and other HbA1c unknown"  )),

                        pickerInput("kidney_in", "Chronic kidney disease", selected = "None",
                                    choices = c("None", "Estimated < GFR 30 mL/min", "Estimated GFR 30-60 mL/min")),

                        pickerInput("non_hae_in", "Non-haematological cancer", selected = "None",
                                    choices = c("None", "Diagnosed < 1 year ago", "Diagnosed 1-4.9 years ago", "Diagnosed >= 5 years ago")),

                        pickerInput("hae_mal_in", "Haematological cancer", selected = "None",
                                    choices = c("None", unique(Haematological_cancer$name))),

                        pickerInput("heart_in", "Heart", selected = "None",
                                    choices = c("None", unique(Heart$name))),

                        pickerInput("other_in", "Other conditions", selected = NULL, multiple = T,
                                    choices = c("Other chronic respiratory disease",
                                                "Hypertension",
                                                "Cerebrovascular disease",
                                                "Liver disease",
                                                "Chronic neurological disease other than stroke or dementia",
                                                "Organ transplant",
                                                "Spleen diseases",
                                                "Rheumatoid/lupus/psoriasis",
                                                "Other immunosuppressive condition")),
                    )
        ),
        column(width = 6,
               box(width = 12, status = "primary",
                        reactableOutput("covidtable")),
               box(width = 12, status = "primary",
                   background = "light-blue",
                   uiOutput("covid_age"),
                   uiOutput("covid_fatality")
                   
                   ),
               box(width = 12,
                   h5("Estimates of Covid-age are based on published epidemiological data and may be revised if new research is reported that materially changes the balance of available evidence. Where an individual has multiple health conditions the calculator may overestimate vulnerability somewhat, especially in young adults."),
                   h5("Risks associated with health conditions are estimated as averages and may vary within a disease category. Use clinical judgement to adjust the values where appropriate."),
                   
                   h5("Where a condition is not included because no adequate evidence is available, it may be reasonable to apply added year estimates  taken from other similar conditions that are listed. For example inflammatory bowel diseases and inflammatory skin diseases may have similar vulnerability to inflammatory joint diseases. Clinical judgement should be used."),
                   
                   h5("Covid-age estimates vulnerability. Your risk will also depend on local infection rates (viral prevalence), your job role (and controls in place) and your behaviours in relation to social distancing, hygiene and face covering."),br(),
                   
                   h4("A suggested stratification for vulnerability is:"),
                   
                   h4("85 and over = very high"),
                   
                   h4("70-84 =       high"),
                   
                   h4("50-69 =       moderate"),
                   
                   h4("Under 50 =    low"),br(),
                   
                   h5("Clinical judgement can be used to place individuals in a higher or lower group where appropriate.")
                   )
               
        )
    )
)
)
