#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#            Resample WoSIS data to
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
# 1. load data -----
#----------------------------------------------------------#

raster_wosis <-
  terra::rast(
    here::here(
      "Data/Processed/WoSIS/wosis_raster.tif"
    )
  )

raster_template <-
  terra::rast(
    here::here(
      "Data/Input/Neoclimate/bio/",
      "ChelsaV2.1Climatologies/CHELSA_bio_01_1981-2010_V2.1.tif"
    )
  )

#----------------------------------------------------------#
# 3. Resample -----
#----------------------------------------------------------#

raster_wosis_resampled <-
  terra::resample(
    raster_wosis,
    raster_template,
    method = "near",
    threads = TRUE
  )

# check that the resampling worked

assertthat::assert_that(
  identical(
    terra::res(raster_wosis_resampled),
    terra::res(raster_template)
  ),
  msg = "Resolutions do not match"
)


assertthat::assert_that(
  identical(
    terra::origin(raster_wosis_resampled),
    terra::origin(raster_template)
  ),
  msg = "Origin do not match"
)

#----------------------------------------------------------#
# 4. Save -----
#----------------------------------------------------------#

terra::writeRaster(
  x = raster_wosis_resampled,
  overwrite = rewrite_files,
  filename = here::here(
    "Data/Processed/WoSIS/resampled/",
    "wosis_raster.tif"
  )
)
