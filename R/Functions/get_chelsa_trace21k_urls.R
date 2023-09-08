#' @title A function to select palaeoclimatic variables from CHELSA
#' @description This function create a tibble of palaeoclimatic variables, file names, and urls
#' @return A tibble to be used with the_get chelsa_download function
get_chelsa_trace21k_urls <- function(sel_variables = c("bio", "tasmin", "tasmax", "pr"),
                                     name = "CHELSA_TraCE21k",
                                     sel_bio_var = c(1:19),
                                     month_var = c(1:12),
                                     sel_time_var = c(20:-220)) {
  base_url <- "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/"

  tidyr::expand_grid(
    model = name,
    time_id = sel_time_var,
    variable = sel_variables,
    bio = sel_bio_var,
    month = month_var
  ) %>%
    dplyr::mutate(
      month = ifelse(variable != "bio", month, NA),
      bio = ifelse(variable == "bio", bio, NA),
      histdir = dplyr::case_when(
        variable == "bio" ~ "bio/",
        variable == "tasmin" ~ "tasmin/",
        variable == "tasmax" ~ "tasmax/",
        variable == "pr" ~ "pr/"
      ),
      file = case_when(
        variable == "bio" ~
          paste0(
            histdir, model, "_",
            variable, stringr::str_pad(bio, 2, "left", "0"), "_",
            time_id, "_V1.0.tif"
          ),
        variable != "bio" ~
          paste0(
            histdir, model, "_",
            variable, "_",
            month, "_",
            time_id, "_V1.0.tif"
          )
      ),
      url = paste0(base_url, file)
    ) %>%
    dplyr::distinct()
}
