# Tests for mrr_gmail (structure and signature validation)
# Note: Full integration tests skipped as they require Gmail API authentication

test_that("mrr_gmail: function exists", {
  expect_true(exists("mrr_gmail"))
})

test_that("mrr_gmail: is a function", {
  expect_type(mrr_gmail, "closure")
})

test_that("mrr_gmail: pipeable functions used", {
  # Verifies that the function uses gmailr functions
  fn_text <- paste(deparse(get("mrr_gmail")), collapse = "")
  expect_true(grepl("gm_mime", fn_text))
  expect_true(grepl("gm_to", fn_text))
  expect_true(grepl("gm_from", fn_text))
  expect_true(grepl("gm_subject", fn_text))
  expect_true(grepl("gm_html_body", fn_text))
  expect_true(grepl("gm_send_message", fn_text))
})

test_that("mrr_gmail: chains gmailr functions", {
  # deparse converts pipe to nested calls, but we can verify the chain exists
  fn_text <- paste(deparse(get("mrr_gmail")), collapse = "")
  # Should have multiple gmailr calls chained
  count_calls <- length(gregexpr("gmailr::", fn_text)[[1]])
  expect_true(count_calls >= 6)  # mime, to, from, subject, html_body, send_message
})

test_that("mrr_gmail: HTML body method used", {
  fn_text <- paste(deparse(get("mrr_gmail")), collapse = "")
  expect_true(grepl("gm_html_body", fn_text))
})

test_that("mrr_gmail: function signature correct", {
  # Verify the function has expected parameters
  fn <- get("mrr_gmail")
  params <- names(formals(fn))
  expect_equal(params, c("sender", "recipient", "title", "text"))
})

test_that("mrr_gmail: all parameters are named", {
  fn <- get("mrr_gmail")
  params <- names(formals(fn))
  expect_length(params, 4)
  expect_true(all(nchar(params) > 0))
})

test_that("mrr_gmail: integrates all gmailr builder functions", {
  fn_text <- paste(deparse(get("mrr_gmail")), collapse = "")
  # Verify all the builder chain is present
  expect_true(grepl("gm_mime", fn_text))
  expect_true(grepl("gm_to", fn_text))
  expect_true(grepl("gm_from", fn_text))
  expect_true(grepl("gm_subject", fn_text))
  expect_true(grepl("gm_html_body", fn_text))
})

test_that("mrr_gmail: has send_message call", {
  fn_text <- paste(deparse(get("mrr_gmail")), collapse = "")
  expect_true(grepl("gm_send_message", fn_text))
})

test_that("mrr_gmail: documentation example format", {
  # Verify function follows documented pattern
  fn <- get("mrr_gmail")
  params <- names(formals(fn))
  # Should have sender, recipient, title (subject), text (body)
  expect_true("sender" %in% params)
  expect_true("recipient" %in% params)
  expect_true("title" %in% params)
  expect_true("text" %in% params)
})
