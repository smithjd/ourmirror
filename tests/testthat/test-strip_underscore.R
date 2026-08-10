test_that("strip_underscore: basic underscore replacement", {
  df <- data.frame(customer_id = 1)
  result <- strip_underscore(df)
  expect_equal(result, "customer id")
})

test_that("strip_underscore: multiple underscores in single name", {
  df <- data.frame(first_name_middle_initial = 1)
  result <- strip_underscore(df)
  expect_equal(result, "first name middle initial")
})

test_that("strip_underscore: multiple columns", {
  df <- data.frame(
    customer_id = 1,
    first_name = "John",
    last_login_date = Sys.Date()
  )
  result <- strip_underscore(df)
  expect_equal(result, c("customer id", "first name", "last login date"))
})

test_that("strip_underscore: no underscores", {
  df <- data.frame(
    id = 1,
    name = "John",
    date = Sys.Date()
  )
  result <- strip_underscore(df)
  expect_equal(result, c("id", "name", "date"))
})

test_that("strip_underscore: leading underscore", {
  df <- data.frame(internal_field = 1)
  names(df) <- "_internal_field"
  result <- strip_underscore(df)
  expect_equal(result, " internal field")
})

test_that("strip_underscore: trailing underscore", {
  df <- data.frame(`field_` = 1)
  result <- strip_underscore(df)
  expect_equal(result, "field ")
})

test_that("strip_underscore: consecutive underscores", {
  df <- data.frame(`field__name` = 1)
  result <- strip_underscore(df)
  expect_equal(result, "field  name")
})

test_that("strip_underscore: all underscores", {
  df <- data.frame(x = 1)
  names(df) <- "___"
  result <- strip_underscore(df)
  expect_equal(result, "   ")
})

test_that("strip_underscore: single character column name", {
  df <- data.frame(x = 1)
  result <- strip_underscore(df)
  expect_equal(result, "x")
})

test_that("strip_underscore: mixed case preserved", {
  df <- data.frame(CustomerID = 1)
  result <- strip_underscore(df)
  expect_equal(result, "CustomerID")
})

test_that("strip_underscore: numbers in names", {
  df <- data.frame(var_1_test = 1)
  result <- strip_underscore(df)
  expect_equal(result, "var 1 test")
})

test_that("strip_underscore: special characters handled", {
  df <- data.frame(x = 1)
  names(df) <- "var_name.special"
  result <- strip_underscore(df)
  expect_equal(result, "var name.special")
})

test_that("strip_underscore: returns character vector", {
  df <- data.frame(col_name = 1)
  result <- strip_underscore(df)
  expect_type(result, "character")
})

test_that("strip_underscore: length matches number of columns", {
  df <- data.frame(a = 1, b = 2, c = 3, d = 4)
  result <- strip_underscore(df)
  expect_length(result, 4)
})

test_that("strip_underscore: empty data frame", {
  df <- data.frame()
  result <- strip_underscore(df)
  expect_length(result, 0)
})

test_that("strip_underscore: long column names", {
  df <- data.frame(`very_long_column_name_with_many_underscores` = 1)
  result <- strip_underscore(df)
  expect_equal(result, "very long column name with many underscores")
})

test_that("strip_underscore: unicode in names", {
  df <- data.frame(`café_name` = 1)
  result <- strip_underscore(df)
  expect_equal(result, "café name")
})
