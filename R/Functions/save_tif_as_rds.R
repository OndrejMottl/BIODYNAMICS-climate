save_tif_as_rds <- function(
    file_path, save_dir,
    model_name = c(
      "CHELSA_TraCE21k",
      "CHELSA"
    ),
    save_into_subfolders = FALSE,
    rewrite_files = FALSE) {
  model_name <- match.arg(model_name)

  file_name <-
    basename(file_path)

  if (
    model_name == "CHELSA_TraCE21k"
  ) {
    sel_var <-
      stringr::str_extract(
        file_name,
        paste0("(?<=", model_name, "_)(.*?)(?=_[-0-9])")
      )

    if (
      stringr::str_detect(
        sel_var,
        "bio",
        negate = TRUE
      )
    ) {
      sel_var <-
        stringr::str_extract(
          file_name,
          paste0("(?<=", model_name, "_)(.*?)(?=_[-0-9])")
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

    # detect if file already exists
    latest_file_name <-
      RUtilpol::get_latest_file_name(
        file_name = paste0(
          model_name,
          "_",
          sel_var,
          "_",
          time_id
        ),
        dir = here::here(
          save_dir,
          ifelse(
            save_into_subfolders,
            sel_var,
            ""
          )
        )
      )

    if (
      isFALSE(is.na(latest_file_name)) &&
        isFALSE(rewrite_files)
    ) {
      return(invisible())
    }

    extract_values_from_tif_file(file_path) %>%
      dplyr::mutate(
        var_name = sel_var,
        time_id = time_id
      ) %>%
      RUtilpol::save_latest_file(
        object_to_save = .,
        file_name = paste0(
          "", model_name, "_",
          sel_var,
          "_",
          time_id
        ),
        dir = here::here(
          save_dir,
          ifelse(
            save_into_subfolders,
            sel_var,
            ""
          )
        )
      )

    return(invisible())
  }

  sel_var <-
    stringr::str_extract(
      file_name,
      paste0("(?<=", model_name, "_)(.*?)(?=_1981)")
    )

  # detect if file already exists
  latest_file_name <-
    RUtilpol::get_latest_file_name(
      file_name = paste0(
        model_name,
        "_",
        sel_var
      ),
      dir = here::here(
        save_dir,
        ifelse(
          save_into_subfolders,
          sel_var,
          ""
        )
      )
    )

  if (
    isFALSE(is.na(latest_file_name)) &&
      isFALSE(rewrite_files)
  ) {
    return(invisible())
  }

  extract_values_from_tif_file(file_path) %>%
    dplyr::mutate(
      var_name = sel_var
    ) %>%
    RUtilpol::save_latest_file(
      object_to_save = .,
      file_name = paste0(
        "", model_name, "_",
        sel_var
      ),
      dir = here::here(
        save_dir,
        ifelse(
          save_into_subfolders,
          sel_var,
          ""
        )
      )
    )

  return(invisible())
}
