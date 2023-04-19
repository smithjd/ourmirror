#' Create a ggplot2 theme
#'
#' @description
#' `mirror_theme` creates a ggplot2 theme
#'
#' @returns ggplot2::theme
#' @importFrom ggplot2 element_blank element_line element_rect element_text margin rel theme theme_minimal
#' @param font default parameter
#' @param base_size default font size
#' @export mirror_theme
mirror_theme <- function(font = "Gandhi Sans", base_size = 14) {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      # This sets the default text color and font across the rest of the text elements
      text = element_text(family = "Ghandi Sans",
                          color = shambhala_palette_function()[["Light Text"]]),
      plot.title.position = "plot",
      # Text format:

      plot.title = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(1.4),
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

      # Legend format

      legend.text.align = 0,
      legend.background = ggplot2::element_blank(),
      legend.title = element_text(
        family = font,
        size = ggplot2::rel(.9),
        color = shambhala_palette_function()[["Dark Text"]],
      ),
      legend.text = element_text(
        family = font,
        size = ggplot2::rel(.9),
        color = shambhala_palette_function()[["Light Text"]],
        margin = ggplot2::margin(4, 0, 4, 0)
      ),
      plot.background = element_rect(color = NA),

      # Axis format

      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(
        # We need to reset the font and color within axis text, because theme_minimal() sets its own default
        family = font,
        color = shambhala_palette_function()[["Light Text"]],
        size = ggplot2::rel(1),
      ),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5, b = 10),
                                          color = shambhala_palette_function()[["Light Text"]], ),
      axis.ticks = ggplot2::element_blank(),

      panel.grid.minor = element_line(color = shambhala_palette_function()[["Grid"]]),
      # panel.grid.minor = element_line(color = "#F8F9FA"),
      # panel.grid.minor = ggplot2::element_blank(),
      panel.grid = element_line(color = shambhala_palette_function()[["Grid"]]),

      # Blank background

      panel.background = ggplot2::element_blank(),

      strip.background = ggplot2::element_rect(fill = "white",
                                               linewidth = 0),
      strip.text = ggplot2::element_text(size = ggplot2::rel(1),
                                         hjust = 0)
    )
}
