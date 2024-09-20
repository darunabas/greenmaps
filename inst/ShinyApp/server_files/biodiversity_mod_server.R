#' @title Run \emph{GreenMaps}
#' @rdname biodiversityModuleServer
#' @importFrom shiny observeEvent updateSelectizeInput validate need req
#' @importFrom shiny reactive
#' @importFrom leaflet renderLeaflet
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
biodiversityModuleServer <- function(id, biodiversity_function, map_legend_title) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      shiny::observeEvent(input$region_level, {
        if (input$region_level != "all") {
          shiny::updateSelectizeInput(
            session,
            "region_name",
            choices = sort(unique(tdwg[[input$region_level]])),
            selected = "",
            server = TRUE
        )
        }
      })

      shiny::observeEvent(input$taxon_group, {
        if (input$taxon_group != "all") {
          shiny::updateSelectizeInput(
            session,
            "taxon_name",
            choices = sort(unique(master_taxa[[input$taxon_group]])),
            selected = "",
            server = TRUE,
            options = list(
              placeholder = paste0("Select ", input$taxon_group, "...")
            )
          )
        }
      })

      biodiversity_range <- shiny::reactive({
        shiny::validate(
          shiny::need(input$region_level == "all" || input$region_name != "",
               "Region name not selected"),
          shiny::need(input$taxon_group == "all" || input$taxon_name != "",
               "Taxonomic name not selected")
        )

        biodiversity_function(
          species_data = species_data,
          ras = ras,
          mlist = master_taxa,
          tdwg = tdwg,
          nativity = input$nativity,
          taxo_rank = input$taxon_group,
          geoscale = input$region_level,
          region_name = input$region_name,
          taxon = input$taxon_name
        )
      })

      output$map <- leaflet::renderLeaflet({
        shiny::req(biodiversity_range())
        create_biodiversity_map(
          biodiversity_data = biodiversity_range(),
          legend_title = map_legend_title
        )
      })
    }
  )
}
