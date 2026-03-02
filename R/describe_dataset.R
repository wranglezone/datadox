#' Generate a `@format` roxygen2 block for a dataset
#'
#' Builds a complete `@format` block describing a dataset's columns, suitable
#' for use with `@eval` in roxygen2 documentation. The header line reflects the
#' actual dimensions of `dataset`; each column gets one `\item` entry combining
#' the class label and description from `dictionary`.
#'
#' @param dataset (`data.frame`) The dataset to document.
#' @param dictionary (`data.frame`) A dictionary with columns `column_name`,
#'   `class`, and `description`, one row per column of `dataset`. Defaults to
#'   `create_dataset_dictionary(dataset)`.
#'
#' @returns (`character`) A character vector of roxygen2 lines forming a
#'   `@format` block, suitable for returning from `@eval`.
#' @seealso [create_dataset_dictionary()]
#' @export
#'
#' @examples
#' describe_dataset(mtcars)
describe_dataset <- function(
  dataset,
  dictionary = create_dataset_dictionary(dataset)
) {
  header <- sprintf(
    "@format A tibble with %d rows and %d variables:",
    nrow(dataset),
    ncol(dataset)
  )
  items <- sprintf(
    "  \\item{%s}{(`%s`) %s}",
    dictionary$column_name,
    dictionary$class,
    dictionary$description
  )
  c(header, "\\describe{", items, "}")
}
