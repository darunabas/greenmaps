ras <- terra::rast(system.file("ex/blank20km.tif", package = "greenmaps"))
terra::values(ras) <- paste0("v", seq_len(terra::ncell(ras)))
load(system.file("ex/greenmaps_data.RData", package = "greenmaps"))
#data(greenmaps_data)
species_data <- greenmaps_data$species_data
master_taxa <- greenmaps_data$master_taxa
tdwg <- greenmaps_data$tdwg
#' @title GreenMaps Data
#'
#' @description This dataset consists of three components:
#' - `species_data`: A species community composition matrix in long format
#' showing each species' presence/absence within 20 × 20 km grid cells.
#' - `master_taxa`: A taxonomic table containing species taxonomic attributes
#' at different hierarchies (genus, family, order, clade).
#' - `tdwg`: Corresponds to the position of each grid cell within
#' administrative units as defined by the Taxonomic Diversity Working Group
#' botanical maps.
#'
#' The data includes estimated species-level native distributions for
#' 201,681 vascular plant species at a spatial grain of 5-arc minutes.
#'
#' @section Dataset Components:
#' \itemize{
#'   \item species_data: Species community matrix (presence/absence) in long
#'   format.
#'   \item master_taxa: Taxonomic table (genus, family, order, clade).
#'   \item tdwg: Administrative unit positioning of grid cells (continents,
#'   regions, countries, subdivisions).
#' }
#'
#' @references
#' Daru, B.H. (2024) Predicting undetected native vascular plant diversity at
#' a global scale. \emph{Proceedings of the National Academy of Sciences USA},
#' \strong{121}, e23199891217.
#'
#' @name greenmaps_data
#' @docType data
#' @keywords datasets
#' @examples
#' data(greenmaps_data)
#' names(greenmaps_data)
#' \donttest{
#' table(greenmaps_data$master_taxa$clade)
#' }
NULL


