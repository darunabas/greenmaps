#' @rdname speciesModuleServer
#' @param id Identification feature
#' @importFrom shiny validate reactive
#' @importFrom shiny moduleServer observe updateSelectizeInput req renderText
#' @importFrom leaflet renderLeaflet
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
speciesModuleServer <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      shiny::observe({
        shiny::updateSelectizeInput(
          session,
          "species",
          choices = stats::setNames(
            master_taxa$species,
            gsub("_", " ", master_taxa$species)
          ),
          selected = "",
          server = TRUE
        )
      })

      output$species_name <- shiny::renderText({
        shiny::req(input$species)
        paste("for", gsub("_", " ", input$species))
      })

      output$family <- shiny::renderText({
        shiny::req(input$species)
        master_taxa$family[master_taxa$species == input$species]
      })

      output$order <- shiny::renderText({
        shiny::req(input$species)
        master_taxa$order[master_taxa$species == input$species]
      })

      species_status <- shiny::reactive({
        shiny::validate(
          shiny::need(input$species != "", "Search for a species to display map")
        )

        get_map_species_data(
          species_data = species_data,
          ras = ras,
          species = input$species
        )
      })

      output$map <- leaflet::renderLeaflet({
        create_species_map(species_status = species_status())
      })
    }
  )
}
