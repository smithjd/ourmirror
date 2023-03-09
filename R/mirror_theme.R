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
mirror_theme <- function(font = "Helvetica", base_size = 14) {
  # font <- "ghandi"
  # on.load() function?
  # font <- "Helvetica"
  ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title.position = "plot",
      # Text format:
      # This sets the font, size, type and colour of text for the chart's title
      plot.title = element_text(
        family = font,
        size = ggplot2::rel(1.4),
        face = "bold",
        hjust = 0,
        color = "#666666",
        margin = ggplot2::margin(0, 0, 0, 10)
      ),
      # This sets the font, size, type and colour of text for the chart's subtitle, as well as setting a margin between the title and the subtitle
      # plot.subtitle = ggplot2::element_text(
      plot.subtitle = element_textbox(
        family = font,
        size = ggplot2::rel(1.2),
        margin = ggplot2::margin(7, 0, 9, 0)
      ),
      # plot.caption = ggplot2::element_blank(),
      # This leaves the caption text element empty, because it is set elsewhere in the finalise plot function

      # Legend format
      # This sets the position and alignment of the legend, removes a title and backround for it and sets the requirements for any text within the legend. The legend may often need some more manual tweaking when it comes to its exact position based on the plot coordinates.
      # legend.position = "top",
      legend.text.align = 0,
      # legend.justification =
      legend.background = ggplot2::element_blank(),
      legend.title = element_text(
        family = font,
        size = ggplot2::rel(.9),
        color = "#666666"
      ),
      # legend.key = ggplot2::element_blank(),
      legend.text = element_text(
        family = font,
        size = ggplot2::rel(.9),
        color = "#666666",
        margin = ggplot2::margin(4, 0, 4, 0)
      ),

      # Axis format
      # This sets the text font, size and colour for the axis test, as well as setting the margins and removes lines and ticks. In some cases, axis lines and axis ticks are things we would want to have in the chart - the cookbook shows examples of how to do so.
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(
        family = font,
        size = ggplot2::rel(1),
        color = "#666666"
      ),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5, b = 10)),
      axis.ticks = ggplot2::element_blank(),
      # axis.line = ggplot2::element_blank(),

      # Grid lines
      # This removes all minor gridlines and adds major y gridlines. In many cases you will want to change this to remove y gridlines and add x gridlines. The cookbook shows you examples for doing so
      panel.grid.minor = ggplot2::element_blank(),
      # panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb"),
      # panel.grid.major.x = ggplot2::element_blank(),

      # Blank background
      # This sets the panel background as blank, removing the standard grey ggplot background colour from the plot
      panel.background = ggplot2::element_blank(),

      # Strip background (#This sets the panel background for facet-wrapped plots to white, removing the standard grey ggplot background colour and sets the title size of the facet-wrap title to font size 22)
      strip.background = ggplot2::element_rect(fill = "white",
                                               linewidth = 0),
      strip.text = ggplot2::element_text(size = ggplot2::rel(1),
                                         hjust = 0)
    )
}
