#' Generate a color palette with a specified number of steps
#'
#' Thin wrapper around [mrr_pal_sequential()] kept for backward compatibility.
#' Blends a base brand hue toward a second brand colour (default: the gridline
#' gray), hue -> blend. New code should prefer [mrr_pal_sequential()], which
#' takes hue *names* rather than palette indices.
#'
#' @param color_number An integer specifying the base color palette to use
#' @param levels An integer specifying the number of steps to include in the final palette
#' @param blend_number An integer specifying the color palette to blend with the base palette
#' @return A vector of colors with the specified number of steps
#' @seealso [mrr_pal_sequential()]
#' @examples
#' mrr_color_steps(5, 5, 4)
#'
#' @export mrr_color_steps
mrr_color_steps <-
  function(color_number, levels, blend_number = 4) {
    palette_names <- names(shambhala_palette_function())
    mrr_pal_sequential(
      hue = palette_names[color_number],
      n = levels,
      blend = palette_names[blend_number]
    )
  }

# view_palette(mrr_color_steps(5,3))

#' Generate a symmetric light-to-dark color palette
#'
#' Thin wrapper around `monochromeR::generate_palette()` kept for backward
#' compatibility. Ramps a base brand hue both lighter and darker around itself.
#'
#' @param color_number An integer specifying the base color palette to use
#' @param levels An integer specifying the number of steps to include in the final palette
#' @returns A vector of colors with the specified number of steps
#' @import monochromeR
#' @seealso [mrr_pal_sequential()]
#'
#' @export mrr_color_both_ways
mrr_color_both_ways <- function(color_number, levels) {
  shambhala_palette <- shambhala_palette_function()
  suppressMessages(monochromeR::generate_palette(
    shambhala_palette[color_number],
    modification = "go_both_ways",
    n_colours = levels
  ))
}

# view_palette(mrr_color_both_ways(5, 5))

#' Shambhala color palette function
#'
#' This function creates a color palette for Societal Mirror website.
#'
#' @return A character vector containing the Shambhala color palette.
#'
#' @examples
#' shambhala_palette_function()
#'
#' @export shambhala_palette_function
shambhala_palette_function <- function(){
  shambhala_palette <- c(#"Light Text" = "#516877", # to be used for axes, text that is less important
                         "Light Text" = "#2E3C45", # needs to be a bit darker that first draft!
                         "Header Text" = "#232D34", # To be used for headers on the website
                         "Dark Text" = "#101417",
                         "Grid" = "#DCE0E3",
                         "Green" = "#5AA678",
                         "Crimson" = "#D16471",
                         "Yellow" = "#F1C95B",
                         "Blue" = "#587AA7")

}

# view_palette(shambhala_palette_function())
