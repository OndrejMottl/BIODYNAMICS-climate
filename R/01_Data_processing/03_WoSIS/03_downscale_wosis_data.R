#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#            crop and downscalce data WoSIS
#
#
#                       O. Mottl
#                         2023
#
#----------------------------------------------------------#

#----------------------------------------------------------#
# 0. Setup -----
#----------------------------------------------------------#

library(here)

# Load configuration
source(
  here::here(
    "R/00_Config_file.R"
  )
)

rewrite_files <- FALSE

#----------------------------------------------------------#
# 2. Load country shapefile -----
#----------------------------------------------------------#

shapefile_land <-
  sf::st_read(
    here::here(
      "Data/Input/Countries/ne_110m_admin_0_countries.shp"
    )
  )


#----------------------------------------------------------#
# 3. Downscale data -----
#----------------------------------------------------------#

downscale_and_crop_tif_data(
  file_path = here::here(
    "Data/Processed/WoSIS/resampled/wosis_raster.tif"
  ),
  dir = here::here("Data/Processed/WoSIS/downscaled"),
  sel_factor = 25,
  fun = "modal",
  only_land = FALSE,
  overwrite = rewrite_files,
  shapefile_land = shapefile_land
)
