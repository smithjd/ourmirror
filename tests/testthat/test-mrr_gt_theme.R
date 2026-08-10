# Tests for mrr_gt_theme

test_that("mrr_gt_theme: requires gt table input", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: returns gt table object", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: default parameters", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: custom title_size", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl, title_size = 24)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: custom sub_title_size", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl, sub_title_size = 16)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: custom col_label_size", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl, col_label_size = 16)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: all custom parameters", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(
    gt_tbl,
    title_size = 22,
    sub_title_size = 15,
    col_label_size = 15
  )
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with single column table", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3)
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with many columns", {
  skip_if_not_installed("gt")
  df <- data.frame(
    a = 1:3, b = 4:6, c = 7:9, d = 10:12, e = 13:15
  )
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with single row table", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1, y = "a")
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with many rows", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:100, y = letters[1:100])
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with numeric data", {
  skip_if_not_installed("gt")
  df <- data.frame(x = c(1.5, 2.7, 3.2), y = c(100, 200, 300))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with character data", {
  skip_if_not_installed("gt")
  df <- data.frame(name = c("Alice", "Bob", "Charlie"), city = c("NYC", "LA", "SF"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with mixed data types", {
  skip_if_not_installed("gt")
  df <- data.frame(
    id = 1:3,
    name = c("Alice", "Bob", "Charlie"),
    score = c(85.5, 92.3, 78.1),
    date = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03"))
  )
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with NA values", {
  skip_if_not_installed("gt")
  df <- data.frame(x = c(1, NA, 3), y = c("a", "b", NA))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: small title_size", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3)
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl, title_size = 12)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: large title_size", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3)
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl, title_size = 32)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: preserves table data", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result <- mrr_gt_theme(gt_tbl)
  # Table should still have the same data
  expect_equal(nrow(result$`_data`), 3)
})

test_that("mrr_gt_theme: can be chained with other gt operations", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  result <- gt::gt(df) |>
    mrr_gt_theme() |>
    gt::tab_header(title = "Test Table")
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with gt piping", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  result <- df |>
    gt::gt() |>
    mrr_gt_theme()
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: is idempotent (can be applied twice)", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  gt_tbl <- gt::gt(df)
  result1 <- mrr_gt_theme(gt_tbl)
  result2 <- mrr_gt_theme(result1)
  expect_s3_class(result2, "gt_tbl")
})

test_that("mrr_gt_theme: works with stubhead", {
  skip_if_not_installed("gt")
  df <- data.frame(
    name = c("Alice", "Bob", "Charlie"),
    x = c(1, 2, 3),
    y = c(4, 5, 6)
  )
  gt_tbl <- gt::gt(df) |>
    gt::tab_stubhead(label = "Row")
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})

test_that("mrr_gt_theme: works with grand summary rows", {
  skip_if_not_installed("gt")
  df <- data.frame(x = 1:3, y = 4:6)
  gt_tbl <- gt::gt(df) |>
    gt::grand_summary_rows(
      columns = c(x, y),
      fns = list(label = "Total", fn = "sum")
    )
  result <- mrr_gt_theme(gt_tbl)
  expect_s3_class(result, "gt_tbl")
})
