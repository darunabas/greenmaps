#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL


SPECIES_STATUS <- c("native", "introduced")
SPECIES_COLOURS <- c("blue", "red")

#' @rdname get_map_species_data
#' @param species_data species data
#' @param ras blank raster
#' @param species name of the species
#' @importFrom shiny validate need
#' @importFrom terra setValues project
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
get_map_species_data <- function(species_data, ras, species) {
  species <- gsub(" ", "_", species)
  species_data <- species_data[species_data$species %in% species, ]

  shiny::validate(
    shiny::need(nrow(species_data) > 0,
         paste(species, "not yet in database. Check back later."))
  )

  species_data$status <- factor(species_data$status, levels = SPECIES_STATUS)
  species_data$nativity <- as.numeric(species_data$status)
  index <- match(as.data.frame(ras)[[1]], species_data$grids)
  z <- terra::setValues(ras, species_data$nativity[index])
  z[z <= 0] <- NA
  names(z) <- species
  terra::project(z, "EPSG:4326")
}

#' @rdname create_species_map
#' @param species_status Nativity status of the species, whether native or
#' @importFrom leaflet leaflet addTiles addRasterImage setMaxBounds
#' @importFrom terra setValues project ext
#' introduced
#' @export
create_species_map <- function(species_status) {
  #e <- as.vector(terra::ext(species_status)) |> as.vector()
  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addRasterImage(
      species_status,
      opacity = 0.8,
      colors = SPECIES_COLOURS
    ) %>%
    #leaflet::setMaxBounds(
    #  lng1 = e[1],  lat1 = e[3],  lng2 = e[2], lat2 = e[4]
    #) %>%
    leaflet::addLegend(
      colors = SPECIES_COLOURS,
      labels = tools::toTitleCase(SPECIES_STATUS),
      title = "Status"
    ) %>%
    leaflet.extras::addFullscreenControl()
}


