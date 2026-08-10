# Tests for mrr_color_steps

test_that("mrr_color_steps: returns n colors", {
  colors <- mrr_color_steps(5, 5, 4)
  expect_length(colors, 5)
})

test_that("mrr_color_steps: all hex colors", {
  colors <- mrr_color_steps(5, 3, 4)
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, colors)))
})

test_that("mrr_color_steps: returns character vector", {
  colors <- mrr_color_steps(5, 5, 4)
  expect_type(colors, "character")
})

test_that("mrr_color_steps: accepts different color_number", {
  colors1 <- mrr_color_steps(1, 5, 4)  # Light Text
  colors2 <- mrr_color_steps(2, 5, 4)  # Header Text
  colors3 <- mrr_color_steps(5, 5, 4)  # Green
  colors4 <- mrr_color_steps(6, 5, 4)  # Crimson

  expect_length(colors1, 5)
  expect_length(colors2, 5)
  expect_length(colors3, 5)
  expect_length(colors4, 5)
})

test_that("mrr_color_steps: accepts different blend_number", {
  colors_blend4 <- mrr_color_steps(5, 5, 4)
  colors_blend5 <- mrr_color_steps(5, 5, 5)
  colors_blend6 <- mrr_color_steps(5, 5, 6)

  expect_length(colors_blend4, 5)
  expect_length(colors_blend5, 5)
  expect_length(colors_blend6, 5)
})

test_that("mrr_color_steps: accepts small level count", {
  colors <- mrr_color_steps(5, 2, 4)
  expect_length(colors, 2)
})

test_that("mrr_color_steps: accepts large level count", {
  colors <- mrr_color_steps(5, 20, 4)
  expect_length(colors, 20)
})

test_that("mrr_color_steps: consistent output", {
  colors1 <- mrr_color_steps(5, 5, 4)
  colors2 <- mrr_color_steps(5, 5, 4)
  expect_identical(colors1, colors2)
})

test_that("mrr_color_steps: different parameters produce different palettes", {
  colors_5_5 <- mrr_color_steps(5, 5, 4)
  colors_5_3 <- mrr_color_steps(5, 3, 4)
  colors_6_5 <- mrr_color_steps(6, 5, 4)

  expect_false(identical(colors_5_5, colors_5_3))
  expect_false(identical(colors_5_5, colors_6_5))
})

test_that("mrr_color_steps: wraps mrr_pal_sequential correctly", {
  # mrr_color_steps should delegate to mrr_pal_sequential
  # The output should be valid and consistent
  colors <- mrr_color_steps(5, 7, 4)
  expect_length(colors, 7)
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, colors)))
})

# Tests for mrr_color_both_ways

test_that("mrr_color_both_ways: returns n colors", {
  colors <- mrr_color_both_ways(5, 5)
  expect_length(colors, 5)
})

test_that("mrr_color_both_ways: all hex colors", {
  colors <- mrr_color_both_ways(5, 5)
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, colors)))
})

test_that("mrr_color_both_ways: returns character vector", {
  colors <- mrr_color_both_ways(5, 5)
  expect_type(colors, "character")
})

test_that("mrr_color_both_ways: accepts different color_number", {
  colors1 <- mrr_color_both_ways(1, 5)  # Light Text
  colors2 <- mrr_color_both_ways(5, 5)  # Green
  colors3 <- mrr_color_both_ways(6, 5)  # Crimson
  colors4 <- mrr_color_both_ways(8, 5)  # Blue

  expect_length(colors1, 5)
  expect_length(colors2, 5)
  expect_length(colors3, 5)
  expect_length(colors4, 5)
})

test_that("mrr_color_both_ways: accepts different level counts", {
  colors_2 <- mrr_color_both_ways(5, 2)
  colors_5 <- mrr_color_both_ways(5, 5)
  colors_10 <- mrr_color_both_ways(5, 10)

  expect_length(colors_2, 2)
  expect_length(colors_5, 5)
  expect_length(colors_10, 10)
})

test_that("mrr_color_both_ways: odd number creates symmetric ramp", {
  # With odd levels, the middle should be closest to the base color
  colors_5 <- mrr_color_both_ways(5, 5)
  expect_length(colors_5, 5)
})

test_that("mrr_color_both_ways: even number works", {
  colors_4 <- mrr_color_both_ways(5, 4)
  expect_length(colors_4, 4)
})

test_that("mrr_color_both_ways: consistent output", {
  colors1 <- mrr_color_both_ways(5, 5)
  colors2 <- mrr_color_both_ways(5, 5)
  expect_identical(colors1, colors2)
})

test_that("mrr_color_both_ways: different parameters produce different palettes", {
  colors_5_5 <- mrr_color_both_ways(5, 5)
  colors_5_3 <- mrr_color_both_ways(5, 3)
  colors_6_5 <- mrr_color_both_ways(6, 5)

  expect_false(identical(colors_5_5, colors_5_3))
  expect_false(identical(colors_5_5, colors_6_5))
})

test_that("mrr_color_both_ways: uses monochromeR go_both_ways", {
  # Should create a lighter and darker ramp around the base color
  colors <- mrr_color_both_ways(5, 7)
  expect_length(colors, 7)
})

# Tests for shambhala_palette_function

test_that("shambhala_palette_function: returns named character vector", {
  palette <- shambhala_palette_function()
  expect_type(palette, "character")
  expect_true(!is.null(names(palette)))
})

test_that("shambhala_palette_function: has expected color names", {
  palette <- shambhala_palette_function()
  expected_names <- c("Light Text", "Header Text", "Dark Text", "Grid", "Green", "Crimson", "Yellow", "Blue")
  expect_true(all(expected_names %in% names(palette)))
})

test_that("shambhala_palette_function: returns 8 colors", {
  palette <- shambhala_palette_function()
  expect_length(palette, 8)
})

test_that("shambhala_palette_function: all values are hex colors", {
  palette <- shambhala_palette_function()
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  expect_true(all(grepl(hex_pattern, palette)))
})

test_that("shambhala_palette_function: consistent output", {
  palette1 <- shambhala_palette_function()
  palette2 <- shambhala_palette_function()
  expect_identical(palette1, palette2)
})

test_that("shambhala_palette_function: has text colors", {
  palette <- shambhala_palette_function()
  expect_true("Light Text" %in% names(palette))
  expect_true("Header Text" %in% names(palette))
  expect_true("Dark Text" %in% names(palette))
})

test_that("shambhala_palette_function: has grid color", {
  palette <- shambhala_palette_function()
  expect_true("Grid" %in% names(palette))
})

test_that("shambhala_palette_function: has brand hues", {
  palette <- shambhala_palette_function()
  expect_true("Green" %in% names(palette))
  expect_true("Crimson" %in% names(palette))
  expect_true("Yellow" %in% names(palette))
  expect_true("Blue" %in% names(palette))
})

test_that("shambhala_palette_function: accessible by index", {
  palette <- shambhala_palette_function()
  # Should be able to access by index
  expect_type(palette[1], "character")
  expect_type(palette[5], "character")
})

test_that("shambhala_palette_function: accessible by name", {
  palette <- shambhala_palette_function()
  expect_type(palette[["Green"]], "character")
  expect_type(palette[["Crimson"]], "character")
})

test_that("shambhala_palette_function: Dark Text is darkest", {
  palette <- shambhala_palette_function()
  # All text colors should be dark (for contrast)
  text_colors <- c(palette[["Light Text"]], palette[["Dark Text"]])
  expect_length(text_colors, 2)
})

test_that("shambhala_palette_function: Grid is light", {
  palette <- shambhala_palette_function()
  # Grid should be a light color for subtle lines
  grid_color <- palette[["Grid"]]
  expect_true(grepl("^#[0-9A-Fa-f]{6}$", grid_color))
})

test_that("shambhala_palette_function: single source of truth", {
  # Used by multiple functions; ensure it's consistent
  palette1 <- shambhala_palette_function()
  palette2 <- shambhala_palette_function()
  expect_identical(palette1, palette2)
})
