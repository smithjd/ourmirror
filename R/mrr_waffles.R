#' Creates a waffle plot with perceived membership data
#'
#' This function creates a waffle plot of perceived membership data using ggplot2 and geom_waffle packages.
#'
#' @import ggplot2
#' @importFrom waffle geom_waffle
#' @param df A dataframe with perceived membership data.
#' @param fill_var A factor representing the classification categories in the dataframe
#' @param values_var A numeric vector with the percentage of people belonging to each category
#' @return A waffle plot of the data classified in the dataframe
#' @export mrr_waffle
mrr_waffle <- function(df, fill_var, values_var) {
  ggplot2::ggplot(df, aes(fill = {{fill_var}},
                          values = {{values_var}})) +
    waffle::geom_waffle(
      n_rows = 10,
      make_proportional = TRUE,
      colour = "white"
    ) +
    ggplot2::scale_x_discrete(labels = NULL) +
    ggplot2::scale_y_discrete(labels = NULL) +
    ggplot2::coord_flip() +
    ggplot2::labs(
      y = NULL,
      x = NULL,
      fill = NULL,
      color = NULL,
      values = NULL
    ) +
    ourmirror::mirror_theme() +
    ggplot2::theme(legend.position = "right",
                   axis.text = ggplot2::element_blank(),
                   panel.grid = ggplot2::element_blank(),
                   axis.ticks.x = ggplot2::element_blank(),
    )
}
