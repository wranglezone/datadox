test_that("finalize_integers() converts integerish double columns to integer (#10)", {
  df <- data.frame(x = c(1.0, 2.0, 3.0), y = c(1.1, 2.2, 3.3))
  result <- finalize_integers(df)
  expect_type(result$x, "integer")
  expect_type(result$y, "double")
})

test_that("finalize_integers() converts integer-valued double elements in a list to integer (#10)", {
  lst <- list(x = c(1.0, 2.0, 3.0), y = c(1.1, 2.2, 3.3))
  result <- finalize_integers(lst)
  expect_type(result$x, "integer")
  expect_type(result$y, "double")
})

test_that("finalize_integers() converts integerish character columns to integer (#10)", {
  df <- data.frame(x = as.character(1:3), y = as.character(c(1.1, 2.2, 3.3)))
  result <- finalize_integers(df)
  expect_type(result$x, "integer")
  expect_type(result$y, "character")
})

test_that("finalize_integers() leaves non-integerish columns unchanged (#10)", {
  df <- data.frame(
    x = c(1.0, 2.0),
    y = letters[1:2],
    z = TRUE,
    stringsAsFactors = FALSE
  )
  result <- finalize_integers(df)
  expect_type(result$y, "character")
  expect_type(result$z, "logical")
})

test_that("finalize_integers() preserves NA values in converted columns (#10)", {
  df <- data.frame(x = c(1.0, NA, 3.0))
  result <- finalize_integers(df)
  expect_type(result$x, "integer")
  expect_true(is.na(result$x[[2]]))
})

test_that("finalize_integers() preserves the class of the input (#10)", {
  tbl <- tibble::tibble(x = c(1.0, 2.0))
  result <- finalize_integers(tbl)
  expect_identical(class(result), class(tbl))
})

test_that("finalize_integers() errors if dataset is not a data.frame, list, or NULL (#10)", {
  stbl::expect_pkg_error_classes(
    finalize_integers("not a dataset"),
    "datawrap",
    "invalid_dataset",
    "invalid_argument"
  )
})

test_that("finalize_integers() handles a dataset with no double columns (#10)", {
  df <- data.frame(x = 1L, y = "a", stringsAsFactors = FALSE)
  expect_identical(finalize_integers(df), df)
})

test_that("finalize_integers() handles an empty data frame (#10)", {
  df <- data.frame()
  expect_identical(finalize_integers(df), df)
})

test_that("finalize_integers() handles NULL (#10)", {
  expect_null(finalize_integers(NULL))
})
