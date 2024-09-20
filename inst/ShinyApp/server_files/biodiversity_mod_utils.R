NATIVITY <- stats::setNames(
  c("all", "native", "introduced"),
  c("All", "Native", "Introduced")
)

REGIONS <- stats::setNames(
  c("all", "level1_name", "level2_name", "level3_name", "level4_name"),
  c("Global", "Continental", "Regional", "National", "National Regions")
)

TAXONS <- stats::setNames(
  c("all", "family", "order", "clade"),
  c("N/A", "Family", "Order", "Clade")
)

BIODIVERSITY_COLOURS <- grDevices::hcl.colors(n=255, palette = "viridis")

#' @param species_data species data
#' @param ras blank raster
#' @param tdwg botanical geographic extents; global, regional, country, state
#' @param mlist master list of plant species
#' @param nativity whether to subset by "native" or "introduced" species
#' @param geoscale works with tdwg and can be any of "level1_name",
#' "level2_name", "level3_name", "level4_name"
#' @param region_name specifying the exact region to subset based on geoscale
#' @param taxo_rank refers to the major plant taxonomic ranks such as:
#' "family", "order", "clade"
#' @param taxon the exact taxon to subset based on taxo_rank
#' @importFrom terra setValues project
#' @importFrom phyloregion weighted_endemism
#' @importFrom shiny validate need
#' @importFrom leaflet colorNumeric leaflet addTiles addRasterImage addLegend
#' @importFrom magrittr %>%
#' @author Barnabas Daru <darunabas@@gmail.com>
#' @export
get_species_richness_data <- function(species_data, ras, tdwg, mlist,
                                      nativity = c("all", "native", "introduced"),
                                      geoscale = c("all", "level1_name",
                                                   "level2_name", "level3_name",
                                                   "level4_name"),
                                      region_name = NULL,
                                      taxo_rank = c("all", "family", "order",
                                                    "clade"), taxon = NULL) {
  p <- extract_biodiversity_data(species_data, ras, tdwg, mlist, nativity,
                                 geoscale, region_name, taxo_rank, taxon)

  m <- data.frame(table(p$grids))
  names(m) <- c("grids", "richness")
  index <- match(as.data.frame(ras)[[1]], m$grids)
  z <- terra::setValues(ras, m$richness[index])
  z[z <= 0] <- NA
  names(z) <- "richness"
  terra::project(z, "EPSG:4326")
}

#' @export
get_w_endemism_data <- function(species_data, ras, tdwg, mlist,
                                nativity = c("all", "native", "introduced"),
                                geoscale = c("all", "level1_name", "level2_name",
                                             "level3_name", "level4_name"),
                                region_name = NULL,
                                taxo_rank = c("all", "family", "order", "clade"),
                                taxon = NULL) {
  p <- extract_biodiversity_data(species_data, ras, tdwg, mlist, nativity,
                                 geoscale, region_name, taxo_rank, taxon)

  m <- phyloregion::weighted_endemism(phyloregion::long2sparse(p))
  index <- match(as.data.frame(ras)[[1]], names(m))
  z <- terra::setValues(ras, m[index])
  z[z <= 0] <- NA
  names(z) <- "endemism"
  terra::project(z, "EPSG:4326")
}

#' @export
extract_biodiversity_data <- function(species_data, ras, tdwg, mlist,
                                      nativity = c("all", "native", "introduced"),
                                      geoscale = c("all", "level1_name",
                                                   "level2_name", "level3_name",
                                                   "level4_name"),
                                      region_name = NULL,
                                      taxo_rank = c("all", "family", "order",
                                                    "clade"), taxon = NULL) {
  nativity <- match.arg(nativity)
  geoscale <- match.arg(geoscale)
  taxo_rank <- match.arg(taxo_rank)

  shiny::validate(
    shiny::need(geoscale == "all" || !(is.null(region_name) || region_name == ""),
         "Region name not selected"),
    shiny::need(taxo_rank == "all" || !(is.null(taxon) || taxon == ""),
         "Taxonomic name not selected")
  )

  if (nativity != "all") {
    species_data <- species_data[species_data$status %in% nativity, ]
  }

  species_data <- cbind(
    species_data,
    mlist[match(species_data$species, mlist$species),
          setdiff(names(mlist), "species")]
  )
  species_data <- cbind(
    species_data,
    tdwg[match(species_data$grids, tdwg$grids), setdiff(names(tdwg), "grids")]
  )

  if (geoscale != "all") {
    species_data <- species_data[species_data[[geoscale]] %in% region_name, ]
  }
  if (taxo_rank != "all") {
    species_data <- species_data[species_data[[taxo_rank]] %in% taxon, ]
  }

  shiny::validate(
    shiny::need(nrow(species_data) > 0, "No biodiversity found for selected filters")
  )

  species_data[, c("grids", "species")]
}

#' @export
create_biodiversity_map <- function(biodiversity_data, legend_title = "") {
  pal <- leaflet::colorNumeric(BIODIVERSITY_COLOURS,
                               terra::values(biodiversity_data),
                               na.color = "transparent")
  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addRasterImage(
      biodiversity_data,
      colors = BIODIVERSITY_COLOURS,
      opacity = 0.8
    ) %>%
    leaflet::addLegend(
      pal = pal,
      values = terra::values(biodiversity_data),
      title = legend_title
    )
}
