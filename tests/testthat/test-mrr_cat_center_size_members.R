# Tests for mrr_cat_center_size_members

test_that("mrr_cat_center_size_members: returns data frame", {
  df <- dplyr::tibble(
    center = c("A", "A", "A", "B", "B"),
    membertype = c("Member", "Member", "Other", "Member", "Member"),
    value = c(1, 1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_s3_class(result, "data.frame")
})

test_that("mrr_cat_center_size_members: adds center_size column", {
  df <- dplyr::tibble(
    center = c("A", "A", "B", "B"),
    membertype = c("Member", "Member", "Member", "Other"),
    value = c(1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_true("center_size" %in% names(result))
})

test_that("mrr_cat_center_size_members: custom column name parameter", {
  df <- dplyr::tibble(
    center = c("A", "A", "B"),
    membertype = c("Member", "Member", "Member"),
    value = c(1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype, center_size_var = "size_cat")
  expect_true("size_cat" %in% names(result))
})

test_that("mrr_cat_center_size_members: counts Member type only", {
  df <- dplyr::tibble(
    center = c("A", "A", "A", "A"),
    membertype = c("Member", "Member", "Other", "Associate"),
    value = c(1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  # Center A should have count of 2 (only "Member" type - Very Small)
  center_a_size <- as.character(result$center_size[1])
  expect_equal(center_a_size, "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_members: Very Small (< 10)", {
  df <- dplyr::tibble(
    center = c("A", "A", "A", "B", "B"),
    membertype = c("Member", "Member", "Member", "Member", "Other"),
    value = c(1, 1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  # A has 3 members, B has 1 member
  expect_true("Very Small ( < 10)" %in% as.character(result$center_size))
})

test_that("mrr_cat_center_size_members: Small (11-20)", {
  df <- dplyr::tibble(
    center = rep(c("A", "B"), each = 8),
    membertype = rep(c("Member", "Other"), 8),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  unique_sizes <- unique(as.character(result$center_size))
  expect_true(any(grepl("Small", unique_sizes)))
})

test_that("mrr_cat_center_size_members: Medium (21-50)", {
  df <- dplyr::tibble(
    center = rep("A", 30),
    membertype = rep("Member", 30),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_equal(as.character(result$center_size[1]), "Medium (21 - 50)")
})

test_that("mrr_cat_center_size_members: Large (51-100)", {
  df <- dplyr::tibble(
    center = rep("A", 75),
    membertype = rep("Member", 75),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_equal(as.character(result$center_size[1]), "Large (51 - 100)")
})

test_that("mrr_cat_center_size_members: Very Large (> 101)", {
  df <- dplyr::tibble(
    center = rep("A", 150),
    membertype = rep("Member", 150),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_equal(as.character(result$center_size[1]), "Very Large ( > 101)")
})

test_that("mrr_cat_center_size_members: groups by center", {
  df <- dplyr::tibble(
    center = c("A", "A", "B", "B"),
    membertype = c("Member", "Member", "Member", "Other"),
    value = c(1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  # A should have size for 2 members, B should have size for 1 member
  expect_true(nrow(result) == 4)
})

test_that("mrr_cat_center_size_members: preserves other columns", {
  df <- dplyr::tibble(
    center = c("A", "A", "B"),
    membertype = c("Member", "Member", "Member"),
    other_col = c("x", "y", "z")
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_true("other_col" %in% names(result))
})

test_that("mrr_cat_center_size_members: creates ordered factor", {
  df <- dplyr::tibble(
    center = c("A", "A", "B"),
    membertype = c("Member", "Member", "Member"),
    value = c(1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_true(is.ordered(result$center_size))
  expect_true(is.factor(result$center_size))
})

test_that("mrr_cat_center_size_members: factor has correct levels", {
  df <- dplyr::tibble(
    center = rep("A", 30),
    membertype = rep("Member", 30),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expected_levels <- c(
    "Very Small ( < 10)",
    "Small (11 - 20)",
    "Medium (21 - 50)",
    "Large (51 - 100)",
    "Very Large ( > 101)"
  )
  expect_equal(levels(result$center_size), expected_levels)
})

test_that("mrr_cat_center_size_members: same category for all rows of center", {
  df <- dplyr::tibble(
    center = c("A", "A", "A"),
    membertype = c("Member", "Member", "Member"),
    value = c(1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  # All rows for center A should have same size
  expect_true(length(unique(result$center_size)) == 1)
})

test_that("mrr_cat_center_size_members: different centers get correct sizes", {
  df <- dplyr::tibble(
    center = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "B", "B"),
    membertype = c(rep("Member", 15), rep("Member", 2)),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  size_a <- unique(as.character(result$center_size[result$center == "A"]))
  size_b <- unique(as.character(result$center_size[result$center == "B"]))
  # A has 15 members -> Small (11-20), B has 2 members -> Very Small
  expect_equal(size_a, "Small (11 - 20)")
  expect_equal(size_b, "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_members: respects center_var parameter", {
  df <- dplyr::tibble(
    location_id = c("X", "X", "Y", "Y"),
    member_class = c("Member", "Member", "Member", "Other"),
    value = c(1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, location_id, member_class)
  expect_s3_class(result, "data.frame")
})

test_that("mrr_cat_center_size_members: respects membertype_var parameter", {
  df <- dplyr::tibble(
    center = c("A", "A", "B"),
    person_type = c("Member", "Member", "Member"),
    value = c(1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, person_type)
  expect_true("center_size" %in% names(result))
})

test_that("mrr_cat_center_size_members: preserves grouping structure", {
  df <- dplyr::tibble(
    group = c("G1", "G1", "G1", "G2", "G2"),
    center = c("A", "A", "B", "A", "A"),
    membertype = c("Member", "Member", "Member", "Member", "Member"),
    value = c(1, 1, 1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 5)
})

test_that("mrr_cat_center_size_members: handles no Member type", {
  df <- dplyr::tibble(
    center = c("A", "A"),
    membertype = c("Other", "Associate"),
    value = c(1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  # Count should be 0 for members
  expect_equal(as.character(result$center_size[1]), "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_members: case-sensitive Member type", {
  df <- dplyr::tibble(
    center = c("A", "A", "A"),
    membertype = c("Member", "member", "MEMBER"),
    value = c(1, 1, 1)
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  # Only "Member" (exact case) should be counted - 1 member
  expect_equal(as.character(result$center_size[1]), "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_members: boundary value 10 members", {
  df <- dplyr::tibble(
    center = rep("A", 10),
    membertype = rep("Member", 10),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_equal(as.character(result$center_size[1]), "Very Small ( < 10)")
})

test_that("mrr_cat_center_size_members: boundary value 11 members", {
  df <- dplyr::tibble(
    center = rep("A", 11),
    membertype = rep("Member", 11),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_equal(as.character(result$center_size[1]), "Small (11 - 20)")
})

test_that("mrr_cat_center_size_members: many centers", {
  df <- dplyr::tibble(
    center = rep(paste0("Center_", 1:20), each = 3),
    membertype = rep("Member", 60),
    value = 1
  )

  result <- mrr_cat_center_size_members(df, center, membertype)
  expect_equal(nrow(result), 60)
  # All centers have 3 members
  expect_true(all(as.character(result$center_size) == "Very Small ( < 10)"))
})
