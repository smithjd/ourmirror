#' Create a ggplot2 theme
#'
#' @description
#' `mirror_theme` creates a ggplot2 theme
#'
#' @returns ggplot2::theme
#' @importFrom ggplot2 element_blank element_line element_rect element_text margin rel theme theme_minimal
#' @param font default parameter
#' @param base_size default font size
#' @description
#' Consider adding grid lines back with
#'  panel.grid.major.x = element_line(color = shambhala_palette_function()[["Grid"]])
#'
#' @export mirror_theme
mirror_theme <- function(font = "Gandhi Sans", base_size = 16) {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      # This sets the default text color and font across the rest of the text elements
      text = ggplot2::element_text(family = "Ghandi Sans",
                          color = shambhala_palette_function()[["Light Text"]]),
      plot.title.position = "plot",

      # Text format:
      plot.title = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(1.6),
        face = "bold",
        hjust = 0,
        color = shambhala_palette_function()[["Dark Text"]],
        margin = ggplot2::margin(10, 0, 0, 10)
      ),
      plot.subtitle = ggplot2::element_text(
        family = font,
        hjust = 0,
        size = ggplot2::rel(1.1),
        margin = ggplot2::margin(7, 0, 9, 10)
      ),
      plot.background = ggplot2::element_rect(color = NA),

      # Legend format

      legend.text.align = 0,
      legend.background = ggplot2::element_blank(),
      legend.title = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(.9),
        color = shambhala_palette_function()[["Dark Text"]],
      ),
      legend.text = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(.9),
        color = shambhala_palette_function()[["Light Text"]],
        margin = ggplot2::margin(4, 0, 4, 0)
      ),

      # Axis format

      # axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(
        family = font,
        color = shambhala_palette_function()[["Light Text"]],
        size = ggplot2::rel(1),
      ),
      axis.ticks = ggplot2::element_blank(),
      panel.grid.minor = element_blank(),
      # ,S
      panel.grid.major = element_line("grey90", linewidth = 0.5),
      strip.background = ggplot2::element_rect(fill = "white",
                                               linewidth = 0),
      strip.text = ggplot2::element_text(size = ggplot2::rel(1),
                                         hjust = 0)
    )
}
