# .write_file_lines() ---------------------------------------------------------

test_that(".write_file_lines writes content to the file (#4)", {
  tmp <- withr::local_tempfile(fileext = ".txt")
  .write_file_lines(c("line 1", "line 2"), tmp, open = FALSE)
  expect_equal(readLines(tmp), c("line 1", "line 2"))
})

test_that(".write_file_lines returns the file path invisibly (#4)", {
  tmp <- withr::local_tempfile(fileext = ".txt")
  result <- withVisible(.write_file_lines("x", tmp, open = FALSE))
  expect_equal(result$value, tmp)
  expect_false(result$visible)
})

test_that(".write_file_lines opens with usethis when open = TRUE and usethis is available (#4)", {
  tmp <- withr::local_tempfile(fileext = ".txt")
  local_mocked_bindings(
    edit_file = function(...) {
      message("opened")
      invisible(NULL)
    },
    .package = "usethis"
  )
  expect_message(.write_file_lines("x", tmp, open = TRUE), "opened")
})

test_that(".write_file_lines falls back to file.edit when usethis is unavailable (#4)", {
  tmp <- withr::local_tempfile(fileext = ".txt")
  local_mocked_bindings(is_installed = function(...) FALSE, .package = "rlang")
  local_mocked_bindings(
    file.edit = function(...) {
      message("opened")
      invisible(NULL)
    },
    .package = "utils"
  )
  expect_message(.write_file_lines("x", tmp, open = TRUE), "opened")
})

# write_dataset_dictionary() --------------------------------------------------

test_that("write_dataset_dictionary creates a file at the expected path (#4)", {
  tmp_dir <- withr::local_tempdir()
  df <- data.frame(x = 1L)
  write_dataset_dictionary(
    df,
    path = tmp_dir,
    dataset_name = "my_df",
    open = FALSE
  )
  expect_true(file.exists(file.path(tmp_dir, "my_df_dictionary.md")))
})

test_that("write_dataset_dictionary infers dataset_name from the call (#4)", {
  tmp_dir <- withr::local_tempdir()
  my_special_df <- data.frame(x = 1L)
  write_dataset_dictionary(my_special_df, path = tmp_dir, open = FALSE)
  expect_true(file.exists(file.path(tmp_dir, "my_special_df_dictionary.md")))
})

test_that("write_dataset_dictionary returns the file path invisibly (#4)", {
  tmp_dir <- withr::local_tempdir()
  df <- data.frame(x = 1L)
  result <- withVisible(
    write_dataset_dictionary(
      df,
      path = tmp_dir,
      dataset_name = "df",
      open = FALSE
    )
  )
  expect_equal(result$value, file.path(tmp_dir, "df_dictionary.md"))
  expect_false(result$visible)
})

test_that("write_dataset_dictionary produces one row per column (#4)", {
  tmp_dir <- withr::local_tempdir()
  df <- data.frame(x = 1L, y = "a", z = TRUE)
  write_dataset_dictionary(
    df,
    path = tmp_dir,
    dataset_name = "df",
    open = FALSE
  )
  lines <- readLines(file.path(tmp_dir, "df_dictionary.md"))
  # kable output: header + separator + one row per column
  expect_length(lines, ncol(df) + 2L)
})

test_that("write_dataset_dictionary includes column names in the output (#4)", {
  tmp_dir <- withr::local_tempdir()
  df <- data.frame(wind_speed = 1.0, air_temp = 1.0)
  write_dataset_dictionary(
    df,
    path = tmp_dir,
    dataset_name = "df",
    open = FALSE
  )
  content <- paste(
    readLines(file.path(tmp_dir, "df_dictionary.md")),
    collapse = "\n"
  )
  expect_match(content, "wind_speed")
  expect_match(content, "air_temp")
})

test_that("write_dataset_dictionary uses .class_friendly for the class column (#4)", {
  tmp_dir <- withr::local_tempdir()
  df <- data.frame(x = 1L, y = factor("a"))
  write_dataset_dictionary(
    df,
    path = tmp_dir,
    dataset_name = "df",
    open = FALSE
  )
  content <- paste(
    readLines(file.path(tmp_dir, "df_dictionary.md")),
    collapse = "\n"
  )
  expect_match(content, "integer")
  expect_match(content, "factor")
})

test_that("write_dataset_dictionary uses .str_to_sentence_full for descriptions (#4)", {
  tmp_dir <- withr::local_tempdir()
  df <- data.frame(wind_speed = 1.0)
  write_dataset_dictionary(
    df,
    path = tmp_dir,
    dataset_name = "df",
    open = FALSE
  )
  content <- paste(
    readLines(file.path(tmp_dir, "df_dictionary.md")),
    collapse = "\n"
  )
  expect_match(content, "Wind speed\\.")
})
