downscale_and_crop_tif_data <- function(file_path,
                                        dir = here::here(),
                                        sel_factor = 1,
                                        only_land = FALSE,
                                        shapefile_land = NULL,
                                        ...) {
  data_rast_raw <- terra::rast(file_path)

  res <- data_rast_raw

  if (
    sel_factor > 1
  ) {
    res <-
      terra::aggregate(
        data_rast_raw,
        fact = sel_factor,
        ...
      )
  }

  if (
    isTRUE(only_land) && isTRUE("sf" %in% class(shapefile_land))
  ) {
    land_spatvector <-
      terra::vect(shapefile_land)

    res <-
      terra::crop(
        x = res,
        y = land_spatvector,
        mask = TRUE,
        snap = "in"
      )
  }

  terra::writeRaster(
    x = res,
    filename = paste0(dir, "/", basename(file_path))
  )
}
