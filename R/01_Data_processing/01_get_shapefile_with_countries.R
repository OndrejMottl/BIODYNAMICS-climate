#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#                  Get countries shapefile
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
# 1. Download zip file-----
#----------------------------------------------------------#

download.file(
  paste0(
    "https://www.naturalearthdata.com/",
    "http//www.naturalearthdata.com/download/110m/cultural/",
    "ne_110m_admin_0_countries.zip"
  ),
  here::here(
    "Data/Input/Countries/countries.zip"
  )
)

#----------------------------------------------------------#
# 2. Unzip -----
#----------------------------------------------------------#

unzip(
  here::here(
    "Data/Input/Countries/countries.zip"
  ),
  exdir = here::here("Data/Input/Countries")
)
