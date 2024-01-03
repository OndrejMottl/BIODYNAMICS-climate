#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#              Merge Palaeoclimate data to QS
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
# 1. Load data -----
#----------------------------------------------------------#

file_names <-
  list.files(
    here::here(
      "Data/Processed/Neoclimate/Extracted_values"
    ),
    full.names = TRUE,
    recursive = TRUE,
    pattern = "rds"
  )


#----------------------------------------------------------#
# 2. Load data and save in QS -----
#----------------------------------------------------------#

purrr::walk(
  .progress = TRUE,
  .x = file_names,
  .f = ~ RUtilpol::get_latest_file(
    file_name = .x %>%
      basename() %>%
      RUtilpol::get_clean_name(),
    dir = here::here(
      "Data/Processed/Neoclimate/Extracted_values"
    )
  ) %>%
    RUtilpol::save_latest_file(
      object_to_save = .,
      file_name = .x %>%
        basename() %>%
        RUtilpol::get_clean_name(),
      dir = here::here(
        "Outputs/Data/Neoclimate"
      ),
      prefered_format = "qs",
      preset = "archive"
    )
)
