source("server_files/biodiversity_mod_ui.R")
source("server_files/biodiversity_mod_server.R")
source("server_files/biodiversity_mod_utils.R")
source("server_files/species_mod_server.R")
source("server_files/species_mod_ui.R")
source("server_files/species_mod_utils.R")
source("server_files/datasets.R")

shiny::navbarPage(
  title = shiny::tags$img(class = "header-logo", src = "logo.png", alt = "Green Maps"),
  windowTitle = "GreenMaps",

  header = tagList(
    shiny::tags$head(
      shiny::tags$link(rel = "stylesheet", href = "greenmaps_style.css"),
      shinyjs::useShinyjs()
    )
  ),

  shiny::tabPanel(
    "Species Maps",
    speciesModuleUI("species")
  ),
  shiny::navbarMenu(
    "Biodiversity Maps",
    shiny::tabPanel(
      "Species Richness",
      biodiversityModuleUI(
        "richness",
        header = "Species Richness"
      )
    ),
    shiny::tabPanel(
      "Weighted Endemism",
      biodiversityModuleUI(
        "endemism",
        header = "Weighted Endemism"
      )
    )
  )
)
