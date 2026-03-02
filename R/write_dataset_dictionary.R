#' Write an initial data dictionary markdown file for a dataset
#'
#' Creates a Markdown data dictionary file for a dataset with one row per
#' column, pre-filled with placeholder descriptions. The file is intended to be
#' hand-edited, then read back (e.g. via `readMDTable::read_md_table()`) to
#' produce a curated dictionary for use with [describe_dataset()].
#'
#' @param dataset (`data.frame`) The dataset to document.
#' @param path (`character(1)`) Directory in which to write the file. Defaults
#'   to `"data-raw"`.
#' @param dataset_name (`character(1)`) Base name used to construct the output
#'   filename (`{dataset_name}_dictionary.md`). Defaults to the name of the
#'   object passed as `dataset`.
#' @param open (`logical(1)`) Whether to open the file for editing after
#'   writing. Defaults to `TRUE` in interactive sessions.
#'
#' @returns (`character(1)`) The path to the written file, invisibly.
#' @seealso [create_dataset_dictionary()], [describe_dataset()]
#' @export
#'
#' @examples
#' tmp <- tempdir()
#' write_dataset_dictionary(mtcars, path = tmp, open = FALSE)
write_dataset_dictionary <- function(
  dataset,
  path = "data-raw",
  dataset_name = rlang::caller_arg(dataset),
  open = rlang::is_interactive()
) {
  dict <- create_dataset_dictionary(dataset)
  file_path <- file.path(path, paste0(dataset_name, "_dictionary.md"))
  .write_file_lines(knitr::kable(dict), file_path, open = open)
}

# helpers ----------------------------------------------------------------------

#' Write lines to a file and optionally open it for editing
#'
#' @param lines (`character`) The lines to write.
#' @param file_path (`character(1)`) Path to the output file.
#' @param open (`logical(1)`) Whether to open the file for editing after
#'   writing. Defaults to `TRUE` in interactive sessions.
#' @returns (`character(1)`) The path to the written file, invisibly.
#' @keywords internal
.write_file_lines <- function(
  lines,
  file_path,
  open = rlang::is_interactive()
) {
  writeLines(lines, file_path)
  if (open) {
    if (rlang::is_installed("usethis")) {
      usethis::edit_file(file_path)
    } else {
      utils::file.edit(file_path)
    }
  }
  invisible(file_path)
}
