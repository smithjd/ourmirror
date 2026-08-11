#' Subset Survey Data by Role Flag and Compute Response Counts
#'
#' Filters a survey dataset based on a role or title flag variable (e.g., "Are you
#' a center director?"), then computes frequency counts for specified subject
#' variables and extracts non-empty comments. This is useful for analyzing
#' responses from specific subgroups.
#'
#' @param data A data frame containing survey data with RespondentID
#' @param title_flag_var An unquoted column name for the role/title flag variable.
#'   Rows where this equals 1 are retained.
#' @param subject_vars A character vector of column names to compute counts for
#' @param comment_var An unquoted column name for the comments variable.
#'   Non-empty comments are extracted.
#'
#' @return A named list with three elements:
#'   \describe{
#'     \item{df}{The filtered data frame containing the flag and subject variables}
#'     \item{counts}{A named list of tibbles with frequency counts for each
#'       subject variable, named `n_<var_name>`}
#'     \item{comments}{A tibble containing non-empty comments with column
#'       renamed to "other_comments"}
#'   }
#'
#' @examples
#' \dontrun{
#' # Subset to center directors and analyze their responses
#' q <- mrr_subset_by_role(
#'   m26,
#'   q0035,
#'   c("q0036", "q0037_0001", "q0037_0002"),
#'   q0037_other
#' )
#'
#' # Access the filtered data
#' q$df
#'
#' # Access specific count table
#' q$counts$n_q0036
#'
#' # View comments
#' q$comments
#' }
#'
#' @importFrom dplyr filter select rename count
#' @importFrom purrr map set_names
#' @importFrom rlang .data
#' @export
mrr_subset_by_role <- function(data, title_flag_var, subject_vars, comment_var) {
  df <- data |>
    filter({{ title_flag_var }} == 1) |>
    select({{ title_flag_var }}, all_of(subject_vars))

  comments <- data |>
    filter({{ title_flag_var }} == 1, {{ comment_var }} != "") |>
    rename("other_comments" = {{ comment_var }})

  counts <- map(subject_vars, \(var) count(df, .data[[var]])) |>
    set_names(paste0("n_", subject_vars))

  list(
    df = df,
    counts = counts,
    comments = comments
  )
}
