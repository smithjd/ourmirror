#' Choose readable text ink for a set of fill colours
#'
#' Returns "white" or the brand dark-ink colour per fill. White is preferred
#' whenever it clears a WCAG 4:1 contrast ratio against the fill (dark fills read
#' best with white labels); otherwise dark ink is used. This keeps the darker
#' stoplight poles (e.g. soft crimson) on white text while the lighter poles fall
#' to dark ink.
#'
#' @param fills A character vector of hex fill colours.
#' @param white_min Minimum white-on-fill contrast for white to be chosen.
#'   Default: 4 (WCAG AA large-text / graphical-object threshold).
#' @return A character vector of ink colours, parallel to `fills`.
#' @export
mrr_stoplight_ink <- function(fills, white_min = 4) {
  ink_dark <- shambhala_palette_function()[["Dark Text"]]

  # Relative luminance (WCAG) for contrast comparison.
  rel_lum <- function(hex) {
    rgb <- grDevices::col2rgb(hex) / 255
    lin <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
    0.2126 * lin[1, ] + 0.7152 * lin[2, ] + 0.0722 * lin[3, ]
  }

  contrast <- function(a, b) {
    la <- rel_lum(a)
    lb <- rel_lum(b)
    (pmax(la, lb) + 0.05) / (pmin(la, lb) + 0.05)
  }

  ifelse(
    contrast(fills, "white") >= white_min,
    "white",
    ink_dark
  )
}
