#' Pivot Survey Data to Long Format with Percentages
#'
#' Transforms a survey data frame from wide to long format, calculates response
#' frequencies and percentages for each variable. This is useful for preparing
#' survey data for visualization and tabulation.
#'
#' @param df A data frame containing RespondentID and survey response variables
#'
#' @return A tibble in long format with columns:
#'   \describe{
#'     \item{var_name}{Variable name (question identifier)}
#'     \item{value}{Response value as character}
#'     \item{n}{Count of responses}
#'     \item{pct}{Proportion of responses (sums to 1 within each var_name)}
#'   }
#'
#' @details
#' The function:
#' \itemize{
#'   \item Pivots all columns except RespondentID to long format
#'   \item Removes NA values from responses
#'   \item Calculates counts by variable and value
#'   \item Computes percentages within each variable
#'   \item Converts both var_name and value to character for consistency
#' }
#'
#' Percentages are calculated as the share of respondents who gave each answer
#' to a question, so they sum to 100\% within each variable.
#'
#' @examples
#' \dontrun{
#' # Prepare and pivot survey variables
#' df_selected <- mrr_prep_survey_vars(m26, "q0002")
#' df_pivoted <- mrr_pivot_survey(df_selected)
#'
#' # View results
#' df_pivoted |>
#'   filter(var_name == "How satisfied are you?")
#' }
#'
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr count filter mutate group_by ungroup
#' @importFrom labelled to_character
#' @export
mrr_pivot_survey <- function(df) {
  df |>
    pivot_longer(!RespondentID, names_to = "var_name", values_to = "value") |>
    filter(!is.na(value)) |>
    count(var_name, value) |>
    group_by(var_name) |>
    mutate(
      pct = n / sum(n),
      value = to_character(value),
      var_name = to_character(var_name)
    ) |>
    ungroup()
}
