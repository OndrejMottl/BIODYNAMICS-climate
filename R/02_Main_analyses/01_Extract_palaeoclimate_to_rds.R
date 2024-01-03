#----------------------------------------------------------#
#
#
#                     Abiotic data
#
#            Extract Palaeoclimate data to RDS
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
      "Data/Processed/Paleoclimate"
    ),
    full.names = TRUE,
    recursive = TRUE,
    pattern = "tif"
  )

#----------------------------------------------------------#
# 2. Create folders to extract data into -----
#----------------------------------------------------------#

vec_var_names <-
  stringr::str_extract(
    basename(file_names),
    "(?<=CHELSA_TraCE21k_)(.*?)(?=_[-0-9])"
  ) %>%
  unique()

vec_var_names %>%
  purrr::walk(
    .f = ~ dir.create(
      here::here(
        "Data/Processed/Paleoclimate/Extracted_values",
        .x
      ),
      recursive = TRUE,
      showWarnings = FALSE
    )
  )


#----------------------------------------------------------#
# 3. Extract all values from tif files -----
#----------------------------------------------------------#

future::plan("multisession", workers = parallelly::availableCores)

file_names %>%
  furrr::future_walk(
    .progress = TRUE,
    .f = ~ save_tif_as_rds(
      file_path = .x,
      save_dir = here::here(
        "Data/Processed/Paleoclimate/Extracted_values"
      ),
      model_name = "CHELSA_TraCE21k",
      save_into_subfolders = TRUE,
      rewrite_files = rewrite_files
    )
  )
