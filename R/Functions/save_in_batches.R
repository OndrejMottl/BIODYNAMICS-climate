# Saves a large dataset in batches, dividing it into smaller subsets
#   and saving each subset separately.
save_in_batches <- function(
    data_source,
    n_batches = 5,
    file_name,
    dir,
    prefered_format = "rds",
    preset = "archive") {
  # Get the number of rows in the dataset
  n_rows <- nrow(data_source)

  # Calculate the number of rows per batch
  n_rows_per_batch <- ceiling(n_rows / n_batches)

  # Iterate over each batch index
  purrr::walk(
    .progress = "saving in batches",
    .x = seq_len(n_batches),
    .f = ~ {
      # Slice the data_source to extract the current batch
      data_source %>%
        dplyr::slice(
          ((.x - 1) * n_rows_per_batch + 1):(min(.x * n_rows_per_batch, n_rows))
        ) %>%
        # Save the current batch
        RUtilpol::save_latest_file(
          object_to_save = .,
          file_name = paste0(
            file_name,
            "_batch_",
            .x
          ),
          dir = dir,
          prefered_format = prefered_format,
          preset = preset
        )
    }
  )
}
