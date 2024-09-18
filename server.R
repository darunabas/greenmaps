function(input, output, session) {
  speciesModuleServer("species")

  biodiversityModuleServer(
    id = "richness",
    biodiversity_function = get_species_richness_data,
    map_legend_title = "Species richness"
  )

  biodiversityModuleServer(
    id = "endemism",
    biodiversity_function = get_w_endemism_data,
    map_legend_title = "Weighted endemism"
  )
}
