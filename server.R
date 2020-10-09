
shinyServer(function(input, output) {
    
  # If nothing is selected in the "other" group change input to "None"
  # This silences errors in the variable matching.
    other <- reactive({
        if(is.null(input$other_in)){
            "None"
        } else{input$other_in}
    })
    
    # Create the user profile based on user input
    user_profile <- reactive({
      
      Risk_data %>%  
        filter(age == input$age_in,
               name == input$sex_in & group == "Sex"|
                 name  == input$eth_in & group == "Ethnicity"|
                 name  == input$bmi_in & group == "BMI"|
                 name  == input$asthma_in & group == "Asthma"|
                 name  == input$diabetes_in & group == "Diabetes"|
                 name  == input$kidney_in & group == "Chronic kidney disease"|
                 name  == input$non_hae_in & group == "Non-haematological cancer"|
                 name == input$heart_in & group == "Heart"|
                 name == input$hae_mal_in & group == "Haematological cancer"|
                 name %in% other() & group == "Other"
        )
    })
    
    # Calculate Covid-age using the user-input
    # This is matched to data provided by the ALAMA group
    # https://alama.org.uk/covid-19-medical-risk-assessment/
    output$covid_age <- renderText({
      
      modifier <-
          user_profile()%>%
            summarise(modifier = sum(value, na.rm = T)) %>%
            pull()
        
        covid_age <- modifier + input$age_in
        
        if (covid_age <= 85){
          as.character(glue::glue("Covid-age: {input$age_in} + {modifier} = {covid_age}"))
        }else if (covid_age > 85){
          as.character(glue::glue("Covid-age: {input$age_in} + {modifier} = 85+"))
        }else{
          "Covid-age not available"
        }
        
        
        
    })
    
    # Build the Covid information table from the user profile
    # A separate table of information is supplied to add context
    output$covidtable <- renderReactable({
        
      user_profile() %>%
            filter(value != 0 ) %>%
            select(group, name, value) %>%
            left_join(., Variable_lookup, by = c("name", "group")) %>%
            reactable(striped = T,
                      pagination = FALSE,
                      columns = list(
                          group = colDef(name = "Group"),
                          name = colDef(name = "Variable", footer = "Total"),
                          value = colDef(name = "Modifier", footer = function(value)  sum(value)),
                          Information = colDef(minWidth = 200)
                      ),
                      defaultColDef = colDef(footerStyle = list(fontWeight = "bold")))
        
    })
    
})
