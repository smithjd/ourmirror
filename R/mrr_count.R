#' count the frequency of a single variable and join with metadata
#'
#' @description
#' `mrr_get_dd` returns a list that contains metadata
#'
#' @returns params
#' @importFrom dplyr filter count mutate
#' @param c_dfname documented in the dd_all data frame
#' @param c_varname The variable to be documented
#' @export mrr_get_dd
mrr_get_dd <- function(c_dfname, c_varname){
  # returns a list
  dfname <- deparse(match.call()$c_dfname)
  params <- dd_all |>
    dplyr::filter(df == dfname, tag == {{c_varname}} ) |>
    as.list()
  params
}

#' count the frequency of a single variable
#'
#' @description
#' `mrr_count` returns a data frame with the counts and percent of total
#'
#' @returns df_count
#' @importFrom rlang ensym
#' @importFrom dplyr filter count mutate
#' @importFrom tibble as_tibble
#' @param c_df The dataset to be counted
#' @param c_var The variable with values to be counted
#' @export mrr_count
mrr_count <- function(c_df, c_var, c_now = TRUE) {
  # returns a data frame
  my_count_var <- rlang::ensym(c_var)
  # my_df_name <- deparse(match.call()$c_df)
  df_count <- c_df |>
    dplyr::count({{my_count_var}}) |>
    dplyr::filter(!is.na({{my_count_var}})) |>
    # any by_vars could still have NAs
    dplyr::mutate(pct = (n / sum(n)) ) |>
    tibble::as_tibble()
if(c_now == TRUE){
  names(df_count) <- c("c_count_var", "n", "pct")
  } else{
  names(df_count) <- c("c_count_var_then", "n_then", "pct_then")
  }
  df_count
}

#' count the frequency of a single variable
#'
#' @description
#' `mrr_count_multiple_vars` returns a data frame with the counts and percent of total for a series of variables
#'
#' All of the variables in the series must have the same factor structure
#'
#' @returns df_count
#' @importFrom dplyr filter count mutate select group_by
#' @importFrom tidyr pivot_longer
#' @param c_df The dataset to be counted
#' @param c_start_var The first variable in a sequence to be counted
#' @param c_end_var The variable in a sequence to be counted
#' @export mrr_count_multiple_vars
mrr_count_multiple_vars <- function(c_df, c_start_var, c_end_var) {
  dfname <- deparse(match.call()$c_df)
  df_count <- c_df |>
    dplyr::select(respondent_id,
                  {{c_start_var}}:{{c_end_var}}) |>
    tidyr::pivot_longer(names_to = "c_var_name",
                        values_to = "c_var_value",
                        -respondent_id) |>
    dplyr::filter(!is.na(c_var_value)) |>
    dplyr::count(c_var_name, c_var_value, name = "n_response_count") |>
    dplyr::group_by(c_var_name) |>
    dplyr::mutate(pct = n_response_count / sum(n_response_count),
                  df_name = dfname) |>
    dplyr::left_join(dd_all, by = c("c_var_name" = "tag", df_name = "df"))
  df_count
}

#' count the frequency of a single variable
#'
#' @description
#' `mrr_count_var_list` returns a data frame with the counts and percent of total for a list of variables
#'
#' The variables must have the same factor structure
#'
#' @returns df_count
#' @importFrom dplyr filter count mutate select group_by
#' @importFrom tidyr pivot_longer
#' @param c_df The dataset to be counted
#' @param c_var_list The list of variables to be counted
#' @export mrr_count_var_list
#' @example don't run
#' mult_df <- mrr_count_seq_vars(l23,
#' "could_use_curriculum_and_programming",
#' "could_use_offering_introductory_programs")

mrr_count_var_list <- function(c_df, c_var_list) {
  dfname <- deparse(match.call()$c_df)
  select_list <- c("respondent_id", c_var_list)
  df_count <- c_df |>
    dplyr::select(any_of(c(select_list))) |>
    tidyr::pivot_longer(names_to = "c_var_name",
                        values_to = "c_var_value",
                        -respondent_id) |>
    dplyr::filter(!is.na(c_var_value)) |>
    dplyr::count(c_var_name, c_var_value, name = "n_response_count") |>
    dplyr::group_by(c_var_name) |>
    dplyr::mutate(pct = n_response_count / sum(n_response_count),
                  df_name = dfname) |>
    dplyr::left_join(dd_all, by = c("c_var_name" = "tag", df_name = "df"))
  df_count
}
