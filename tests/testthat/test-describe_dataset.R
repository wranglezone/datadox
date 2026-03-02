# describe_dataset() -----------------------------------------------------------

test_that("describe_dataset() returns a character vector (#3)", {
  df <- data.frame(x = 1L, y = "a")
  dict <- data.frame(
    column_name = c("x", "y"),
    class = c("integer", "character"),
    description = c("An integer.", "A string.")
  )
  result <- describe_dataset(df, dict)
  expect_type(result, "character")
})

test_that("describe_dataset() header reflects actual dataset dimensions (#3)", {
  df <- data.frame(x = 1L, y = 2L, z = 3L)
  dict <- data.frame(
    column_name = c("x", "y", "z"),
    class = c("integer", "integer", "integer"),
    description = c("X.", "Y.", "Z.")
  )
  result <- describe_dataset(df, dict)
  expect_match(result[[1]], "@format A tibble with 1 rows and 3 variables:")
})

test_that("describe_dataset() produces one \\item per dictionary row (#3)", {
  df <- data.frame(x = 1L, y = "a")
  dict <- data.frame(
    column_name = c("x", "y"),
    class = c("integer", "character"),
    description = c("An integer.", "A string.")
  )
  result <- describe_dataset(df, dict)
  items <- grep("\\\\item", result, value = TRUE)
  expect_length(items, nrow(dict))
})

test_that("describe_dataset() formats \\item entries correctly (#3)", {
  df <- data.frame(x = 1L)
  dict <- data.frame(
    column_name = "x",
    class = "integer",
    description = "An integer column."
  )
  result <- describe_dataset(df, dict)
  expect_match(
    result,
    "\\\\item\\{x\\}\\{\\(`integer`\\) An integer column\\.\\}",
    all = FALSE
  )
})

test_that("describe_dataset() wraps items in \\describe{} (#3)", {
  df <- data.frame(x = 1L)
  dict <- data.frame(
    column_name = "x",
    class = "integer",
    description = "An integer."
  )
  result <- describe_dataset(df, dict)
  expect_equal(result[[2]], "\\describe{")
  expect_equal(result[[length(result)]], "}")
})

test_that("describe_dataset() uses create_dataset_dictionary() by default (#3)", {
  skip_if_not_installed("purrr")
  skip_if_not_installed("stringr")
  skip_if_not_installed("tibble")
  skip_if_not_installed("vctrs")
  df <- data.frame(wind_speed = 1L)
  result <- describe_dataset(df)
  expect_match(result, "wind_speed", all = FALSE)
  expect_match(result, "Wind speed\\.", all = FALSE)
})
