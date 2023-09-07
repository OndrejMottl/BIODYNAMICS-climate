downscale_tif_data <- function(file_path,
                               dir = here::here(),
                               sel_factor = 10,
                               only_land = FALSE,
                               shapefile_land = NULL,
                               ...) {
  data_rast_raw <- terra::rast(file_path)

  data_rast_agg <-
    terra::aggregate(
      data_rast_raw,
      fact = sel_factor,
      ...
    )

  if (
    isTRUE(only_land) && isTRUE("sf" %in% class(shapefile_land))
  ) {
    land_spatvector <-
      terra::vect(land_shp)

    data_rast_agg_crop <-
      terra::crop(
        x = data_rast_agg,
        y = land_spatvector,
        mask = TRUE,
        snap = "in"
      )

    data_rast_agg <- data_rast_agg_crop
  }

  terra::writeRaster(
    x = data_rast_agg,
    filename = paste0(dir, "/", basename(file_path))
  )
}
