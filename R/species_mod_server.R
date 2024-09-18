speciesModuleServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      observe({
        updateSelectizeInput(
          session,
          "species",
          choices = setNames(
            master_taxa$species,
            gsub("_", " ", master_taxa$species)
          ),
          selected = "",
          server = TRUE
        )
      })

      output$species_name <- renderText({
        req(input$species)
        paste("for", gsub("_", " ", input$species))
      })

      output$family <- renderText({
        req(input$species)
        master_taxa$family[master_taxa$species == input$species]
      })

      output$order <- renderText({
        req(input$species)
        master_taxa$order[master_taxa$species == input$species]
      })

      species_status <- reactive({
        validate(
          need(input$species != "", "Search for a species to display map")
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
