speciesModuleUI <- function(id) {
  ns <- NS(id)

  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectizeInput(
        ns("species"),
        "Species:",
        choices = NULL,
        options = list(
          placeholder = "Search species..."
        )
      ),
      div(
        tags$b("Family:"),
        textOutput(ns("family"), inline = TRUE)
      ),
      div(
        tags$b("Order:"),
        textOutput(ns("order"), inline = TRUE)
      )
    ),

    mainPanel(
      width = 9,
      h2(
        class = "species-header",
        "Predicted native range",
        textOutput(ns("species_name"), inline = TRUE)
      ),
      shinycssloaders::withSpinner(
        leaflet::leafletOutput(ns("map"), height = "600px"),
        type = 7
      )
    )
  )
}
