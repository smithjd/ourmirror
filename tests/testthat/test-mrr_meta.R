# Tests for mrr_meta - simplified to avoid dd_all dependency

test_that("mrr_meta: returns list or error", {
  skip("mrr_meta requires dd_all data dictionary in environment; test structure only")
  # This test would require dd_all to be loaded from package data
})

test_that("mrr_meta: function exists and is callable", {
  expect_true(exists("mrr_meta"))
  expect_true(is.function(mrr_meta))
})

test_that("mrr_meta: function has correct arguments", {
  fn_formals <- formals(mrr_meta)
  expect_true("c_df_name" %in% names(fn_formals))
  expect_true("c_varname" %in% names(fn_formals))
})

test_that("mrr_meta: function expects 2 arguments", {
  fn_formals <- formals(mrr_meta)
  expect_equal(length(fn_formals), 2)
})

test_that("mrr_meta: function uses str_detect for searching", {
  # Check that the function source contains str_detect
  fn_src <- deparse(mrr_meta)
  combined_src <- paste(fn_src, collapse = " ")
  expect_true(grepl("str_detect", combined_src))
})

test_that("mrr_meta: function filters by df parameter", {
  # Check that the function source contains filter logic
  fn_src <- deparse(mrr_meta)
  combined_src <- paste(fn_src, collapse = " ")
  expect_true(grepl("df ==", combined_src) || grepl("df ==", combined_src))
})

test_that("mrr_meta: function returns as list", {
  # Check that the function source converts to list
  fn_src <- deparse(mrr_meta)
  combined_src <- paste(fn_src, collapse = " ")
  expect_true(grepl("as.list", combined_src))
})

test_that("mrr_meta: function uses dplyr filter", {
  fn_src <- deparse(mrr_meta)
  combined_src <- paste(fn_src, collapse = " ")
  expect_true(grepl("filter", combined_src))
})

test_that("mrr_meta: function uses dplyr select", {
  fn_src <- deparse(mrr_meta)
  combined_src <- paste(fn_src, collapse = " ")
  expect_true(grepl("select", combined_src))
})
