#' @title A function to download all the selected palaeoclimatic variables from CHELSA
#' @description This function download, extract, and delete downloaded tif files so they do not fill up storage space
#' @return A tibble with the meta data, and climatic data for all locations in extract data
download_chelsa_trace21k_data <- function(data_source,
                                          dir = here::here(),
                                          skip_existing = TRUE,
                                          sel_method = "curl") {
  vec_models <- c("1", "2", "12")

  data_source <-
    data_source %>%
    dplyr::mutate(
      file_path = paste0(dir, "/", basename(file)),
      status = "incomplete"
    )

  if (
    isTRUE(skip_existing)
  ) {
    # previously-failed downloads have small file size
    data_source <-
      data_source %>%
      dplyr::mutate(
        status = purrr::map2_chr(
          .progress = "Checking previous downloads",
          .x = file_path,
          .y = status,
          .f = ~ {
            sel_path <- .x

            paths <-
              purrr::map_chr(
                .x = vec_models,
                .f = ~ stringr::str_replace(sel_path, "\\*", .x)
              )

            size <- file.size(paths)

            if (
              any(!is.na(size) & log(size) > 10)
            ) {
              return("already downloaded")
            }

            return(.y)
          }
        )
      )
  }

  data_select_status <-
    data_source %>%
    dplyr::mutate(
      status = purrr::pmap_chr(
        .progress = "Dowloading data",
        .l = list(
          status,
          file_path,
          url
        ),
        .f = ~ {
          if (..1 == "already downloaded") {
            return(..1)
          }

          sel_path <- ..2
          sel_url <- ..3

          purrr::walk(
            .x = vec_models,
            .f = ~ {
              if (
                file.exists(sel_path)
              ) {
                return()
              }

              url_sub <- stringr::str_replace(sel_url, "\\*", .x)
              path_sub <- stringr::str_replace(sel_path, "\\*", .x)
              test_download <-
                try(
                  download.file(
                    url = url_sub,
                    destfile = path_sub,
                    method = sel_method,
                    quiet = TRUE
                  ),
                  silent = TRUE
                )

              size <- file.size(path_sub)

              if (
                !is.na(size) & log(size) > 10
              ) {
                return()
              }
              file.remove(path_sub)
            }
          )

          if (
            file.exists(sel_path)
          ) {
            return("download completed")
          }
          return("download failed")
        }
      )
    )

  return(data_select_status)
}
