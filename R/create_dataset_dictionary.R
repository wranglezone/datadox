#' Create a data dictionary tibble for a dataset
#'
#' Builds a tibble with one row per column in `dataset`, containing the column
#' name, class label, and a placeholder description.
#'
#' @param dataset (`data.frame`) The dataset to describe.
#'
#' @returns (`tibble`) A tibble with columns `column_name` (`character`),
#'   `class` (`character`), and `description` (`character`).
#' @export
#'
#' @examples
#' create_dataset_dictionary(mtcars)
create_dataset_dictionary <- function(dataset) {
  rlang::check_installed(
    c("purrr", "tibble"),
    "to create a data dictionary."
  )
  tibble::tibble(
    column_name = names(dataset),
    class = unname(purrr::map_chr(dataset, .class_friendly)),
    description = purrr::map_chr(colnames(dataset), .str_to_sentence_full)
  )
}

# helpers ----------------------------------------------------------------------

#' Describe the class of an object for a data dictionary
#'
#' @param x (`any`) The object to describe.
#'
#' @returns (`character(1)`) A descriptive class label for the object.
#' @keywords internal
.class_friendly <- function(x) {
  rlang::check_installed("vctrs", "to describe column classes.")
  result <- sub("<[^>]*>", "", vctrs::vec_ptype_full(x))
  # vctrs returns "hms" or "time" depending on whether the hms package is
  # loaded; normalise to "time" for consistency.
  if (result == "hms") "time" else result
}

#' Convert a string to a full sentence
#'
#' Replaces underscores with spaces, converts to sentence case, strips any
#' trailing period, and appends one.
#'
#' @inheritParams stringr::str_to_sentence
#'
#' @returns (`character`) The input string(s) converted to sentence case with a
#'   trailing period.
#' @keywords internal
.str_to_sentence_full <- function(string, locale = "en") {
  rlang::check_installed("stringr", "to convert strings to sentence case.")
  string |>
    stringr::str_replace_all("_", " ") |>
    stringr::str_remove("\\.$") |>
    stringr::str_to_sentence(locale = locale) |>
    paste0(".")
}
