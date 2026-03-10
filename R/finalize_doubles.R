#' Downcast integer-valued double columns to integer
#'
#' Iterates over all columns in `dataset` and converts any double column whose
#' values can all be represented as integers (as determined by
#' `stbl::is_int_ish()`) to integer using `stbl::to_int()`. Columns that are
#' not doubles, or that contain non-integer-valued data, are left unchanged.
#'
#' @param dataset (`data.frame`) The dataset to process.
#'
#' @returns The `dataset` with all safely-downcasted double columns converted to
#'   integer.
#' @export
#'
#' @examples
#' df <- data.frame(x = c(1.0, 2.0, 3.0), y = c(1.1, 2.2, 3.3))
#' finalize_doubles(df)
finalize_doubles <- function(dataset) {
  if (!is.data.frame(dataset)) {
    stbl::pkg_abort(
      "datawrap",
      "{.arg dataset} must be a {.cls data.frame}.",
      "invalid_argument"
    )
  }
  int_ish_cols <- purrr::map_lgl(dataset, is.double) &
    purrr::map_lgl(dataset, stbl::is_int_ish)
  dataset[int_ish_cols] <- purrr::map(dataset[int_ish_cols], stbl::to_int)
  dataset
}
