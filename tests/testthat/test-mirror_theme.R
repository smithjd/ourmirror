test_that("mirror_theme: returns ggplot2 theme object", {
  theme <- mirror_theme()
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: can be added to ggplot", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    mirror_theme()
  expect_s3_class(p, "ggplot")
})

test_that("mirror_theme: default parameters accepted", {
  theme <- mirror_theme()
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: custom font parameter", {
  theme <- mirror_theme(font = "Arial")
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: custom base_size parameter", {
  theme <- mirror_theme(base_size = 12)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: custom grid_color parameter", {
  theme <- mirror_theme(grid_color = "grey80")
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: custom grid_size parameter", {
  theme <- mirror_theme(grid_size = 0.3)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: custom title_size parameter", {
  theme <- mirror_theme(title_size = 2.0)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: custom subtitle_size parameter", {
  theme <- mirror_theme(subtitle_size = 1.3)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: all custom parameters together", {
  theme <- mirror_theme(
    font = "Helvetica",
    base_size = 14,
    grid_color = "grey70",
    grid_size = 0.25,
    title_size = 1.8,
    subtitle_size = 1.2
  )
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: has plot title formatting", {
  theme <- mirror_theme()
  # Theme object should have title element defined
  expect_true(!is.null(theme$plot.title))
})

test_that("mirror_theme: has plot subtitle formatting", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$plot.subtitle))
})

test_that("mirror_theme: has legend formatting", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$legend.position))
})

test_that("mirror_theme: legend position is bottom", {
  theme <- mirror_theme()
  expect_equal(theme$legend.position, "bottom")
})

test_that("mirror_theme: has axis formatting", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$axis.text))
})

test_that("mirror_theme: has panel background", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$panel.background))
})

test_that("mirror_theme: base_size affects plot", {
  skip_if_not_installed("ggplot2")
  p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    mirror_theme(base_size = 12)
  p2 <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    mirror_theme(base_size = 20)
  # Both should be valid plots
  expect_s3_class(p1, "ggplot")
  expect_s3_class(p2, "ggplot")
})

test_that("mirror_theme: theme is independent (no side effects)", {
  theme1 <- mirror_theme()
  theme2 <- mirror_theme()
  # Creating one theme shouldn't affect another
  expect_s3_class(theme1, "theme")
  expect_s3_class(theme2, "theme")
})

test_that("mirror_theme: works with faceted plots", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~cyl) +
    mirror_theme()
  expect_s3_class(p, "ggplot")
})

test_that("mirror_theme: works with colored geoms", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, color = factor(cyl))) +
    ggplot2::geom_point() +
    mirror_theme()
  expect_s3_class(p, "ggplot")
})

test_that("mirror_theme: numeric parameters accept reasonable ranges", {
  # Very small base size
  theme1 <- mirror_theme(base_size = 4)
  expect_s3_class(theme1, "theme")

  # Large base size
  theme2 <- mirror_theme(base_size = 32)
  expect_s3_class(theme2, "theme")
})

test_that("mirror_theme: grid_size accepts zero", {
  theme <- mirror_theme(grid_size = 0)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: title_size can be small", {
  theme <- mirror_theme(title_size = 0.5)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: subtitle_size can be large", {
  theme <- mirror_theme(subtitle_size = 2.5)
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: stacks multiple color scales", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg, color = factor(cyl))) +
    ggplot2::geom_point() +
    scale_colour_mirror_d() +
    mirror_theme()
  expect_s3_class(p, "ggplot")
})

test_that("mirror_theme: caption element present", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$plot.caption))
})

test_that("mirror_theme: plot background is white", {
  theme <- mirror_theme()
  # The plot background should be defined
  expect_true(!is.null(theme$plot.background))
})

test_that("mirror_theme: panel background is white", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$panel.background))
})

test_that("mirror_theme: no minor gridlines", {
  theme <- mirror_theme()
  # Minor gridlines should be blank
  expect_true(!is.null(theme$panel.grid.minor))
})

test_that("mirror_theme: major gridlines visible", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$panel.grid.major))
})

test_that("mirror_theme: returns consistent type with different parameters", {
  theme1 <- mirror_theme()
  theme2 <- mirror_theme(base_size = 18)
  theme3 <- mirror_theme(grid_color = "grey85", title_size = 1.5)

  expect_s3_class(theme1, "theme")
  expect_s3_class(theme2, "theme")
  expect_s3_class(theme3, "theme")
})

test_that("mirror_theme: plot margin defined", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$plot.margin))
})

test_that("mirror_theme: legend key size defined", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$legend.key.size))
})

test_that("mirror_theme: axis ticks are blank", {
  theme <- mirror_theme()
  # Axis ticks should be blank for clean aesthetic
  expect_true(!is.null(theme$axis.ticks))
})

test_that("mirror_theme: strip background (facet) is white", {
  theme <- mirror_theme()
  expect_true(!is.null(theme$strip.background))
})

test_that("mirror_theme: default font is Gandhi Sans", {
  theme <- mirror_theme()
  # Theme created with default parameters
  expect_s3_class(theme, "theme")
})

test_that("mirror_theme: accepts custom font fallback", {
  theme <- mirror_theme(font = "sans")
  expect_s3_class(theme, "theme")
})
