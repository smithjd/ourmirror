# mrr_palettes.R
#
# Palette-generating functions and ggplot2 scale wrappers for the Societal
# Mirror. All hues are drawn from `shambhala_palette_function()` so the brand
# palette remains the single source of truth. Three families:
#
#   1. Categorical (identity)  — mrr_pal_categorical() / scale_*_mirror_d()
#   2. Sequential (magnitude)  — mrr_pal_sequential() / scale_*_mirror_c/steps()
#   3. Diverging (polarity)    — mrr_pal_stoplight() / scale_fill_stoplight()
#                                + stoplight_ink()

# ---------------------------------------------------------------------------
# 1. Categorical — identity
# ---------------------------------------------------------------------------

#' Categorical brand palette
#'
#' Returns the first `n` Shambhala brand hues in a fixed, never-cycled order
#' (green, blue, crimson, yellow). Use for nominal categories where each series
#' has a stable identity. Requesting more colours than exist is an error rather
#' than silently recycling hues — fold a 9th series into an "Other" category
#' instead of inventing a colour.
#'
#' @param n Number of colours to return. Default: all available brand hues.
#' @return A character vector of hex colours.
#' @examples
#' mrr_pal_categorical(3)
#'
#' @export
mrr_pal_categorical <- function(n = NULL) {
  brand <- shambhala_palette_function()
  # Fixed categorical order — the four saturated brand hues.
  cat_hues <- brand[c("Green", "Blue", "Crimson", "Yellow")]

  if (is.null(n)) {
    return(unname(cat_hues))
  }

  if (n > length(cat_hues)) {
    stop(
      stringr::str_glue(
        "mrr_pal_categorical(): requested {n} colours but only ",
        "{length(cat_hues)} brand hues are available. Fold extra series ",
        "into an 'Other' category rather than cycling colours."
      ),
      call. = FALSE
    )
  }

  unname(cat_hues[seq_len(n)])
}

#' Discrete brand fill scale for ggplot2
#'
#' @param ... Passed on to [ggplot2::discrete_scale()].
#' @return A ggplot2 fill scale.
#' @import ggplot2
#' @export
scale_fill_mirror_d <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = function(n) mrr_pal_categorical(n),
    ...
  )
}

#' Discrete brand colour scale for ggplot2
#'
#' @param ... Passed on to [ggplot2::discrete_scale()].
#' @return A ggplot2 colour scale.
#' @import ggplot2
#' @export
scale_colour_mirror_d <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = function(n) mrr_pal_categorical(n),
    ...
  )
}

#' @rdname scale_colour_mirror_d
#' @export
scale_color_mirror_d <- scale_colour_mirror_d

# ---------------------------------------------------------------------------
# 2. Sequential — magnitude / ordered tiers
# ---------------------------------------------------------------------------

#' Sequential brand ramp
#'
#' Builds a sequential ramp from a single brand hue using
#' `monochromeR::generate_palette()`. Use for ordered magnitude — size tiers,
#' cohort funnels, retention gradients.
#'
#' Two ramp styles via `blend`:
#' * `blend = "white"` (default) lightens the hue toward white and returns the
#'   ramp light -> dark, so the deepest tier is the pure brand hue.
#' * `blend = <hue name or hex>` blends the hue toward another colour and returns
#'   the ramp hue -> blend (e.g. `blend = "Grid"` fades green into the brand
#'   gridline gray). This is the behaviour the legacy [mrr_color_steps()] wraps.
#'
#' @param hue Name of a brand hue from [shambhala_palette_function()]
#'   (e.g. "Green", "Blue", "Crimson", "Yellow"), or a hex colour string to ramp
#'   from directly (covers the brown centre-size ramp). Default: "Green".
#' @param n Number of steps in the ramp.
#' @param blend `"white"` to lighten toward white (default), or a brand hue name
#'   / hex colour to blend the hue toward.
#' @param direction 1 for the natural order described above (default), -1 to
#'   reverse it.
#' @return A character vector of `n` hex colours.
#' @import monochromeR
#' @examples
#' mrr_pal_sequential("Green", 5)
#' mrr_pal_sequential("#7A5C3E", 5)
#' mrr_pal_sequential("Green", 4, blend = "Grid")
#'
#' @export
mrr_pal_sequential <- function(hue = "Green", n, blend = "white", direction = 1) {
  brand <- shambhala_palette_function()

  base_hue <- if (hue %in% names(brand)) brand[[hue]] else hue

  if (identical(blend, "white")) {
    ramp <- suppressMessages(
      monochromeR::generate_palette(
        base_hue,
        modification = "go_lighter",
        n_colours = n
      )
    )
    # go_lighter runs base -> light; present light -> dark so the deepest tier
    # is the pure brand hue.
    ramp <- rev(ramp)
  } else {
    blend_hue <- if (blend %in% names(brand)) brand[[blend]] else blend
    ramp <- suppressMessages(
      monochromeR::generate_palette(
        base_hue,
        blend_colour = blend_hue,
        modification = "blend",
        n_colours = n
      )
    )
    # blend runs hue -> blend_colour; keep that order.
  }

  if (direction == -1) ramp <- rev(ramp)
  unname(ramp)
}

#' Continuous brand fill scale for ggplot2
#'
#' @param hue Brand hue name or hex to ramp from. Default: "Green".
#' @param direction 1 for light -> dark (default), -1 to reverse.
#' @param ... Passed on to [ggplot2::scale_fill_gradientn()].
#' @return A ggplot2 continuous fill scale.
#' @import ggplot2
#' @export
scale_fill_mirror_c <- function(hue = "Green", direction = 1, ...) {
  ggplot2::scale_fill_gradientn(
    colours = mrr_pal_sequential(hue, n = 256, direction = direction),
    ...
  )
}

#' Binned brand fill scale for ggplot2
#'
#' @param hue Brand hue name or hex to ramp from. Default: "Green".
#' @param direction 1 for light -> dark (default), -1 to reverse.
#' @param ... Passed on to [ggplot2::scale_fill_stepsn()].
#' @return A ggplot2 binned fill scale.
#' @import ggplot2
#' @export
scale_fill_mirror_steps <- function(hue = "Green", direction = 1, ...) {
  ggplot2::scale_fill_stepsn(
    colours = mrr_pal_sequential(hue, n = 256, direction = direction),
    ...
  )
}

# ---------------------------------------------------------------------------
# 3. Diverging / stoplight — polarity
# ---------------------------------------------------------------------------

# Brand-anchored soft stoplight ramp. Poles re-anchored on the brand hues and
# softened so they no longer visually jump against the rest of the site.
# Validated for label-ink contrast: soft crimson carries white text; the lighter
# poles carry dark ink. See tasks/color_curation.md (Phase 1).
.mrr_stoplight_hues <- c(
  negative = "#C25B60", # No / Lack / Not satisfied
  mid_low  = "#E8A24A", # Not sure / Considering
  mid      = "#F1C95B", # Somewhat / Partial
  positive = "#5AA678"  # Yes / Enough / Satisfied
)

.mrr_stoplight_residual <- unname(shambhala_palette_function()[["Grid"]])

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
stoplight_ink <- function(fills, white_min = 4) {
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

#' Brand-anchored stoplight (diverging) palette
#'
#' Returns a softened red -> yellow -> green ramp anchored on the brand hues,
#' plus matching label ink for each fill. Use for polarity scales (negative ->
#' positive response categories).
#'
#' @param n Number of fill colours to return (2-4). Interpolated across the
#'   negative -> positive poles. Default: 4 (all poles).
#' @param labels Optional character vector of labels; if supplied the returned
#'   `fill` and `ink` vectors are named by it (length must equal `n`).
#' @return A list with `fill` (hex colours) and `ink` (matching text colours).
#' @examples
#' mrr_pal_stoplight(4)
#' mrr_pal_stoplight(3, labels = c("No", "Somewhat", "Yes"))
#'
#' @export
mrr_pal_stoplight <- function(n = 4, labels = NULL) {
  poles <- unname(.mrr_stoplight_hues)

  if (n < 2 || n > length(poles)) {
    stop(
      stringr::str_glue(
        "mrr_pal_stoplight(): n must be between 2 and {length(poles)}."
      ),
      call. = FALSE
    )
  }

  if (n == length(poles)) {
    fill <- poles
  } else {
    # Interpolate n colours across the full negative -> positive ramp.
    fill <- grDevices::colorRampPalette(poles)(n)
  }

  ink <- stoplight_ink(fill)

  if (!is.null(labels)) {
    if (length(labels) != n) {
      stop(
        stringr::str_glue(
          "mrr_pal_stoplight(): labels has length {length(labels)} but n = {n}."
        ),
        call. = FALSE
      )
    }
    names(fill) <- labels
    names(ink) <- labels
  }

  list(fill = fill, ink = ink)
}

#' Stoplight (diverging) fill scale for ggplot2
#'
#' A discrete fill scale using the brand-anchored stoplight ramp. Colours are
#' assigned in order (negative -> positive), so order your factor levels
#' accordingly.
#'
#' @param ... Passed on to [ggplot2::discrete_scale()].
#' @return A ggplot2 fill scale.
#' @import ggplot2
#' @export
scale_fill_stoplight <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = function(n) mrr_pal_stoplight(n)$fill,
    ...
  )
}
