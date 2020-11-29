
#' Application Server
#'
#' @param input 
#' @param output 
#' @param session 
#'
#' @return
#' @export
#'
app_server <- function(input, output, session) {

      # If nothing is selected in the "other" group change input to "None"
      # This silences errors in the variable matching.
      other <- shiny::reactive({
        tibble::tribble(
          ~variable, ~condition,
          "Other chronic respiratory disease", input$ocrd,
          "Hypertension", input$ht,
          "Cerebrovascular disease", input$cvd,
          "Liver disease", input$ld,
          "Chronic neurological disease other than stroke or dementia", input$cnd,
          "Organ transplant", input$organ,
          "Spleen diseases", input$spleen,
          "Rheumatoid/lupus/psoriasis", input$rlp,
          "Other immunosuppressive condition", input$immuno
        ) %>%
          dplyr::filter(condition == TRUE) %>%
          dplyr::pull(variable)
      })

      # Create the user profile based on user input
      user_profile <- shiny::reactive({
        Risk_data %>%
          dplyr::filter(
            age == input$age_in,
            name == input$sex_in & group == "Sex" |
              name == input$eth_in & group == "Ethnicity" |
              name == input$bmi_in & group == "BMI" |
              name == input$asthma_in & group == "Asthma" |
              name == input$diabetes_in & group == "Diabetes" |
              name == input$kidney_in & group == "Chronic kidney disease" |
              name == input$non_hae_in & group == "Non-haematological cancer" |
              name == input$heart_in & group == "Heart" |
              name == input$hae_mal_in & group == "Haematological cancer" |
              name %in% other() & group == "Other"
          )
      })

      modifier <- shiny::reactive(
        user_profile() %>%
          dplyr::summarise(modifier = sum(value, na.rm = T)) %>%
          dplyr::pull()
      )

      covid_age <- shiny::reactive(modifier() + input$age_in)

      upper_fatality_rate <- shiny::reactive(
        Fatality_Rate %>%
          dplyr::filter(`Covid-age` == covid_age()) %>%
          dplyr::pull(`Infection fatality rate per 1000 Upper bound`)
      )

      lower_fatality_rate <- shiny::reactive(
        Fatality_Rate %>%
          dplyr::filter(`Covid-age` == covid_age()) %>%
          dplyr::pull(`Infection fatality rate per 1000 Lower bound`)
      )

      # Calculate Covid-age using the user-input
      # This is matched to data provided by the ALAMA group
      # https://alama.org.uk/covid-19-medical-risk-assessment/
      output$covid_age <- shiny::renderUI({
        if (covid_age() < 20) {
          HTML(glue::glue("<h3>Covid-age: {input$age_in} + {modifier()} = 20-<h3/>"))
        } else if (covid_age() <= 85) {
          HTML(glue::glue("<h3>Covid-age: {input$age_in} + {modifier()} = {covid_age()}<h3/>"))
        } else if (covid_age() > 85) {
          HTML(glue::glue("<h3>Covid-age: {input$age_in} + {modifier()} = 85+<h3/>"))
        } else {
          HTML("Covid-age not available")
        }
      })

      output$covid_fatality <- shiny::renderUI({
        if (covid_age() < 20) {
          HTML(glue::glue("<h5>If infection occurs, the probability that it will be fatal is expected to lie between {min(Fatality_Rate$`Infection fatality rate per 1000 Lower bound`)} per 1000 and {min(Fatality_Rate$`Infection fatality rate per 1000 Upper bound`)} per 1000 <br/> For Covid-ages less than 20, the risk of fatality may be even lower than indicated<h5/>"))
        } else if (covid_age() <= 85) {
          HTML(glue::glue("<h5>If infection occurs, the probability that it will be fatal is expected to lie between {lower_fatality_rate()} per 1000 and {upper_fatality_rate()} per 1000<h5/>"))
        } else if (covid_age() > 85) {
          HTML(glue::glue("<h5>If infection occurs, the probability that it will be fatal is expected to lie between {max(Fatality_Rate$`Infection fatality rate per 1000 Lower bound`)} per 1000 and {max(Fatality_Rate$`Infection fatality rate per 1000 Upper bound`)} per 1000<h5/>"))
        } else {
          HTML("<h5>Infection fatality rate per 1000 not available<h5/>")
        }
      })

      # Build the Covid information table from the user profile
      # A separate table of information is supplied to add context
      output$covidtable <- reactable::renderReactable({
        user_profile() %>%
          dplyr::filter(value != 0) %>%
          dplyr::select(group, name, value) %>%
          dplyr::left_join(., Variable_lookup, by = c("name", "group")) %>%
          reactable::reactable(
            striped = T,
            pagination = FALSE,
            columns = list(
              group = reactable::colDef(name = "Group"),
              name = reactable::colDef(name = "Variable", footer = "Total"),
              value = reactable::colDef(name = "Modifier", footer = function(value) sum(value)),
              Information = reactable::colDef(minWidth = 200)
            ),
            defaultColDef = reactable::colDef(footerStyle = list(fontWeight = "bold"))
          )
      })



      # CALCULATE BMI -----------------------------------------------------------

      observeEvent(input$calc_bmi, {
        #
        shiny::showModal(shiny::modalDialog("",

          tabBox(
            title = HTML("<h4>Please input height and weight:</h5>"),
            # The id lets us use input$tabset1 on the server to find the current tab
            id = "bmibox", height = "250px",
            tabPanel(
              "Metric",
              numericInput("bmi_height_met", "Height (m)", value = 1.6, min = 0, max = 4, step = 0.01),
              numericInput("bmi_weight_met", "Weight (kg)", value = 60, min = 0, max = 500)
            ),
            tabPanel(
              "Imperial", h4("Height"),
              column(width = 5, numericInput("bmi_height_imp_ft", "Feet", value = 5, min = 0, max = 9, step = 1)),
              column(width = 5, numericInput("bmi_height_imp_inch", "Inches", value = 0, min = 0, max = 12, step = 0.1)),
              h4("Weight"),
              column(width = 5, numericInput("bmi_weight_imp_st", "Stone", value = 10, min = 0, max = 80)),
              column(width = 5, numericInput("bmi_weight_imp_lb", "Pounds", value = 0, min = 0, max = 14))
            )
          ),
          footer = tagList(
            actionButton("modal_calc", "Calculate"),
            modalButton("Exit")
          )
        ))
      })

      observeEvent(input$modal_calc, {
        # browser()
        if (input$bmibox == "Metric") {
          bmi <- round(input$bmi_weight_met / input$bmi_height_met^2, digits = 2)
        } else if (input$bmibox == "Imperial") {
          height_inch <- (input$bmi_height_imp_ft * 12) + input$bmi_height_imp_inch
          weight_lbs <- (input$bmi_weight_imp_st * 14) + input$bmi_weight_imp_lb

          bmi <- round(703 * (weight_lbs / height_inch^2), digits = 2)
        }



        if (bmi < 30) {
          bmi_round <- "Less than 30"
        }
        else if (bmi < 35) {
          bmi_round <- "30-34.9"
        }
        else if (bmi < 40) {
          bmi_round <- "35-39.9"
        }
        else if (bmi >= 40) {
          bmi_round <- "Greater than or equal to 40"
        }


        output$bmi_print <- renderText(glue::glue("Calculated BMI = {bmi}"))

        shinyWidgets::updatePickerInput(session, "bmi_in", label = "Calculated BMI group", selected = bmi_round)
      })
    }
  