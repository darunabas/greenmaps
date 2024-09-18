biodiversityModuleUI <- function(id, header = "") {
  ns <- NS(id)

  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectizeInput(
        ns("nativity"),
        "Nativity:",
        choices = NATIVITY
      ),

      selectizeInput(
        ns("region_level"),
        "Geographic Region:",
        choices = REGIONS
      ),
      conditionalPanel(
        condition = "input.region_level !== 'all'",
        ns = ns,
        selectizeInput(
          ns("region_name"),
          label = NULL,
          choices = NULL,
          options = list(
            placeholder = "Search region..."
          )
        )
      ),

      selectizeInput(
        ns("taxon_group"),
        "Taxonomic Group:",
        choices = TAXONS
      ),
      conditionalPanel(
        condition = "input.taxon_group !== 'all'",
        ns = ns,
        selectizeInput(
          ns("taxon_name"),
          label = NULL,
          choices = NULL,
          options = list(
            placeholder = "Select family..."
          )
        )
      )
    ),
    mainPanel(
      h2(class = "species-header", header),
      shinycssloaders::withSpinner(
        leaflet::leafletOutput(ns("map"), height = "600px"),
        type = 7
      )
    )
  )
}
