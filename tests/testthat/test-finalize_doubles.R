# finalize_doubles() -----------------------------------------------------------

test_that("finalize_doubles() converts integer-valued double columns to integer (#10)", {
  df <- data.frame(x = c(1.0, 2.0, 3.0), y = c(1.1, 2.2, 3.3))
  result <- finalize_doubles(df)
  expect_type(result$x, "integer")
  expect_type(result$y, "double")
})

test_that("finalize_doubles() leaves non-double columns unchanged (#10)", {
  df <- data.frame(
    x = c(1.0, 2.0),
    y = letters[1:2],
    z = TRUE,
    stringsAsFactors = FALSE
  )
  result <- finalize_doubles(df)
  expect_type(result$y, "character")
  expect_type(result$z, "logical")
})

test_that("finalize_doubles() preserves NA values in converted columns (#10)", {
  df <- data.frame(x = c(1.0, NA, 3.0))
  result <- finalize_doubles(df)
  expect_type(result$x, "integer")
  expect_true(is.na(result$x[[2]]))
})

test_that("finalize_doubles() does not convert already-integer columns (#10)", {
  df <- data.frame(x = 1L)
  result <- finalize_doubles(df)
  expect_type(result$x, "integer")
})

test_that("finalize_doubles() returns a data frame (#10)", {
  df <- data.frame(x = c(1.0, 2.0))
  result <- finalize_doubles(df)
  expect_s3_class(result, "data.frame")
})

test_that("finalize_doubles() handles a dataset with no double columns (#10)", {
  df <- data.frame(x = 1L, y = "a", stringsAsFactors = FALSE)
  result <- finalize_doubles(df)
  expect_identical(result, df)
})

test_that("finalize_doubles() handles an empty data frame (#10)", {
  df <- data.frame()
  result <- finalize_doubles(df)
  expect_identical(result, df)
})
