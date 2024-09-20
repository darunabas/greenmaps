#' @importFrom shiny NS sidebarLayout sidebarPanel selectizeInput conditionalPanel  req
#' @importFrom shiny mainPanel h2 need
#' @importFrom shinycssloaders withSpinner
#' @importFrom leaflet leafletOutput
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
biodiversityModuleUI <- function(id, header = "") {
  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      width = 3,
      shiny::selectizeInput(
        ns("nativity"),
        "Nativity:",
        choices = NATIVITY
      ),

      shiny::selectizeInput(
        ns("region_level"),
        "Geographic Region:",
        choices = REGIONS
      ),
      shiny::conditionalPanel(
        condition = "input.region_level !== 'all'",
        ns = ns,
        shiny::selectizeInput(
          ns("region_name"),
          label = NULL,
          choices = NULL,
          options = list(
            placeholder = "Search region..."
          )
        )
      ),

      shiny::selectizeInput(
        ns("taxon_group"),
        "Taxonomic Group:",
        choices = TAXONS
      ),
      shiny::conditionalPanel(
        condition = "input.taxon_group !== 'all'",
        ns = ns,
        shiny::selectizeInput(
          ns("taxon_name"),
          label = NULL,
          choices = NULL,
          options = list(
            placeholder = "Select family..."
          )
        )
      )
    ),
    shiny::mainPanel(
      shiny::h2(class = "species-header", header),
      shinycssloaders::withSpinner(
        leaflet::leafletOutput(ns("map"), height = "600px"),
        type = 7
      )
    )
  )
}
