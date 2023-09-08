#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#                Get climate data CHELSA
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
# 1. get {ClimDatDownloadR} -----
#----------------------------------------------------------#

remotes::install_github("HelgeJentsch/ClimDatDownloadR")


#----------------------------------------------------------#
# 1. Download data -----
#----------------------------------------------------------#

library(ClimDatDownloadR)

ClimDatDownloadR::Chelsa.Clim.download(
  # first you'll have to choose your working directory
  save.location = here::here(
    "Data/Input/Neoclimate"
  ),
  # now you'll have to choose parameters.
  # since there is the possibility to download more than one data set
  # the parameters must be a string-vector input.
  # Single parameters, however, can be just put in as a string.
  # the valid parameter inputs can be found in the help (linked s.o.)
  parameter = c("prec", "temp", "tmax", "tmin", "bio"),
  # Now, since you chose "temp" and "bio" as input parameters,
  # you can specify the months and bioclim-variables to download.
  # If you want all of them, just leave the default values.
  # It is crutial, however, that the inputs are integer number values.
  month.var = c(1:12),
  # For Chelsa a newer Version of their climatologies was published in 2019.
  # They still got their old version still hosted on their website.
  bio.var = c(1, 6, 12, 15, 18, 19),
  version.var = "2.1",
  # Now you can choose whether you want the data set clipped
  clipping = FALSE,
  clip.extent = c(-180, 180, -90, 90),
  buffer = 0,
  convert.files.to.asc = TRUE,
  # now you can stack the data ...
  stacking.data = FALSE,
  # ... and choose if you want to combine the raw data in a .zip-file ...
  combine.raw.zip = FALSE,
  # and whether raw data should be deleted.
  delete.raw.data = FALSE,
  save.bib.file = TRUE
)
