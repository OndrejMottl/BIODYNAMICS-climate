#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#              Extract WOSIS data and save to QS
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
# 1. Load data and extract data -----
#----------------------------------------------------------#

data_wosis <-
  extract_values_from_tif_file(
    here::here(
      "Data/Processed/WoSIS/downscaled/wosis_raster.tif"
    )
  )

#----------------------------------------------------------#
# 2. save in QS -----
#----------------------------------------------------------#

RUtilpol::save_latest_file(
  object_to_save = data_wosis,
  file_name = "wosis_data",
  dir = here::here(
    "Outputs/Data/WoSIS"
  ),
  prefered_format = "qs",
  preset = "archive"
)
