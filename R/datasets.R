#Datasets
ras <- terra::rast("data/blank20km.tif")
values(ras) <- paste0("v", seq_len(ncell(ras)))

species_data <- read.csv("data/greenmaps_presab_subset.csv")
master_taxa <- read.csv("data/MASTER_TAXA_list.csv")
tdwg <- read.csv("data/TDWG_50km.csv")
