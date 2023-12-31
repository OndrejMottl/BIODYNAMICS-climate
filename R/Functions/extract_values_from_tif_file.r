extract_values_from_tif_file <- function(sel_file_name) {
  # Convert selected file name to raster object
  sel_raster <-
    terra::rast(sel_file_name)

  # Get raster coordinates as a dataframe
  sel_raster_coords <-
    terra::xyFromCell(
      sel_raster,
      1:terra::ncell(sel_raster)
    ) %>%
    as.data.frame() %>%
    tibble::as_tibble() %>%
    dplyr::rename(long = x, lat = y)

  # Get raster values as a numeric vector
  sel_raster_values <-
    terra::values(sel_raster) %>%
    as.numeric()

  # Combine coordinates and values into a single dataframe
  data_corrds_with_values <-
    sel_raster_coords %>%
    dplyr::mutate(value = sel_raster_values)

  # Remove rows with missing values
  data_res <-
    data_corrds_with_values %>%
    tidyr::drop_na(value) %>%
    dplyr::mutate(var_name = names(sel_raster))

  return(data_res)
}