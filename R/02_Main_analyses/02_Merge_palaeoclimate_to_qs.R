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
      "Data/Processed/Paleoclimate"
    ),
    full.names = TRUE,
    recursive = TRUE,
    pattern = "tif"
  )

#----------------------------------------------------------#
# 2. Load data and save agin in 5 batches -----
#----------------------------------------------------------#

vec_var_names <-
  stringr::str_extract(
    basename(file_names),
    "(?<=CHELSA_TraCE21k_)(.*?)(?=_[-0-9])"
  ) %>%
  unique()

purrr::walk(
  .x = vec_var_names,
  .f = ~ {
    sel_var <- .x

    message("Processing variable: ", sel_var)

    data_sel_var <-
      stringr::str_subset(
        basename(file_names),
        .x
      ) %>%
      stringr::str_replace(., "_V1.0.tif", "") %>%
      purrr::map(
        .f = ~ RUtilpol::get_latest_file(
          file_name = .x,
          dir = here::here(
            "Data/Processed/Paleoclimate/Extracted_values",
            sel_var
          )
        )
      ) %>%
      dplyr::bind_rows() %>%
      dplyr::select(-var_name)

    save_in_batches(
      data_source = data_sel_var,
      n_batches = 3,
      file_name = sel_var,
      dir = here::here(
        "Outputs/Data/Palaoclimate"
      ),
      prefered_format = "qs",
      preset = "archive"
    )
  }
)
