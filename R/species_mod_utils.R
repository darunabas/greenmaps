SPECIES_STATUS <- c("native", "introduced")
SPECIES_COLOURS <- c("blue", "red")

#' @param species_data species data
#' @param ras blank raster
#' @param species name of the species
get_map_species_data <- function(species_data, ras, species) {
  species <- gsub(" ", "_", species)
  species_data <- species_data[species_data$species %in% species, ]

  validate(
    need(nrow(species_data) > 0,
         paste(species, "not yet in database. Check back later."))
  )

  species_data$status <- factor(species_data$status, levels = SPECIES_STATUS)
  species_data$nativity <- as.numeric(species_data$status)
  index <- match(as.data.frame(ras)[[1]], species_data$grids)
  z <- setValues(ras, species_data$nativity[index])
  z[z <= 0] <- NA
  names(z) <- species
  project(z, "EPSG:4326")
}

create_species_map <- function(species_status) {
  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addRasterImage(
      species_status,
      opacity = 0.8,
      colors = SPECIES_COLOURS
    ) %>%
    setMaxBounds(-180, -90, 180, 90) %>%
    leaflet::addLegend(
      colors = SPECIES_COLOURS,
      labels = tools::toTitleCase(SPECIES_STATUS),
      title = "Status"
    )%>%
    leaflet.extras::addFullscreenControl()
}
