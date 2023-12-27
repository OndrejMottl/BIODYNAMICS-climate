#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#                crop climate data CHELSA
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

#----------------------------------------------------------#
# 2. Load country shapefile -----
#----------------------------------------------------------#

shapefile_land <-
  sf::st_read(
    here::here(
      "Data/Input/Countries/ne_110m_admin_0_countries.shp"
    )
  )

file_names <-
  list.files(
    here::here(
      "Data/Input/Neoclimate"
    ),
    full.names = TRUE,
    recursive = TRUE,
    pattern = "tif"
  )


#----------------------------------------------------------#
# 3. Downscale data -----
#----------------------------------------------------------#

future::plan("multisession", workers = parallelly::availableCores())

furrr::future_walk(
  .progress = TRUE,
  .x = file_names,
  .f = ~ downscale_and_crop_tif_data(
    file_path = .x,
    dir = here::here("Data/Processed/Neoclimate"),
    sel_factor = 5,
    only_land = TRUE,
    overwrite = TRUE,
    shapefile_land = shapefile_land
  )
)
