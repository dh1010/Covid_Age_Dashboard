
#' Run Covid age app
#'
#' @return
#' @export
#'
run_app <- function() {
  
  shiny::shinyApp(app_ui, app_server)
}