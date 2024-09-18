navbarPage(
  title = tags$img(class = "header-logo", src = "logo.png", alt = "Green Maps"),
  windowTitle = "GreenMaps",

  header = tagList(
    tags$head(
      tags$link(rel = "stylesheet", href = "greenmaps_style.css"),
      shinyjs::useShinyjs()
    )
  ),

  tabPanel(
    "Species Maps",
    speciesModuleUI("species")
  ),
  navbarMenu(
    "Biodiversity Maps",
    tabPanel(
      "Species Richness",
      biodiversityModuleUI(
        "richness",
        header = "Species Richness"
      )
    ),
    tabPanel(
      "Weighted Endemism",
      biodiversityModuleUI(
        "endemism",
        header = "Weighted Endemism"
      )
    )
  )
)
