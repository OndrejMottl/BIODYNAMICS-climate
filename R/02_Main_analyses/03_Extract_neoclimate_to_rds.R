#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#            Extract Neooclimate data to RDS
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
# 1. Load data -----
#----------------------------------------------------------#

file_names <-
  list.files(
    here::here(
      "Data/Processed/Neoclimate"
    ),
    full.names = TRUE,
    recursive = TRUE,
    pattern = "tif"
  )


#----------------------------------------------------------#
# 2. Extract all values from tif files -----
#----------------------------------------------------------#

file_names %>%
  purrr::walk(
    .progress = TRUE,
    .f = ~ save_tif_as_rds(
      file_path = .x,
      save_dir = here::here(
        "Data/Processed/Neoclimate/Extracted_values"
      ),
      model_name = "CHELSA",
      save_into_subfolders = FALSE,
      rewrite_files = rewrite_files
    )
  )
