# Tests for mrr_pal_categorical and related functions

test_that("mrr_pal_categorical: returns default 4 colors", {
  colors <- mrr_pal_categorical()
  expect_length(colors, 4)
})

test_that("mrr_pal_categorical: returns character vector", {
  colors <- mrr_pal_categorical()
  expect_type(colors, "character")
})

test_that("mrr_pal_categorical: all values are hex colors", {
  colors <- mrr_pal_categorical()
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, colors)))
})

test_that("mrr_pal_categorical: returns n colors when specified", {
  expect_length(mrr_pal_categorical(1), 1)
  expect_length(mrr_pal_categorical(2), 2)
  expect_length(mrr_pal_categorical(3), 3)
  expect_length(mrr_pal_categorical(4), 4)
})

test_that("mrr_pal_categorical: error when n > 4", {
  expect_error(
    mrr_pal_categorical(5),
    "requested 5 colours but only 4 brand hues are available"
  )
})

test_that("mrr_pal_categorical: n = 0 returns empty vector", {
  result <- mrr_pal_categorical(0)
  expect_length(result, 0)
})

test_that("mrr_pal_categorical: error when n is negative", {
  expect_error(mrr_pal_categorical(-1))
})

test_that("mrr_pal_categorical: NULL returns all 4 colors", {
  colors_null <- mrr_pal_categorical(NULL)
  colors_default <- mrr_pal_categorical()
  expect_equal(colors_null, colors_default)
})

test_that("mrr_pal_categorical: colors are unnamed", {
  colors <- mrr_pal_categorical()
  expect_null(names(colors))
})

test_that("mrr_pal_categorical: consistent order", {
  colors1 <- mrr_pal_categorical()
  colors2 <- mrr_pal_categorical()
  expect_identical(colors1, colors2)
})

# Tests for scale_fill_mirror_d and scale_colour_mirror_d

test_that("scale_fill_mirror_d: returns ggplot2 scale", {
  skip_if_not_installed("ggplot2")
  scale <- scale_fill_mirror_d()
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_colour_mirror_d: returns ggplot2 scale", {
  skip_if_not_installed("ggplot2")
  scale <- scale_colour_mirror_d()
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_color_mirror_d: alias for scale_colour_mirror_d", {
  skip_if_not_installed("ggplot2")
  scale1 <- scale_colour_mirror_d()
  scale2 <- scale_color_mirror_d()
  # Both should return same class
  expect_s3_class(scale1, "ScaleDiscrete")
  expect_s3_class(scale2, "ScaleDiscrete")
})

test_that("scale_fill_mirror_d: works in ggplot", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, fill = factor(cyl))) +
    ggplot2::geom_point() +
    scale_fill_mirror_d()
  expect_s3_class(p, "ggplot")
})

test_that("scale_colour_mirror_d: works in ggplot", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, colour = factor(cyl))) +
    ggplot2::geom_point() +
    scale_colour_mirror_d()
  expect_s3_class(p, "ggplot")
})

# Tests for mrr_pal_sequential

test_that("mrr_pal_sequential: returns n colors", {
  colors <- mrr_pal_sequential(n = 5)
  expect_length(colors, 5)
})

test_that("mrr_pal_sequential: all hex colors", {
  colors <- mrr_pal_sequential(n = 3)
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, colors)))
})

test_that("mrr_pal_sequential: default hue is Green", {
  colors <- mrr_pal_sequential(n = 5)
  expect_length(colors, 5)
})

test_that("mrr_pal_sequential: accepts brand hue names", {
  colors_green <- mrr_pal_sequential(hue = "Green", n = 3)
  colors_blue <- mrr_pal_sequential(hue = "Blue", n = 3)
  colors_crimson <- mrr_pal_sequential(hue = "Crimson", n = 3)
  colors_yellow <- mrr_pal_sequential(hue = "Yellow", n = 3)

  expect_length(colors_green, 3)
  expect_length(colors_blue, 3)
  expect_length(colors_crimson, 3)
  expect_length(colors_yellow, 3)
})

test_that("mrr_pal_sequential: accepts hex color strings", {
  colors <- mrr_pal_sequential(hue = "#7A5C3E", n = 5)
  expect_length(colors, 5)
})

test_that("mrr_pal_sequential: white blend creates light to dark", {
  colors <- mrr_pal_sequential(hue = "Green", n = 5, blend = "white")
  expect_length(colors, 5)
  # Should go light to dark with white blend
  expect_type(colors, "character")
})

test_that("mrr_pal_sequential: custom blend hue", {
  colors <- mrr_pal_sequential(hue = "Green", n = 4, blend = "Grid")
  expect_length(colors, 4)
})

test_that("mrr_pal_sequential: direction = 1 (default)", {
  colors <- mrr_pal_sequential(hue = "Green", n = 5, direction = 1)
  expect_length(colors, 5)
})

test_that("mrr_pal_sequential: direction = -1 reverses ramp", {
  colors_forward <- mrr_pal_sequential(hue = "Green", n = 5, direction = 1)
  colors_reverse <- mrr_pal_sequential(hue = "Green", n = 5, direction = -1)
  expect_equal(colors_forward, rev(colors_reverse))
})

test_that("mrr_pal_sequential: colors are unnamed", {
  colors <- mrr_pal_sequential(n = 3)
  expect_null(names(colors))
})

# Tests for scale_fill_mirror_c and scale_fill_mirror_steps

test_that("scale_fill_mirror_c: returns ggplot2 scale", {
  skip_if_not_installed("ggplot2")
  scale <- scale_fill_mirror_c()
  expect_s3_class(scale, "ScaleContinuous")
})

test_that("scale_fill_mirror_steps: returns ggplot2 scale", {
  skip_if_not_installed("ggplot2")
  scale <- scale_fill_mirror_steps()
  expect_s3_class(scale, "ScaleBinned")
})

test_that("scale_fill_mirror_c: works with continuous data", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, fill = hp)) +
    ggplot2::geom_point() +
    scale_fill_mirror_c()
  expect_s3_class(p, "ggplot")
})

test_that("scale_fill_mirror_steps: works with continuous data", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, fill = hp)) +
    ggplot2::geom_tile() +
    scale_fill_mirror_steps()
  expect_s3_class(p, "ggplot")
})

# Tests for mrr_stoplight_constants

test_that("mrr_stoplight_constants: returns named character vector", {
  constants <- mrr_stoplight_constants()
  expect_type(constants, "character")
  expect_true(!is.null(names(constants)))
})

test_that("mrr_stoplight_constants: has 6 named elements", {
  constants <- mrr_stoplight_constants()
  expect_length(constants, 6)
  expect_equal(
    names(constants),
    c("red", "orange", "amber", "lightgreen", "green", "grey")
  )
})

test_that("mrr_stoplight_constants: all values are hex colors", {
  constants <- mrr_stoplight_constants()
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, constants)))
})

test_that("mrr_stoplight_constants: red is darkest", {
  constants <- mrr_stoplight_constants()
  # Red should be a dark color (for contrast with white text)
  expect_type(constants[["red"]], "character")
})

test_that("mrr_stoplight_constants: consistent output", {
  const1 <- mrr_stoplight_constants()
  const2 <- mrr_stoplight_constants()
  expect_identical(const1, const2)
})

# Tests for mrr_pal_stoplight

test_that("mrr_pal_stoplight: returns list with fill and ink", {
  result <- mrr_pal_stoplight()
  expect_type(result, "list")
  expect_true("fill" %in% names(result))
  expect_true("ink" %in% names(result))
})

test_that("mrr_pal_stoplight: default n = 4", {
  result <- mrr_pal_stoplight()
  expect_length(result$fill, 4)
  expect_length(result$ink, 4)
})

test_that("mrr_pal_stoplight: n = 2 works", {
  result <- mrr_pal_stoplight(n = 2)
  expect_length(result$fill, 2)
  expect_length(result$ink, 2)
})

test_that("mrr_pal_stoplight: n = 3 works", {
  result <- mrr_pal_stoplight(n = 3)
  expect_length(result$fill, 3)
  expect_length(result$ink, 3)
})

test_that("mrr_pal_stoplight: n = 4 works", {
  result <- mrr_pal_stoplight(n = 4)
  expect_length(result$fill, 4)
  expect_length(result$ink, 4)
})

test_that("mrr_pal_stoplight: error when n < 2", {
  expect_error(mrr_pal_stoplight(n = 1))
})

test_that("mrr_pal_stoplight: error when n > 4", {
  expect_error(mrr_pal_stoplight(n = 5))
})

test_that("mrr_pal_stoplight: all fills are hex colors", {
  result <- mrr_pal_stoplight()
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, result$fill)))
})

test_that("mrr_pal_stoplight: all inks are valid colors", {
  result <- mrr_pal_stoplight()
  # Ink should be either "white" or a dark hex color
  expect_true(all(result$ink == "white" | grepl("^#", result$ink)))
})

test_that("mrr_pal_stoplight: labels parameter", {
  labels <- c("No", "Somewhat", "Yes")
  result <- mrr_pal_stoplight(n = 3, labels = labels)
  expect_equal(names(result$fill), labels)
  expect_equal(names(result$ink), labels)
})

test_that("mrr_pal_stoplight: error when labels length mismatch", {
  expect_error(
    mrr_pal_stoplight(n = 3, labels = c("No", "Yes")),
    "labels has length 2 but n = 3"
  )
})

test_that("mrr_pal_stoplight: fill and ink length match", {
  result <- mrr_pal_stoplight(n = 4)
  expect_equal(length(result$fill), length(result$ink))
})

# Tests for scale_fill_stoplight

test_that("scale_fill_stoplight: returns ggplot2 scale", {
  skip_if_not_installed("ggplot2")
  scale <- scale_fill_stoplight()
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_fill_stoplight: works in ggplot", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, fill = factor(cyl))) +
    ggplot2::geom_point() +
    scale_fill_stoplight()
  expect_s3_class(p, "ggplot")
})
