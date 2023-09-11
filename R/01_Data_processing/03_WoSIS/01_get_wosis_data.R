#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#                     Get WoSIS data
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
# 1. Download data -----
#----------------------------------------------------------#

wosis_web_path <-
  paste0(
    "https://s3.eu-west-1.amazonaws.com/",
    "data.gaezdev.aws.fao.org/"
  )

# get raster
download.file(
  paste0(
    wosis_web_path,
    "HWSD/HWSD2_RASTER.zip"
  ),
  here::here(
    "Data/Input/WoSIS/wosis_raster.zip"
  )
)

# get database
download.file(
  paste0(
    wosis_web_path,
    "HWSD/HWSD2_DB.zip"
  ),
  here::here(
    "Data/Input/WoSIS/wosis_db.zip"
  )
)

# unzip both
purrr::walk(
  .x = c("wosis_raster.zip", "wosis_db.zip"),
  .f = ~ unzip(
    here::here(
      here::here(
        "Data/Input/WoSIS/", .x
      ),
      exdir = here::here("Data/Input/WoSIS")
    )
  )
)

#----------------------------------------------------------#
# 2. Get soil type names from database ----
#----------------------------------------------------------#

library(DBI)
library(odbc)
library(dbplyr)

wosis_db <-
  DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0(
      "Driver={Microsoft Access Driver (*.mdb, *.accdb)};",
      paste0(
        "DBQ=",
        here::here(
          "Data/Input/WoSIS/HWSD2.mdb"
        )
      )
    )
  )

dbListTables(wosis_db)

data_soil_names <-
  dplyr::tbl(wosis_db, "D_WRB4") %>%
  dplyr::select(-ID) %>%
  dplyr::distinct()

data_soil_types <-
  dplyr::tbl(wosis_db, "HWSD2_SMU") %>%
  dplyr::select(HWSD2_SMU_ID, WRB2) %>%
  dplyr::distinct()

data_soil_name_types <-
  data_soil_types %>%
  dplyr::left_join(
    data_soil_names,
    by = dplyr::join_by("WRB2" == "CODE")
  ) %>%
  dplyr::select(HWSD2_SMU_ID, VALUE) %>%
  dplyr::collect()

DBI::dbDisconnect(wosis_db)

data_soil_name_types_integer <-
  data_soil_name_types %>%
  dplyr::mutate(
    VALUE = as.factor(VALUE) %>%
      as.numeric() %>%
      as.integer()
  )


#----------------------------------------------------------#
# 3. Add soil type names to raster ----
#----------------------------------------------------------#

wosis_raster <-
  terra::rast(
    here::here(
      "Data/Input/WoSIS/HWSD2.bil"
    )
  )

wosis_raster_class <-
  terra::classify(wosis_raster, data_soil_name_types_integer)


terra::writeRaster(
  wosis_raster_class,
  here::here(
    "Data/Processed/WoSIS/wosis_raster.tif"
  )
)
