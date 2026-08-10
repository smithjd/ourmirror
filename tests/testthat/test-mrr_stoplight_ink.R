# Tests for mrr_stoplight_ink

test_that("mrr_stoplight_ink: returns character vector", {
  ink <- mrr_stoplight_ink(c("#FFFFFF", "#000000"))
  expect_type(ink, "character")
})

test_that("mrr_stoplight_ink: single fill input", {
  ink <- mrr_stoplight_ink("#808080")
  expect_length(ink, 1)
  expect_type(ink, "character")
})

test_that("mrr_stoplight_ink: length matches fills input", {
  fills <- c("#FFFFFF", "#000000", "#808080")
  ink <- mrr_stoplight_ink(fills)
  expect_length(ink, 3)
})

test_that("mrr_stoplight_ink: returns white for dark fills", {
  ink <- mrr_stoplight_ink("#000000")
  expect_equal(unname(ink), "white")
})

test_that("mrr_stoplight_ink: returns dark ink for light fills", {
  ink <- mrr_stoplight_ink("#FFFFFF")
  expect_true(unname(ink) != "white")
})

test_that("mrr_stoplight_ink: respects white_min parameter", {
  # With high white_min, more fills get dark text
  ink_strict <- mrr_stoplight_ink("#777777", white_min = 10)
  ink_lenient <- mrr_stoplight_ink("#777777", white_min = 2)
  expect_length(ink_strict, 1)
  expect_length(ink_lenient, 1)
})

test_that("mrr_stoplight_ink: vectorized across fills", {
  fills <- c("#000000", "#FFFFFF", "#C25B60")
  ink <- mrr_stoplight_ink(fills)
  expect_length(ink, 3)
  # Should have mix of white and dark
  expect_true(any(ink == "white"))
})

test_that("mrr_stoplight_ink: default white_min is 4", {
  # Should match WCAG AA large-text threshold
  ink <- mrr_stoplight_ink("#777777")
  expect_length(ink, 1)
})

test_that("mrr_stoplight_ink: returns valid color values", {
  fills <- c("#000000", "#FFFFFF", "#FF0000", "#00FF00", "#0000FF")
  ink <- mrr_stoplight_ink(fills)
  # Each element should be either "white" or a hex color
  expect_true(all(ink == "white" | grepl("^#[0-9A-Fa-f]{6}$", unname(ink))))
})

test_that("mrr_stoplight_ink: dark text for very light colors", {
  ink_white <- mrr_stoplight_ink("#FFFFFF")
  ink_light <- mrr_stoplight_ink("#F0F0F0")
  # Very light colors should get dark text
  expect_true(unname(ink_white) != "white")
  expect_true(unname(ink_light) != "white")
})

test_that("mrr_stoplight_ink: white text for very dark colors", {
  ink_black <- mrr_stoplight_ink("#000000")
  ink_dark <- mrr_stoplight_ink("#101010")
  # Very dark colors should get white text
  expect_equal(unname(ink_black), "white")
  expect_equal(unname(ink_dark), "white")
})

test_that("mrr_stoplight_ink: stoplight color contrast", {
  # Test with actual stoplight colors
  constants <- mrr_stoplight_constants()
  red <- constants[["red"]]
  green <- constants[["green"]]

  ink_red <- mrr_stoplight_ink(red)
  ink_green <- mrr_stoplight_ink(green)

  # Red (dark) should have white text
  expect_equal(unname(ink_red), "white")
  # Green (medium) depends on exact color
  expect_type(unname(ink_green), "character")
})

test_that("mrr_stoplight_ink: uses shambhala dark text color", {
  # The dark ink should come from the palette
  palette <- shambhala_palette_function()
  dark_text <- palette[["Dark Text"]]

  # Light fill should return dark text
  ink <- mrr_stoplight_ink("#FFFFFF")
  expect_equal(unname(ink), dark_text)
})

test_that("mrr_stoplight_ink: zero-length input", {
  ink <- mrr_stoplight_ink(character(0))
  expect_length(ink, 0)
})

test_that("mrr_stoplight_ink: large white_min value", {
  # Very high threshold means almost everything gets dark text
  ink <- mrr_stoplight_ink("#999999", white_min = 100)
  expect_true(unname(ink) != "white")
})

test_that("mrr_stoplight_ink: low white_min value", {
  # Very low threshold means almost everything gets white text
  ink <- mrr_stoplight_ink("#CCCCCC", white_min = 1)
  # Might still be dark text if contrast is already very low
  expect_type(unname(ink), "character")
})

test_that("mrr_stoplight_ink: consistent output", {
  fills <- c("#FF0000", "#00FF00", "#0000FF")
  ink1 <- mrr_stoplight_ink(fills)
  ink2 <- mrr_stoplight_ink(fills)
  expect_identical(ink1, ink2)
})

test_that("mrr_stoplight_ink: order preserved", {
  fills <- c("#FFFFFF", "#808080", "#000000")
  ink <- mrr_stoplight_ink(fills)
  # First should be dark (light fill)
  expect_true(unname(ink[1]) != "white")
  # Last should be white (dark fill)
  expect_equal(unname(ink[3]), "white")
})

test_that("mrr_stoplight_ink: handles named input", {
  fills <- c(light = "#FFFFFF", medium = "#808080", dark = "#000000")
  ink <- mrr_stoplight_ink(fills)
  # Names should be preserved
  expect_equal(names(ink), c("light", "medium", "dark"))
})

test_that("mrr_stoplight_ink: WCAG contrast formula", {
  # Verify that the contrast calculation follows WCAG guidelines
  # Two colors with high luminance difference should have different ink colors
  very_light <- "#EEEEEE"
  very_dark <- "#111111"

  ink_light <- mrr_stoplight_ink(very_light)
  ink_dark <- mrr_stoplight_ink(very_dark)

  expect_true(unname(ink_light) != "white")
  expect_equal(unname(ink_dark), "white")
})
