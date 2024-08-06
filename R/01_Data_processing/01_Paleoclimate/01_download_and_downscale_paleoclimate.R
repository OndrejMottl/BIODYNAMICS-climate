#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#                  Get paleo climate
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
# 2. Download selected data -----
#----------------------------------------------------------#

# In order to same time, we only download the data of each 500 years
#   between 0 and 18,000 years before present (BP)
sel_time_id <-
  tibble::tibble(
    time_id = 20:-200,
    age = (-time_id * 100) + 2000
  ) %>%
  dplyr::filter(
    age %in% seq(0, 18e3, 500)
  ) %>%
  purrr::chuck("time_id")

data_download_status <-
  get_chelsa_trace21k_urls(
    name = "CHELSA_TraCE21k",
    sel_variables = c("bio"),
    # bio1 == Annual Mean Temperature
    # bio4 == Temperature Seasonality
    # bio6 == Min Temperature of Coldest Month
    # bio12 == Annual Precipitation
    # bio15 == Precipitation Seasonality
    # bio18 == Precipitation of Wettest Month
    # bio19 == Precipitation of Driest Month
    sel_bio = c(1, 4, 6, 12, 15, 18, 19),
    sel_time_var = sel_time_id,
  ) %>%
  download_chelsa_trace21k_data(
    dir = here::here(
      "Data/Input/Paleoclimate"
    )
  )

# check the status
data_download_status %>%
  purrr::pluck("status") %>%
  table()

#----------------------------------------------------------#
# 3. Downscale data -----
#----------------------------------------------------------#

future::plan("multisession", workers = parallelly::availableCores() - 1)

furrr::future_walk(
  .progress = TRUE,
  .x = data_download_status$file_path,
  .f = ~ downscale_and_crop_tif_data(
    file_path = .x,
    dir = here::here("Data/Processed/Paleoclimate"),
    sel_factor = 25,
    only_land = FALSE,
    shapefile_land = shapefile_land,
    fun = "median",
    overwrite = rewrite_files
  )
)
