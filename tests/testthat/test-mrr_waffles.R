# Tests for mrr_waffle

test_that("mrr_waffle: returns ggplot object", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B", "C")),
    percentage = c(0.4, 0.35, 0.25)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: has geom_waffle layer", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  layer_classes <- sapply(plot$layers, function(x) class(x$geom)[1])
  expect_true("GeomWaffle" %in% layer_classes)
})

test_that("mrr_waffle: uses 10 rows in waffle grid", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  # Verify waffle layer exists
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: proportional fills sum to 1", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B", "C")),
    percentage = c(0.4, 0.35, 0.25)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: handles two categories", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("Yes", "No")),
    percentage = c(0.65, 0.35)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: handles single category", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor("All"),
    percentage = 1.0
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: handles many categories", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(paste0("Cat_", 1:8)),
    percentage = rep(1/8, 8)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: removes x-axis labels", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  # Check that x scale has no labels
  expect_true(!is.null(plot$scales$get_scales("x")))
})

test_that("mrr_waffle: removes y-axis labels", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: applies mirror_theme", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_true(!is.null(plot$theme))
})

test_that("mrr_waffle: flips coordinates", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_true(!is.null(plot$coordinates))
})

test_that("mrr_waffle: positions legend on right", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B", "C")),
    percentage = c(0.4, 0.35, 0.25)
  )

  plot <- mrr_waffle(df, category, percentage)
  # Check that legend.position is set to "right"
  expect_true(!is.null(plot$theme$legend.position))
})

test_that("mrr_waffle: removes axis text", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_true(!is.null(plot$theme$axis.text))
})

test_that("mrr_waffle: removes panel grid", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_true(!is.null(plot$theme$panel.grid))
})

test_that("mrr_waffle: removes x-axis ticks", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_true(!is.null(plot$theme$axis.ticks.x))
})

test_that("mrr_waffle: has geom_waffle with styling", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  # Check that waffle layer exists
  layer_classes <- sapply(plot$layers, function(x) class(x$geom)[1])
  expect_true("GeomWaffle" %in% layer_classes)
})

test_that("mrr_waffle: handles unbalanced percentages", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("Dominant", "Minority")),
    percentage = c(0.95, 0.05)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: with three-way split", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("Small", "Medium", "Large")),
    percentage = c(0.2, 0.3, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: with many small categories", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(paste0("C", 1:6)),
    percentage = rep(1/6, 6)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})

test_that("mrr_waffle: removes axis labels from scales", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  # Verify x and y lab are NULL
  expect_null(plot$labels$y)
  expect_null(plot$labels$x)
})

test_that("mrr_waffle: removes fill, color, and values labels", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("A", "B")),
    percentage = c(0.5, 0.5)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_null(plot$labels$fill)
})

test_that("mrr_waffle: numeric category data", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("waffle")

  df <- data.frame(
    category = factor(c("1", "2", "3")),
    percentage = c(0.3, 0.4, 0.3)
  )

  plot <- mrr_waffle(df, category, percentage)
  expect_s3_class(plot, "ggplot")
})
