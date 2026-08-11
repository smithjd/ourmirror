#' single and multiple lollypop plots
#'
#' @description
#' `mrr_single_lolly` creates a lollypop plot for a single variable
#'
#' @importFrom ggplot2 geom_point geom_segment scale_y_continuous coord_flip labs theme element_blank expansion
#' @importFrom stringr str_wrap
#' @importFrom scales percent
#' @importFrom rlang .data
#' @returns plot
#' @param count_df a data frame with variables var_response, c_pct,
#' @export mrr_single_lolly
mrr_single_lolly <- function(count_df) {
  plot <- count_df |>
    ggplot2::ggplot(ggplot2::aes(.data$var_response, .data$c_pct)) +
    ggplot2::geom_point(color = "black",
                        size = 4,
                        shape = 21,
                        fill = lolly_now,
                        alpha = .7) +
    # ggplot2::geom_point(fill = lolly_now, shape = 1, size = 3) +
    ggplot2::geom_segment(ggplot2::aes(
      y = .data$c_pct,
      yend = 0,
      x = .data$var_response,
      xend = .data$var_response
    )) +
    ggplot2::coord_flip() +
    ourmirror::mirror_theme() +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())

  plot
}

#' single and multiple lollypop plots
#'
#' @description
#' `mrr_comparison_lolly` creates a lollypop plot comparing two variables
#'
#' @importFrom ggplot2 geom_point geom_segment scale_y_continuous coord_flip labs theme element_blank aes position_nudge
#' @importFrom stringr str_wrap
#' @importFrom scales percent
#' @importFrom rlang .data
#' @returns plot
#' @param df a data frame containing at least 3 variables: c_pct, c_pct_then, and var_label
#' @export mrr_comparison_lolly
mrr_comparison_lolly <- function(df) {
  ggplot2::ggplot(df) +
    ggplot2::geom_segment(
      aes(
        y = .data$c_pct_then,
        yend = 0,
        x = .data$var_label,
        xend = .data$var_label
      ),
      color = lolly_then,
      position = ggplot2::position_nudge(x = -0.12)
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = .data$var_label, y = .data$c_pct_then),
      color = lolly_then,
      fill = lolly_then,
      size = 4,
      alpha = 1,
      shape = 21,
      position = ggplot2::position_nudge(x = -0.12)
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = .data$var_label,
                   y = .data$c_pct),
      fill = lolly_now,
      color = lolly_now,
      size = 6,
      alpha = 1,
      shape = 21,
      position = ggplot2::position_nudge(x = 0.12)
    ) +
    ggplot2::geom_segment(
      aes(
        y = .data$c_pct,
        yend = 0,
        x = .data$var_label,
        xend = .data$var_label
      ),
      color = lolly_now,
      position = ggplot2::position_nudge(x = 0.12)
    ) +
    ggplot2::coord_flip() +
    ourmirror::mirror_theme() +
    # ggplot2::labs(title = p$var_question) +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank()) -> plot

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
