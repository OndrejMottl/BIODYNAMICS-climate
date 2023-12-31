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
    .f = ~ {
      data_extract <-
        extract_values_from_tif_file(.x)

      file_name <-
        data_extract$var_name %>%
        unique() %>%
        basename()

      sel_var <-
        stringr::str_extract(
          file_name,
          "(?<=CHELSA_TraCE21k_)(.*?)(?=_[-0-9])"
        )

      if (
        sel_var == "tasmin"
      ) {
        sel_var <-
          stringr::str_extract(
            file_name,
            "(?<=CHELSA_TraCE21k_)(.*?)(?=_[-0-9])"
          )

        time_id <-
          stringr::str_extract(
            file_name, "(?<=_)(-?[0-9]+)(?=_V1.0)"
          )
      } else {
        time_id <-
          stringr::str_extract(
            file_name,
            paste0("(?<=_", sel_var, "_)(-?[0-9]+)(?=_V1.0)")
          )
      }

      data_extract %>%
        dplyr::mutate(
          var_name = sel_var,
          time_id = time_id
        ) %>%
        RUtilpol::save_latest_file(
          object_to_save = .,
          file_name = paste0(
            "CHELSA_TraCE21k_",
            sel_var,
            "_",
            time_id
          ),
          dir = here::here(
            "Data/Processed/Paleoclimate/Extracted_values",
            sel_var
          )
        )
    }
  )
