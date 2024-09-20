#' @rdname speciesModuleUI
#' @param id Identification feature
#' @importFrom shiny tags textOutput sidebarLayout sidebarPanel div mainPanel h2
#' @importFrom shinycssloaders withSpinner
#' @importFrom leaflet leafletOutput
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
speciesModuleUI <- function(id) {
  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      width = 3,
      shiny::selectizeInput(
        ns("species"),
        "Species:",
        choices = NULL,
        options = list(
          placeholder = "Search species..."
        )
      ),
      shiny::div(
        shiny::tags$b("Family:"),
        shiny::textOutput(ns("family"), inline = TRUE)
      ),
      shiny::div(
        shiny::tags$b("Order:"),
        shiny::textOutput(ns("order"), inline = TRUE)
      )
    ),

    shiny::mainPanel(
      width = 9,
      shiny::h2(
        class = "species-header",
        "Predicted native range",
        shiny::textOutput(ns("species_name"), inline = TRUE)
      ),
      shinycssloaders::withSpinner(
        leaflet::leafletOutput(ns("map"), height = "600px"),
        type = 7
      )
    )
  )
}
