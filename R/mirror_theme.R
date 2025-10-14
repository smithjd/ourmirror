#' Custom ggplot2 Theme with Mirror Design
#'
#' Creates a custom theme for ggplot2 based on a minimalist design with carefully
#' styled typography and spacing. The theme features customized text elements,
#' gridlines, and legend formatting optimized for readability.
#'
#' @param font The font family to use for text elements in the plot.
#'   Default: 'Gandhi Sans'
#' @param base_size Base font size in points for scaling text elements.
#'   Default: 16
#' @param grid_color Color for major grid lines. Default: 'grey90'
#' @param grid_size Width of major grid lines. Default: 0.5
#' @param title_size Relative size of the plot title. Default: 1.6
#' @param subtitle_size Relative size of the plot subtitle. Default: 1.1
#'
#' @return A ggplot2 theme object that can be added to plots using the `+` operator
#'
#' @examples
#' \dontrun{
#' # Load required libraries
#'
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   labs(
#'     title = "Car Weight vs Fuel Efficiency",
#'     subtitle = "Data from the mtcars dataset"
#'   ) +
#'   mirror_theme()
#'
#' # Custom styling
#' ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   labs(
#'     title = "Car Weight vs Fuel Efficiency",
#'     subtitle = "Data from the mtcars dataset"
#'   ) +
#'   mirror_theme(
#'     grid_color = "grey80",
#'     grid_size = 0.3,
#'     title_size = 2
#'   )
#' }
#'
#' @import ggplot2
#' @export
mirror_theme <- function(
  font = "Gandhi Sans",
  base_size = 16,
  grid_color = "grey90",
  grid_size = 0.5,
  title_size = 1.6,
  subtitle_size = 1.1
) {
  # Get color palette
  colors <- shambhala_palette_function()

  # Define common text properties
  base_text <- ggplot2::element_text(
    family = font,
    color = colors[["Light Text"]],
    size = base_size
  )

  # Create theme
  ggplot2::theme_minimal(base_size = base_size) %+replace%
    ggplot2::theme(
      # Text elements
      text = base_text,
      plot.title.position = "plot",

      # Title formatting
      plot.title = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(title_size),
        face = "bold",
        hjust = 0,
        color = colors[["Dark Text"]],
        margin = ggplot2::margin(t = 10, r = 0, b = 5, l = 10)
      ),

      # Subtitle formatting
      plot.subtitle = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(subtitle_size),
        hjust = 0,
        margin = ggplot2::margin(t = 0, r = 0, b = 15, l = 10)
      ),

      # Caption formatting
      plot.caption = ggplot2::element_text(
        size = ggplot2::rel(0.8),
        hjust = 1,
        margin = ggplot2::margin(t = 15)
      ),

      # Plot background
      plot.background = ggplot2::element_rect(
        color = NA,
        fill = "white"
      ),

      # Panel formatting
      panel.background = ggplot2::element_rect(
        fill = "white",
        color = NA
      ),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(
        color = grid_color,
        linewidth = grid_size
      ),
      panel.spacing = ggplot2::unit(2, "lines"),
      plot.margin = unit(c(10, 10, 10, 10), "pt"),

      # Legend formatting
      legend.position = "bottom",
      legend.background = ggplot2::element_blank(),
      legend.title = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(0.9),
        color = colors[["Dark Text"]],
        margin = ggplot2::margin(r = 10)
      ),
      legend.text = ggplot2::element_text(
        family = font,
        hjust = 0,
        size = ggplot2::rel(0.8),
        margin = ggplot2::margin(r = 10)
      ),
      legend.key = element_blank(),
      legend.key.size = unit(1, "lines"),
      legend.spacing.x = ggplot2::unit(5, "points"),
      legend.spacing.y = ggplot2::unit(5, "points"),
      legend.margin = ggplot2::margin(t = 10, b = 10),

      # Axis formatting
      axis.title = ggplot2::element_text(
        size = ggplot2::rel(1)
      ),
      axis.title.x = element_text(margin = margin(t = 10)),
      axis.title.y = element_text(margin = margin(r = 10)),
      axis.line = element_blank(), # Explicitly set if intended
      axis.text = ggplot2::element_text(
        size = ggplot2::rel(0.9),
        margin = ggplot2::margin(t = 5, b = 5)
      ),
      axis.ticks = ggplot2::element_blank(),

      # Facet formatting
      strip.background = ggplot2::element_rect(
        fill = "white",
        color = NA
      ),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(1),
        face = "bold",
        hjust = 0,
        margin = ggplot2::margin(t = 10, b = 10)
      ),
      strip.placement = "inside", # or "outside"
      aspect.ratio = NULL, # Can be overridden by user
      complete = complete
    )
}
