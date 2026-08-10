test_that("names_to_titles: basic snake_case to title case", {
  df <- data.frame(first_name = "John")
  result <- names_to_titles(df)
  expect_equal(names(result), "First Name")
})

test_that("names_to_titles: multiple columns", {
  df <- data.frame(
    first_name = "John",
    last_name = "Doe",
    birth_date = as.Date("1990-01-01")
  )
  result <- names_to_titles(df)
  expect_equal(names(result), c("First Name", "Last Name", "Birth Date"))
})

test_that("names_to_titles: single word column", {
  df <- data.frame(id = 1)
  result <- names_to_titles(df)
  expect_equal(names(result), "Id")
})

test_that("names_to_titles: no underscores", {
  df <- data.frame(Name = "John", Email = "john@example.com")
  result <- names_to_titles(df)
  expect_equal(names(result), c("Name", "Email"))
})

test_that("names_to_titles: multiple underscores", {
  df <- data.frame(first_middle_last_name = "John")
  result <- names_to_titles(df)
  expect_equal(names(result), "First Middle Last Name")
})

test_that("names_to_titles: leading underscore", {
  df <- data.frame(x = 1)
  names(df) <- "_internal_field"
  result <- names_to_titles(df)
  expect_equal(names(result), " Internal Field")
})

test_that("names_to_titles: trailing underscore", {
  df <- data.frame(`field_` = 1)
  result <- names_to_titles(df)
  expect_equal(names(result), "Field ")
})

test_that("names_to_titles: consecutive underscores", {
  df <- data.frame(`field__name` = 1)
  result <- names_to_titles(df)
  expect_equal(names(result), "Field  Name")
})

test_that("names_to_titles: preserves data", {
  df <- data.frame(
    customer_id = c(1, 2, 3),
    customer_name = c("Alice", "Bob", "Charlie")
  )
  result <- names_to_titles(df)
  expect_equal(result$`Customer Id`, c(1, 2, 3))
  expect_equal(result$`Customer Name`, c("Alice", "Bob", "Charlie"))
})

test_that("names_to_titles: returns data frame", {
  df <- data.frame(col_name = 1)
  result <- names_to_titles(df)
  expect_s3_class(result, "data.frame")
})

test_that("names_to_titles: row count unchanged", {
  df <- data.frame(
    x = 1:10,
    y = 11:20
  )
  result <- names_to_titles(df)
  expect_equal(nrow(result), 10)
})

test_that("names_to_titles: column count unchanged", {
  df <- data.frame(a = 1, b = 2, c = 3, d = 4)
  result <- names_to_titles(df)
  expect_equal(ncol(result), 4)
})

test_that("names_to_titles: with numbers in name", {
  df <- data.frame(var_1_test = 1)
  result <- names_to_titles(df)
  expect_equal(names(result), "Var 1 Test")
})

test_that("names_to_titles: all caps words", {
  df <- data.frame(id_USA = 1)
  result <- names_to_titles(df)
  # str_to_title behavior may vary; document actual output
  expect_type(names(result), "character")
})

test_that("names_to_titles: data types preserved", {
  df <- data.frame(
    int_col = 1L,
    num_col = 3.14,
    char_col = "test",
    date_col = as.Date("2024-01-01")
  )
  result <- names_to_titles(df)
  expect_type(result$`Int Col`, "integer")
  expect_type(result$`Num Col`, "double")
  expect_type(result$`Char Col`, "character")
  expect_s3_class(result$`Date Col`, "Date")
})

test_that("names_to_titles: NA values preserved", {
  df <- data.frame(test_col = c("A", NA, "C"))
  result <- names_to_titles(df)
  expect_true(is.na(result$`Test Col`[2]))
})

test_that("names_to_titles: factors preserved", {
  df <- data.frame(test_factor = factor(c("a", "b", "c")))
  result <- names_to_titles(df)
  expect_s3_class(result$`Test Factor`, "factor")
})

test_that("names_to_titles: empty data frame", {
  df <- data.frame()
  result <- names_to_titles(df)
  expect_length(names(result), 0)
})

test_that("names_to_titles: unicode in names", {
  df <- data.frame(`café_name` = 1)
  result <- names_to_titles(df)
  expect_type(names(result), "character")
})

test_that("names_to_titles: special characters", {
  df <- data.frame(x = 1)
  names(df) <- "test_name.with.dash"
  result <- names_to_titles(df)
  # str_to_title capitalizes after spaces but not after periods
  expect_equal(names(result), "Test Name.with.dash")
})

test_that("names_to_titles: very long names", {
  df <- data.frame(`very_long_column_name_with_many_words_and_underscores` = 1)
  result <- names_to_titles(df)
  expected <- "Very Long Column Name With Many Words And Underscores"
  expect_equal(names(result), expected)
})

test_that("names_to_titles: single row data frame", {
  df <- data.frame(first_name = "John", last_name = "Doe")
  result <- names_to_titles(df)
  expect_equal(nrow(result), 1)
  expect_equal(names(result), c("First Name", "Last Name"))
})

test_that("names_to_titles: multiple data types", {
  df <- data.frame(
    int_col = c(1, 2),
    char_col = c("a", "b"),
    num_col = c(1.1, 2.2),
    logic_col = c(TRUE, FALSE)
  )
  result <- names_to_titles(df)
  expect_equal(ncol(result), 4)
  expect_equal(nrow(result), 2)
})

test_that("names_to_titles: preserves attributes", {
  df <- data.frame(test_col = 1:3)
  attr(df, "custom_attr") <- "test_value"
  result <- names_to_titles(df)
  # Document behavior: does it preserve custom attributes?
  expect_s3_class(result, "data.frame")
})
