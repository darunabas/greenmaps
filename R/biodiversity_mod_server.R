biodiversityModuleServer <- function(id, biodiversity_function, map_legend_title) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$region_level, {
        if (input$region_level != "all") {
          updateSelectizeInput(
            session,
            "region_name",
            choices = sort(unique(tdwg[[input$region_level]])),
            selected = "",
            server = TRUE
        )
        }
      })

      observeEvent(input$taxon_group, {
        if (input$taxon_group != "all") {
          updateSelectizeInput(
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

      biodiversity_range <- reactive({
        validate(
          need(input$region_level == "all" || input$region_name != "", "Region name not selected"),
          need(input$taxon_group == "all" || input$taxon_name != "", "Taxonomic name not selected")
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
        req(biodiversity_range())
        create_biodiversity_map(
          biodiversity_data = biodiversity_range(),
          legend_title = map_legend_title
        )
      })
    }
  )
}
