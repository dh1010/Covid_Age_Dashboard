
library(shinydashboard)

dashboardPage(
  dashboardHeader(
    title =span(img(src = "logo.jpg", width = "200px")),
    tags$li(div(h4("Covid-age"),
      style = "padding-top:10px; paddingbottom:10px;margin-right:30px;color:white"
    ),
    class = "dropdown"
    )
  ),

  dashboardSidebar(
    collapsed = T,
    tags$script(JS("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';"))
  ),

  dashboardBody(
    tags$style("#covid_age {font-size:20px; display:block; }"),

    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),

    fluidRow(column(
      width = 12,
      box(
        width = 12,
        HTML("<h4>Details of the Covid-age project, evidence-base and warnings are published at <a href='https://alama.org.uk/covid-19-medical-risk-assessment/'>https://alama.org.uk/covid-19-medical-risk-assessment/</a>
            Users are strongly advised to read the guidance on the ALAMA website before using the Covid-age tool.
                 The evidence reviewed allows calculation of indicative Covid-age for adults aged 20-75. 
                 Clinical judgement should be used to adjust the Covid-age value for workers outside this age range.<h4>")
      )
    )),
    fluidPage(
      column(
        width = 6,
        box(
          width = 12, status = "primary",
          numericInput("age_in",
            "Please input the person’s age in years (if under 20, enter 20 and if over 75 enter 75)",
            value = min(unique(Risk_data$age)),
            min = min(unique(Risk_data$age)),
            max = max(unique(Risk_data$age))
          ),

          radioButtons("sex_in", "Sex",
            choices = c("Female", "Male")
          ),

          selectInput("eth_in", "Ethnicity",
            choices = unique(Ethnicity$name)
          ),
          fluidRow(
            column(width = 4, actionButton("calc_bmi", "Calculate BMI")),
            column(width = 8, textOutput("bmi_print"))
          ), br(),

          selectInput("bmi_in", "Or input BMI manually",
            selected = NULL,
            choices = c("Please select", "Less than 30", unique(BMI$name))
          ),

          selectInput("asthma_in", "Asthma",
            selected = "None",
            choices = c("None", unique(Asthma$name))
          ),

          bsTooltip("asthma_in",
            paste0(
              "<p>Mild:  No requirement for oral corticosteroids in past year</p>",
              "<p>Severe:  Requiring oral corticosteroids in past year</p>"
            ), "right",
            options = list(container = "body")
          ),


          selectInput("diabetes_in", "Diabetes",
            selected = "None",
            choices = c("None", unique(Diabetes$name))
          ),


          selectInput("kidney_in", "Chronic kidney disease",
            selected = "None",
            choices = c("None", unique(Chronic_kidney_disease$name))
          ),

          selectInput("non_hae_in", "Cancer other than leukaemia, lymphoma or myeloma",
            selected = "None",
            choices = c("None", unique(Non_haematological_cancer$name))
          ),

          selectInput("hae_mal_in", "Leukaemia, lymphoma or myeloma",
            selected = "None",
            choices = c("None", unique(Haematological_cancer$name))
          ),

          selectInput("heart_in", "Heart",
            selected = "None",
            choices = c("None", unique(Heart$name))
          ),

          # Other

          checkboxInput(
            inputId = "ocrd",
            label = tags$span(id = "ocrd_lab", "Other chronic respiratory disease")
          ),
          bsTooltip(
            id = "ocrd_lab",
            "Includes chronic obstructive pulmonary disease (COPD), chronic bronchitis, emphysema, pulmonary fibrosis, bronchiectasis, cystic fibrosis"
          ),

          checkboxInput(
            inputId = "ht",
            label = tags$span(id = "ht_lab", "Hypertension")
          ),
          bsTooltip(
            id = "ht_lab",
            "Known diagnosis of hypertension or high blood pressure, with or without treatment"
          ),

          checkboxInput("cvd",
            label = tags$span(id = "cvd_lab", "Cerebrovascular disease")
          ),
          bsTooltip("cvd", "Includes previous stroke and transient ischaemic attacks",
            "right",
            options = list(container = "body")
          ),

          checkboxInput(
            inputId = "ld",
            label = tags$span(id = "ld_lab", "Liver disease")
          ),
          bsTooltip(
            id = "ld_lab",
            "Includes cirrhosis"
          ),

          checkboxInput(
            inputId = "cnd",
            label = tags$span(id = "cnd_lab", "Chronic neurological disease other than stroke or dementia")
          ),
          bsTooltip(
            id = "cnd_lab",
            "Includes motor neurone disease, myasthenia gravis, multiple sclerosis, Parkinson’s disease, cerebral palsy, quadriplegia, hemiplegia and progressive cerebellar disease"
          ),

          checkboxInput(
            inputId = "organ",
            label = tags$span(id = "organ_lab", "Organ transplant")
          ),

          checkboxInput(
            inputId = "spleen",
            label = tags$span(id = "spleen_lab", "Spleen diseases")
          ),
          bsTooltip(
            id = "spleen_lab",
            "Includes splenectomy, or spleen dysfunction (e.g. from sickle cell disease)"
          ),

          checkboxInput(
            inputId = "rlp",
            label = tags$span(id = "rlp_lab", "Rheumatoid/lupus/psoriasis")
          ),

          checkboxInput(
            inputId = "immuno",
            label = tags$span(id = "immuno_lab", "Other immunosuppressive condition")
          ),
          bsTooltip(
            id = "immuno_lab",
            "Includes splenectomy, or spleen dysfunction (e.g. from sickle cell disease)"
          ),
        )
      ),
      column(
        width = 6,
        box(
          width = 12, status = "primary",
          reactableOutput("covidtable")
        ),
        box(
          width = 12, status = "primary",
          background = "light-blue",
          uiOutput("covid_age"),
          uiOutput("covid_fatality")
        ),
        box(
          width = 12,
          h5("Estimates of Covid-age are based on published epidemiological data and may be revised if new research is reported that materially changes the balance of available evidence. Where an individual has multiple health conditions the calculator may overestimate vulnerability somewhat, especially in young adults."),
          h5("Risks associated with health conditions are estimated as averages and may vary within a disease category. Use clinical judgement to adjust the values where appropriate."),

          h5("Where a condition is not included because no adequate evidence is available, it may be reasonable to apply added year estimates  taken from other similar conditions that are listed. For example inflammatory bowel diseases and inflammatory skin diseases may have similar vulnerability to inflammatory joint diseases. Clinical judgement should be used."),

          h5("Covid-age estimates vulnerability. Your risk will also depend on local infection rates (viral prevalence), your job role (and controls in place) and your behaviours in relation to social distancing, hygiene and face covering."), br(),

          h4("A suggested stratification for vulnerability is:"),

          h4("85 and over = very high"),

          h4("70-84 =       high"),

          h4("50-69 =       moderate"),

          h4("Under 50 =    low"), br(),

          h5("Clinical judgement can be used to place individuals in a higher or lower group where appropriate.")
        )
      )
    )
  )
)
