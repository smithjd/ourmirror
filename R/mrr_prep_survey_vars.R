#' Prepare Survey Variables for Analysis
#'
#' Selects specific columns from a survey data frame based on a variable tag prefix,
#' removes character columns (typically open-ended comments), and optionally
#' relabels columns with their variable labels from the SPSS metadata.
#'
#' @param df A survey data frame containing RespondentID and labelled variables
#' @param var_tag Character string prefix to match column names (e.g., "q0002")
#' @param relabel Logical; if TRUE (default), rename columns using their variable
#'   labels. If FALSE, keep original column names.
#'
#' @return A data frame with RespondentID and selected variables, optionally relabeled
#'
#' @examples
#' \dontrun{
#' # Select and relabel all q0002 variables
#' df_selected <- mrr_prep_survey_vars(m26, "q0002")
#'
#' # Select without relabeling
#' df_raw <- mrr_prep_survey_vars(m26, "q0002", relabel = FALSE)
#' }
#'
#' @importFrom dplyr select
#' @importFrom labelled var_label
#' @importFrom stringr str_trim
#' @export
mrr_prep_survey_vars <- function(df, var_tag, relabel = TRUE) {
  labeled_df <- df |>
    select(RespondentID, starts_with(var_tag), -where(is.character))

  if (relabel) {
    var_vector <- labeled_df |>
      var_label() |>
      as.character() |>
      str_trim()

    names(labeled_df) <- var_vector
  }

  labeled_df
}
