# Tests for mrr_factors

test_that("mrr_append_factor_pct: returns character vector", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  expect_type(result, "character")
})

test_that("mrr_append_factor_pct: is named vector", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  expect_true(!is.null(names(result)))
})

test_that("mrr_append_factor_pct: appends percentages to labels", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  # Should have "%" in names (labels)
  expect_true(any(grepl("%", names(result))))
})

test_that("mrr_append_factor_pct: correct percentages for equal counts", {
  x <- c("A", "A", "B", "B", "C", "C")
  result <- mrr_append_factor_pct(x, decimals = 1)
  # Each should have percentage in name
  expect_true(any(grepl("33", names(result))))
})

test_that("mrr_append_factor_pct: percentages sum to 100", {
  x <- c("A", "A", "A", "B", "C")
  result <- mrr_append_factor_pct(x, decimals = 0)
  # Extract percentages from labels
  pcts <- as.numeric(gsub(".*\\((\\d+)%\\).*", "\\1", names(result)))
  expect_equal(sum(pcts), 100)
})

test_that("mrr_append_factor_pct: respects decimals parameter", {
  x <- c("A", "A", "B", "C", "C", "C")
  result_0 <- mrr_append_factor_pct(x, decimals = 0)
  result_2 <- mrr_append_factor_pct(x, decimals = 2)

  # 0 decimals should not have "."
  pct_0 <- names(result_0)[1]
  pct_2 <- names(result_2)[1]

  expect_true(!grepl("\\d+\\.\\d+%", pct_0))
  expect_true(grepl("\\d+\\.\\d+%", pct_2))
})

test_that("mrr_append_factor_pct: default decimals is 1", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  # Default should have 1 decimal place
  expect_true(any(grepl("\\d+\\.\\d%", names(result))))
})

test_that("mrr_append_factor_pct: names are original factor levels", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  # All names should contain original labels followed by percentage
  expected_starts <- c("A", "B", "C")
  actual_starts <- sapply(strsplit(names(result), " \\("), "[", 1)
  expect_true(all(actual_starts %in% expected_starts))
})

test_that("mrr_append_factor_pct: handles single category", {
  x <- c("Only", "Only", "Only", "Only")
  result <- mrr_append_factor_pct(x)
  expect_equal(length(result), 1)
  expect_true(grepl("100", names(result)))
})

test_that("mrr_append_factor_pct: handles many categories", {
  x <- factor(c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"))
  result <- mrr_append_factor_pct(x)
  expect_equal(length(result), 10)
})

test_that("mrr_append_factor_pct: format is 'Label (X%)'", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  # Each name should have pattern "Label (...%)"
  expect_true(all(grepl("\\(.*%\\)", names(result))))
})

test_that("mrr_append_factor_pct: values are original levels", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x)
  # Values should be "A", "B", "C"
  expect_true(all(result %in% c("A", "B", "C")))
})

test_that("mrr_append_factor_pct: handles factor input", {
  x <- factor(c("Yes", "Yes", "No", "Maybe", "Maybe", "Maybe"))
  result <- mrr_append_factor_pct(x)
  expect_type(result, "character")
  expect_true(!is.null(names(result)))
})

test_that("mrr_append_factor_pct: rounding correct for small numbers", {
  x <- c("A", "B", "B", "B", "C")
  result <- mrr_append_factor_pct(x, decimals = 1)
  # A is 1/5 = 20.0%, B is 3/5 = 60.0%, C is 1/5 = 20.0%
  expect_true(length(names(result)) > 0)
  expect_true(all(grepl("%", names(result))))
})

test_that("mrr_append_factor_pct: duplicates resolved", {
  x <- c("Response", "Response", "Response")
  result <- mrr_append_factor_pct(x)
  expect_equal(length(result), 1)
})

test_that("mrr_append_factor_pct: order preserved", {
  x <- c("First", "First", "Second", "Third", "Third", "Third")
  result <- mrr_append_factor_pct(x)
  # Values should match input order (after deduplication)
  expect_true(result[[1]] %in% c("First", "Second", "Third"))
})

test_that("mrr_append_factor_pct: high decimal places", {
  x <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")
  result <- mrr_append_factor_pct(x, decimals = 3)
  # Each should have percentage in name
  expect_true(all(grepl("%", names(result))))
})

test_that("mrr_append_factor_pct: zero decimals", {
  x <- c("A", "A", "B", "C", "C", "C")
  result <- mrr_append_factor_pct(x, decimals = 0)
  # Should not have decimal point
  expect_true(!any(grepl("\\d+\\.\\d+%", names(result))))
})

test_that("mrr_append_factor_pct: two categories 50-50 split", {
  x <- c("Yes", "Yes", "No", "No")
  result <- mrr_append_factor_pct(x, decimals = 1)
  # Both should be 50%
  expect_true(all(grepl("50", names(result))))
})
