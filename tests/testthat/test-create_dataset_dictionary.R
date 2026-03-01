# .class_friendly() -----------------------------------------------------------

test_that(".class_friendly returns a single character string (#2)", {
  expect_type(.class_friendly(1L), "character")
  expect_length(.class_friendly(1L), 1L)
})

test_that(".class_friendly returns 'factor' for unordered factors (#2)", {
  expect_equal(.class_friendly(factor(letters)), "factor")
})

test_that(".class_friendly returns 'ordered' for ordered factors (#2)", {
  expect_equal(.class_friendly(factor(letters, ordered = TRUE)), "ordered")
})

test_that(".class_friendly normalises 'hms' to 'time' (#2)", {
  local_mocked_bindings(
    vec_ptype_full = function(...) "hms",
    .package = "vctrs"
  )
  expect_equal(.class_friendly(1L), "time")
})

test_that(".class_friendly strips angle-bracket suffix regardless of levels (#2)", {
  expect_equal(
    .class_friendly(factor(letters)),
    .class_friendly(factor(LETTERS))
  )
})

# .str_to_sentence_full() -----------------------------------------------------

test_that(".str_to_sentence_full capitalises the first letter (#2)", {
  expect_equal(.str_to_sentence_full("hello world"), "Hello world.")
})

test_that(".str_to_sentence_full replaces underscores with spaces (#2)", {
  expect_equal(.str_to_sentence_full("wind_speed_class"), "Wind speed class.")
})

test_that(".str_to_sentence_full does not double-add a trailing period (#2)", {
  expect_equal(.str_to_sentence_full("hello world."), "Hello world.")
})

test_that(".str_to_sentence_full is vectorised (#2)", {
  expect_equal(
    .str_to_sentence_full(c("foo_bar", "baz.")),
    c("Foo bar.", "Baz.")
  )
})

# create_dataset_dictionary() -------------------------------------------------

test_that("create_dataset_dictionary returns a tibble (#2)", {
  result <- create_dataset_dictionary(data.frame(x = 1L))
  expect_s3_class(result, "tbl_df")
})

test_that("create_dataset_dictionary has one row per column (#2)", {
  df <- data.frame(x = 1L, y = "a", z = TRUE)
  expect_equal(nrow(create_dataset_dictionary(df)), ncol(df))
})

test_that("create_dataset_dictionary has columns column_name, class, description (#2)", {
  result <- create_dataset_dictionary(data.frame(x = 1L))
  expect_named(result, c("column_name", "class", "description"))
})

test_that("create_dataset_dictionary column_name matches dataset names (#2)", {
  df <- data.frame(wind_speed = 1.0, air_temp = 1.0)
  result <- create_dataset_dictionary(df)
  expect_equal(result$column_name, c("wind_speed", "air_temp"))
})

test_that("create_dataset_dictionary class uses .class_friendly (#2)", {
  df <- data.frame(x = 1L, y = factor("a"))
  result <- create_dataset_dictionary(df)
  expect_equal(result$class, c("integer", "factor"))
})

test_that("create_dataset_dictionary description uses .str_to_sentence_full (#2)", {
  df <- data.frame(wind_speed = 1.0)
  result <- create_dataset_dictionary(df)
  expect_equal(result$description, "Wind speed.")
})
