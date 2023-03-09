#' single and multiple lollypop plots
#'
#' @description
#' `mrr_single_lolly` creates a lollypop plot for a single variable
#'
#' @importFrom ggplot2 geom_point geom_segment scale_y_continuous coord_flip labs theme element_blank expansion
#' @importFrom stringr str_wrap
#' @importFrom scales percent
#' @returns plot
#' @param mrr_params a list containing metadata elements and a data frame named count$df
#' @export mrr_single_lolly
mrr_single_lolly <- function(mrr_params) {
  p <- {{mrr_params}}
  mrr_title <- toString(str_wrap(p$var_label), 47)
  mrr_caption <- toString(str_wrap(p$var_question, 55)) # needs to be a parameter

  plot <- p$count_df |> ggplot2::ggplot(ggplot2::aes(c_count_var, c_pct)) +
    ggplot2::geom_point(color = "black",
                        size = 4,
                        shape = 21,
                        fill = lolly_now,
                        alpha = .7) +
    # ggplot2::geom_point(fill = lolly_now, shape = 1, size = 3) +
    ggplot2::geom_segment(ggplot2::aes(
      y = c_pct,
      yend = 0,
      x = c_count_var,
      xend = c_count_var
    ),
    color = lolly_now ) +
    ggplot2::scale_y_continuous(labels = scales::percent,
                                ggplot2::expansion(mult = c(0, .1))) +
    ggplot2::coord_flip() +
    ourmirror::mirror_theme() +
    ggplot2::labs(title = p$var_question) +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
  plot
}

#' single and multiple lollypop plots
#'
#' @description
#' `mrr_comparison_lolly` creates a lollypop plot comparing two variables
#'
#' @importFrom ggplot2 geom_point geom_segment scale_y_continuous coord_flip labs theme element_blank
#' @importFrom stringr str_wrap
#' @importFrom scales percent
#' @returns plot
#' @param mrr_params a list containing metadata elements and a data frame named count$df
#' @export mrr_comparison_lolly
mrr_comparison_lolly <- function(mrr_params) {
  p <- {{mrr_params}}
  mrr_title <- toString(str_wrap(p$var_label), 47)
  mrr_caption <- toString(str_wrap(p$var_question, 55))

  plot <- p$count_df |> ggplot2::ggplot() +
    ggplot2::geom_point(ggplot2::aes(x = c_count_var, y = c_pct),
                        fill = lolly_now,
                        size = 4,
                        alpha = .7,
                        shape = 21,
                        position = position_nudge(x = 0.05)) +
    ggplot2::geom_point(ggplot2::aes(x = c_count_var, y = c_pct_then),
                        color = lolly_then,
                        fill = lolly_then,
                        size = 4,
                        alpha = .4,
                        shape = 21,
                        position = position_nudge(x = -0.05)) +
    # ggplot2::geom_point(fill = lolly_now, shape = 1, size = 3) +
    ggplot2::geom_segment(aes(
      y = c_pct,
      yend = 0,
      x = c_count_var,
      xend = c_count_var
    ), color = lolly_now, position = position_nudge(x = 0.05)) +
    ggplot2::geom_segment(aes(
      y = c_pct_then,
      yend = 0,
      x = c_count_var,
      xend = c_count_var
    ), color = lolly_then,
    position = position_nudge(x = -0.05) ) +
    ggplot2::scale_y_continuous(labels = scales::percent,
                                ggplot2::expansion(mult = c(0, .1))) +
    ggplot2::coord_flip() +
    ourmirror::mirror_theme() +
    ggplot2::labs(title = p$var_question) +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank()
    )
  # font <- "ghandi"
  # on.load() function?
  # font <- "Helvetica"
  plot
}

# for testing mrr_comparison_lolly

# mrr_meta("m23","q0002_0005")
#
# count_df_now <- m23 |>  mrr_count(c_var = "relate_to_group_or_center") |>
#   mutate(c_count_var = fct_relabel(c_count_var, word, 1))
#
# params <- m23 |>  mrr_get_dd(c_varname =  "relate_to_group_or_center")
# params$count_df23 <- count_df_now
#
# count_df_then <- m22 |>  mrr_count(c_var = "yes_relate_to_a_local_center", c_now = FALSE ) |>
#   mutate(c_count_var_then = fct_relabel(c_count_var_then, word, 1))
#
# params$count_df <- bind_cols(count_df_now, count_df_then)
