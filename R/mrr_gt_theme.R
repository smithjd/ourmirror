#' Custom gt Table Theme with Mirror Design
#'
#' Applies Shambhala brand styling to a `gt` table, matching the visual
#' language of `mirror_theme()` for ggplot2 plots.
#'
#' @param gt_tbl A `gt` table object.
#' @param title_size Font size in pixels for the table title. Default: `20`.
#' @param sub_title_size Font size in pixels for the table subtitle. Default: `14`.
#' @param col_label_size Font size in pixels for column labels. Default: `14`.
#'
#' @return A styled `gt` table object.
#'
#' @examples
#' \dontrun{
#' library(gt)
#'
#' mtcars |>
#'   head(10) |>
#'   gt() |>
#'   mrr_gt_theme()
#' }
#'
#' @import gt
#' @export
mrr_gt_theme <- function(
  gt_tbl,
  title_size = 20,
  sub_title_size = 14,
  col_label_size = 14
) {
  n_rows <- nrow(gt_tbl$`_data`)

  gt_tbl |>
    tab_options(
      data_row.padding = px(6),
      heading.align = "left",
      column_labels.background.color = "#587AA7",
      column_labels.font.weight = "bold",
      column_labels.font.size = px(col_label_size),
      heading.title.font.size = px(title_size),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = px(sub_title_size),
      table_body.hlines.width = px(0),
      stub.border.color = "#587AA7",
      stub.background.color = "#E4E9F0"
    ) |>
    tab_style(
      style = cell_text(
        color = "#587AA7",
        weight = "bold",
        font = "gandisans"
      ),
      locations = cells_title(groups = "title")
    )
}
