# Tests for mrr_count functions

# Tests for mrr_get_classifying_vars

test_that("mrr_get_classifying_vars: returns data frame", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    age = c(20, 30, 25),
    gender = c("M", "F", "M")
  )

  result <- mrr_get_classifying_vars(df, c("age", "gender"))
  expect_s3_class(result, "data.frame")
})

test_that("mrr_get_classifying_vars: includes respondent_id", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    age = c(20, 30, 25)
  )

  result <- mrr_get_classifying_vars(df, c("age"))
  expect_true("respondent_id" %in% names(result))
})

test_that("mrr_get_classifying_vars: includes specified variables", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    age = c(20, 30, 25),
    gender = c("M", "F", "M")
  )

  result <- mrr_get_classifying_vars(df, c("age", "gender"))
  expect_true("age" %in% names(result))
  expect_true("gender" %in% names(result))
})

test_that("mrr_get_classifying_vars: preserves row count", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3, 4, 5),
    age = c(20, 30, 25, 35, 40)
  )

  result <- mrr_get_classifying_vars(df, c("age"))
  expect_equal(nrow(result), 5)
})

test_that("mrr_get_classifying_vars: unclasses respondent_id", {
  df <- dplyr::tibble(
    respondent_id = factor(c(1, 2, 3)),
    age = c(20, 30, 25)
  )

  result <- mrr_get_classifying_vars(df, c("age"))
  expect_true(is.numeric(result$respondent_id))
})

test_that("mrr_get_classifying_vars: single classifying variable", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    region = c("North", "South", "East")
  )

  result <- mrr_get_classifying_vars(df, "region")
  expect_true("region" %in% names(result))
})

test_that("mrr_get_classifying_vars: multiple classifying variables", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2),
    var1 = c("A", "B"),
    var2 = c("X", "Y"),
    var3 = c("P", "Q")
  )

  result <- mrr_get_classifying_vars(df, c("var1", "var2", "var3"))
  expect_equal(nrow(result), 2)
  expect_equal(ncol(result), 4)
})

# Tests for mrr_get_multi_vars

test_that("mrr_get_multi_vars: returns data frame", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2),
    q1 = c(1, 2),
    q2 = c(2, 3)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  expect_s3_class(result, "data.frame")
})

test_that("mrr_get_multi_vars: pivots to long format", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2),
    q1 = c(1, 2),
    q2 = c(2, 3)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  expect_true("c_var_name" %in% names(result))
  expect_true("c_var_value" %in% names(result))
})

test_that("mrr_get_multi_vars: includes respondent_id in output", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2),
    q1 = c(1, 2),
    q2 = c(2, 3)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  expect_true("respondent_id" %in% names(result))
})

test_that("mrr_get_multi_vars: doubles row count when pivoting", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    q1 = c(1, 2, 3),
    q2 = c(2, 3, 1)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  expect_equal(nrow(result), 6)
})

test_that("mrr_get_multi_vars: unclasses factor values", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2),
    q1 = factor(c(1, 2)),
    q2 = factor(c(2, 3))
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  expect_true(is.numeric(result$c_var_value))
})

test_that("mrr_get_multi_vars: single response variable", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    q1 = c(1, 2, 3)
  )

  result <- mrr_get_multi_vars(df, "q1")
  expect_equal(nrow(result), 3)
})

test_that("mrr_get_multi_vars: preserves respondent_id values", {
  df <- dplyr::tibble(
    respondent_id = c(10, 20, 30),
    q1 = c(1, 2, 3),
    q2 = c(2, 3, 1)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  unique_ids <- unique(result$respondent_id)
  expect_equal(length(unique_ids), 3)
})

test_that("mrr_get_multi_vars: column names in output", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2),
    question_1 = c(1, 2),
    question_2 = c(2, 3)
  )

  result <- mrr_get_multi_vars(df, c("question_1", "question_2"))
  unique_vars <- unique(result$c_var_name)
  expect_true("question_1" %in% unique_vars)
  expect_true("question_2" %in% unique_vars)
})

test_that("mrr_get_multi_vars: handles missing values", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    q1 = c(1, NA, 3),
    q2 = c(2, 3, NA)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  # Should include NA values in result
  expect_true(any(is.na(result$c_var_value)))
})

test_that("mrr_get_multi_vars: numeric respondent IDs", {
  df <- dplyr::tibble(
    respondent_id = c(1, 2, 3),
    q1 = c(10, 20, 30),
    q2 = c(40, 50, 60)
  )

  result <- mrr_get_multi_vars(df, c("q1", "q2"))
  expect_true(is.numeric(result$respondent_id))
})
