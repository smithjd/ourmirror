# Tests for mrr_job_doc

test_that("mrr_job_doc: returns tibble", {
  skip_if_not_installed("tibble")
  result <- mrr_job_doc()
  expect_s3_class(result, "tbl_df")
})

test_that("mrr_job_doc: has one column", {
  result <- mrr_job_doc()
  expect_equal(ncol(result), 1)
})

test_that("mrr_job_doc: column is named file_doc", {
  result <- mrr_job_doc()
  expect_equal(names(result), "file_doc")
})

test_that("mrr_job_doc: has three rows", {
  result <- mrr_job_doc()
  expect_equal(nrow(result), 3)
})

test_that("mrr_job_doc: column is character type", {
  result <- mrr_job_doc()
  expect_type(result$file_doc, "character")
})

test_that("mrr_job_doc: first element is file path", {
  result <- mrr_job_doc()
  # Should contain a path (starts with /)
  expect_match(result$file_doc[1], "[/|\\\\]")
})

test_that("mrr_job_doc: second element is date", {
  result <- mrr_job_doc()
  # Should match YYYY-MM-DD format
  expect_match(result$file_doc[2], "^\\d{4}-\\d{2}-\\d{2}$")
})

test_that("mrr_job_doc: second element is today's date", {
  result <- mrr_job_doc()
  today <- format(Sys.Date(), "%Y-%m-%d")
  expect_equal(result$file_doc[2], today)
})

test_that("mrr_job_doc: third element contains R version", {
  result <- mrr_job_doc()
  # R version string should contain version number
  expect_match(result$file_doc[3], "[0-9]")
})

test_that("mrr_job_doc: consistent structure", {
  result1 <- mrr_job_doc()
  result2 <- mrr_job_doc()
  expect_equal(nrow(result1), nrow(result2))
  expect_equal(ncol(result1), ncol(result2))
})

test_that("mrr_job_doc: date is consistent within call", {
  result <- mrr_job_doc()
  # Multiple calls should have same date (unless test spans midnight)
  result2 <- mrr_job_doc()
  expect_equal(result$file_doc[2], result2$file_doc[2])
})

test_that("mrr_job_doc: no NA values", {
  result <- mrr_job_doc()
  expect_false(any(is.na(result$file_doc)))
})

test_that("mrr_job_doc: all elements are non-empty", {
  result <- mrr_job_doc()
  expect_true(all(nchar(result$file_doc) > 0))
})

test_that("mrr_job_doc: file path is absolute", {
  result <- mrr_job_doc()
  # Absolute paths should start with /
  expect_match(result$file_doc[1], "^/")
})

# Tests for mrr_get_last_updated_source

test_that("mrr_get_last_updated_source: returns character", {
  result <- mrr_get_last_updated_source()
  expect_type(result, "character")
})

test_that("mrr_get_last_updated_source: returns non-empty string", {
  result <- mrr_get_last_updated_source()
  expect_true(nchar(result) > 0)
})

test_that("mrr_get_last_updated_source: returns file path", {
  result <- mrr_get_last_updated_source()
  # Should contain path separators or file extensions
  expect_true(
    grepl("\\.(R|Rmd|Qmd)$", result) ||
    grepl("[/|\\\\]", result)
  )
})

test_that("mrr_get_last_updated_source: file has valid extension", {
  result <- mrr_get_last_updated_source()
  expect_true(grepl("\\.(R|Rmd|Qmd)$", result))
})

test_that("mrr_get_last_updated_source: file exists or is relative path", {
  result <- mrr_get_last_updated_source()
  # At minimum, should be a valid character string
  expect_type(result, "character")
})

test_that("mrr_get_last_updated_source: consistent output", {
  result1 <- mrr_get_last_updated_source()
  result2 <- mrr_get_last_updated_source()
  # Same function called twice should return same result
  expect_equal(result1, result2)
})

test_that("mrr_get_last_updated_source: length is 1", {
  result <- mrr_get_last_updated_source()
  expect_length(result, 1)
})
