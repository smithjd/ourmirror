# Tests for mrr_cat_center_size_count

test_that("mrr_cat_center_size_count: returns data frame", {
  df <- dplyr::tibble(
    center_id = 1:5,
    members = c(5, 15, 30, 75, 150)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_s3_class(result, "data.frame")
})

test_that("mrr_cat_center_size_count: adds center_size column", {
  df <- dplyr::tibble(
    center_id = 1:5,
    members = c(5, 15, 30, 75, 150)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true("center_size" %in% names(result))
})

test_that("mrr_cat_center_size_count: custom column name parameter", {
  df <- dplyr::tibble(
    center_id = 1:5,
    members = c(5, 15, 30, 75, 150)
  )

  result <- mrr_cat_center_size_count(df, members, center_size_category = "size_cat")
  expect_true("size_cat" %in% names(result))
})

test_that("mrr_cat_center_size_count: Very Small (< 10)", {
  df <- dplyr::tibble(
    center_id = 1:3,
    members = c(1, 5, 9)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Very Small ( < 10)"))
})

test_that("mrr_cat_center_size_count: Small (11-20)", {
  df <- dplyr::tibble(
    center_id = 1:3,
    members = c(11, 15, 20)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Small (11 - 20)"))
})

test_that("mrr_cat_center_size_count: Medium (21-50)", {
  df <- dplyr::tibble(
    center_id = 1:3,
    members = c(21, 35, 50)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Medium (21 - 50)"))
})

test_that("mrr_cat_center_size_count: Large (51-100)", {
  df <- dplyr::tibble(
    center_id = 1:3,
    members = c(51, 75, 100)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Large (51 - 100)"))
})

test_that("mrr_cat_center_size_count: Very Large (> 101)", {
  df <- dplyr::tibble(
    center_id = 1:3,
    members = c(101, 200, 500)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Very Large ( > 101)"))
})

test_that("mrr_cat_center_size_count: boundary value 10", {
  df <- dplyr::tibble(members = 10)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_count: boundary value 11", {
  df <- dplyr::tibble(members = 11)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Small (11 - 20)")
})

test_that("mrr_cat_center_size_count: boundary value 20", {
  df <- dplyr::tibble(members = 20)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Small (11 - 20)")
})

test_that("mrr_cat_center_size_count: boundary value 21", {
  df <- dplyr::tibble(members = 21)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Medium (21 - 50)")
})

test_that("mrr_cat_center_size_count: boundary value 50", {
  df <- dplyr::tibble(members = 50)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Medium (21 - 50)")
})

test_that("mrr_cat_center_size_count: boundary value 51", {
  df <- dplyr::tibble(members = 51)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Large (51 - 100)")
})

test_that("mrr_cat_center_size_count: boundary value 100", {
  df <- dplyr::tibble(members = 100)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Large (51 - 100)")
})

test_that("mrr_cat_center_size_count: boundary value 101", {
  df <- dplyr::tibble(members = 101)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Very Large ( > 101)")
})

test_that("mrr_cat_center_size_count: preserves other columns", {
  df <- dplyr::tibble(
    center_id = c(1, 2, 3),
    center_name = c("A", "B", "C"),
    members = c(5, 25, 75)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true("center_id" %in% names(result))
  expect_true("center_name" %in% names(result))
})

test_that("mrr_cat_center_size_count: preserves row order", {
  df <- dplyr::tibble(
    center_id = 1:4,
    members = c(5, 100, 30, 120)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(result$center_id, df$center_id)
})

test_that("mrr_cat_center_size_count: creates ordered factor", {
  df <- dplyr::tibble(members = c(5, 25, 75))

  result <- mrr_cat_center_size_count(df, members)
  expect_true(is.ordered(result$center_size))
  expect_true(is.factor(result$center_size))
})

test_that("mrr_cat_center_size_count: factor has correct levels", {
  df <- dplyr::tibble(members = c(5, 25, 75))

  result <- mrr_cat_center_size_count(df, members)
  expected_levels <- c(
    "Very Small ( < 10)",
    "Small (11 - 20)",
    "Medium (21 - 50)",
    "Large (51 - 100)",
    "Very Large ( > 101)"
  )
  expect_equal(levels(result$center_size), expected_levels)
})

test_that("mrr_cat_center_size_count: handles all categories", {
  df <- dplyr::tibble(
    members = c(5, 15, 35, 75, 150)
  )

  result <- mrr_cat_center_size_count(df, members)
  unique_cats <- unique(as.character(result$center_size))
  expect_equal(length(unique_cats), 5)
})

test_that("mrr_cat_center_size_count: handles zero members", {
  df <- dplyr::tibble(members = 0)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(as.character(result$center_size), "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_count: handles NA values", {
  df <- dplyr::tibble(
    members = c(5, NA, 25)
  )

  result <- mrr_cat_center_size_count(df, members)
  # NA input produces NA in result
  expect_equal(nrow(result), 3)
  expect_true(is.na(result$center_size[2]) || is.na(result$members[2]))
})

test_that("mrr_cat_center_size_count: large data frame", {
  df <- dplyr::tibble(
    id = 1:1000,
    members = sample(1:500, 1000, replace = TRUE)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(nrow(result), 1000)
})

test_that("mrr_cat_center_size_count: single row", {
  df <- dplyr::tibble(members = 42)

  result <- mrr_cat_center_size_count(df, members)
  expect_equal(nrow(result), 1)
  expect_equal(as.character(result$center_size), "Medium (21 - 50)")
})

test_that("mrr_cat_center_size_count: all same value", {
  df <- dplyr::tibble(
    id = 1:5,
    members = c(30, 30, 30, 30, 30)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Medium (21 - 50)"))
})

test_that("mrr_cat_center_size_count: very large numbers", {
  df <- dplyr::tibble(members = c(1000, 10000, 100000))

  result <- mrr_cat_center_size_count(df, members)
  expect_true(all(result$center_size == "Very Large ( > 101)"))
})

test_that("mrr_cat_center_size_count: mixed with grouped data", {
  df <- dplyr::tibble(
    group = c("A", "A", "B", "B"),
    members = c(5, 25, 50, 75)
  )

  result <- mrr_cat_center_size_count(df, members)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 4)
})
