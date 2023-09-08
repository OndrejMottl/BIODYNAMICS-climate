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

data_download_status <-
  get_chelsa_trace21k_urls(
    name = "CHELSA_TraCE21k",
    sel_variables = c("bio", "tasmin"),
    sel_bio = c(1, 6, 12, 15, 18, 19),
    sel_time_var = c(20:-200),
  ) %>%
  download_chelsa_trace21k_data(
    dir = here::here(
      "Data/Temp"
    )
  )

# check the status
data_download_status %>%
  purrr::pluck("status") %>%
  table()


#----------------------------------------------------------#
# 3. Downscale data -----
#----------------------------------------------------------#

future::plan("multisession", workers = parallel::detectCores())

furrr::future_walk(
  .progress = TRUE,
  .x = data_download_status$file_path,
  .f = ~ downscale_tif_data(
    file_path = .x,
    dir = "Data/Processed/Paleoclimate",
    sel_factor = 5,
    only_land = TRUE,
    shapefile_land = shapefile_land,
    fun = "median"
  )
)
