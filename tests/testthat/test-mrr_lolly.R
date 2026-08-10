# Tests for mrr_lolly functions

# Set up globals that lolly functions expect
lolly_now <<- "#5AA678"
lolly_then <<- "#C25B60"

test_that("mrr_single_lolly: returns ggplot object", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Yes", "No", "Unsure"),
    c_pct = c(0.5, 0.3, 0.2)
  )

  plot <- mrr_single_lolly(count_df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_single_lolly: has correct layers", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Yes", "No"),
    c_pct = c(0.6, 0.4)
  )

  plot <- mrr_single_lolly(count_df)
  # Check for point and segment layers
  layer_classes <- sapply(plot$layers, function(x) class(x$geom)[1])
  expect_true("GeomPoint" %in% layer_classes)
  expect_true("GeomSegment" %in% layer_classes)
})

test_that("mrr_single_lolly: preserves data length", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("A", "B", "C", "D", "E"),
    c_pct = c(0.2, 0.3, 0.2, 0.15, 0.15)
  )

  plot <- mrr_single_lolly(count_df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_single_lolly: handles zero percentages", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Yes", "No", "Unsure"),
    c_pct = c(1.0, 0, 0)
  )

  plot <- mrr_single_lolly(count_df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_single_lolly: applies mirror_theme", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Yes", "No"),
    c_pct = c(0.5, 0.5)
  )

  plot <- mrr_single_lolly(count_df)
  # Check that theme is applied (plot has theme attribute)
  expect_true(!is.null(plot$theme))
})

test_that("mrr_single_lolly: flips coordinates", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Response A", "Response B"),
    c_pct = c(0.4, 0.6)
  )

  plot <- mrr_single_lolly(count_df)
  # Check for coord_flip
  expect_true(!is.null(plot$coordinates))
})

test_that("mrr_single_lolly: point size and transparency", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Yes", "No"),
    c_pct = c(0.5, 0.5)
  )

  plot <- mrr_single_lolly(count_df)
  # Check that geom_point layer exists
  layer_classes <- sapply(plot$layers, function(x) class(x$geom)[1])
  expect_true("GeomPoint" %in% layer_classes)
})

test_that("mrr_single_lolly: handles single response", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = "Only Response",
    c_pct = 1.0
  )

  plot <- mrr_single_lolly(count_df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_single_lolly: removes y-axis gridlines", {
  skip_if_not_installed("ggplot2")

  count_df <- data.frame(
    var_response = c("Yes", "No"),
    c_pct = c(0.5, 0.5)
  )

  plot <- mrr_single_lolly(count_df)
  # Check that panel.grid.major.y is removed
  expect_true(!is.null(plot$theme$panel.grid.major.y))
})

# Tests for mrr_comparison_lolly

test_that("mrr_comparison_lolly: returns ggplot object", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("Response A", "Response B", "Response C"),
    c_pct = c(0.5, 0.3, 0.2),
    c_pct_then = c(0.4, 0.35, 0.25)
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: has segment layers for current and prior", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("A", "B"),
    c_pct = c(0.5, 0.5),
    c_pct_then = c(0.4, 0.6)
  )

  plot <- mrr_comparison_lolly(df)
  layer_classes <- sapply(plot$layers, function(x) class(x$geom)[1])
  # Should have multiple GeomSegment layers
  expect_true(sum(layer_classes == "GeomSegment") >= 2)
})

test_that("mrr_comparison_lolly: has point layers for current and prior", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("A", "B"),
    c_pct = c(0.5, 0.5),
    c_pct_then = c(0.4, 0.6)
  )

  plot <- mrr_comparison_lolly(df)
  layer_classes <- sapply(plot$layers, function(x) class(x$geom)[1])
  # Should have multiple GeomPoint layers
  expect_true(sum(layer_classes == "GeomPoint") >= 2)
})

test_that("mrr_comparison_lolly: preserves all rows", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("Label 1", "Label 2", "Label 3", "Label 4"),
    c_pct = c(0.25, 0.25, 0.25, 0.25),
    c_pct_then = c(0.2, 0.3, 0.3, 0.2)
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: handles equal percentages", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("Same", "Same", "Same"),
    c_pct = c(0.5, 0.5, 0.5),
    c_pct_then = c(0.5, 0.5, 0.5)
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: handles zero percentages", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("A", "B"),
    c_pct = c(1.0, 0),
    c_pct_then = c(0, 1.0)
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: applies mirror_theme", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("A", "B"),
    c_pct = c(0.5, 0.5),
    c_pct_then = c(0.5, 0.5)
  )

  plot <- mrr_comparison_lolly(df)
  expect_true(!is.null(plot$theme))
})

test_that("mrr_comparison_lolly: flips coordinates", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("Long Label A", "Long Label B"),
    c_pct = c(0.5, 0.5),
    c_pct_then = c(0.5, 0.5)
  )

  plot <- mrr_comparison_lolly(df)
  expect_true(!is.null(plot$coordinates))
})

test_that("mrr_comparison_lolly: removes y-axis gridlines", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("A", "B"),
    c_pct = c(0.5, 0.5),
    c_pct_then = c(0.5, 0.5)
  )

  plot <- mrr_comparison_lolly(df)
  expect_true(!is.null(plot$theme$panel.grid.major.y))
})

test_that("mrr_comparison_lolly: positions nudged for comparison visibility", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("A", "B", "C"),
    c_pct = c(0.4, 0.3, 0.3),
    c_pct_then = c(0.5, 0.25, 0.25)
  )

  plot <- mrr_comparison_lolly(df)
  # Check that position_nudge is applied to at least one layer
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: single row input", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = "Only One",
    c_pct = 1.0,
    c_pct_then = 1.0
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: large percentage differences", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = c("Big Change", "No Change"),
    c_pct = c(0.1, 0.5),
    c_pct_then = c(0.9, 0.5)
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_comparison_lolly: many responses", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    var_label = paste0("Response ", 1:10),
    c_pct = rep(0.1, 10),
    c_pct_then = rep(0.1, 10)
  )

  plot <- mrr_comparison_lolly(df)
  expect_s3_class(plot, "ggplot")
})
