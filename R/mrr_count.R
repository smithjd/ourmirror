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
  return(params)
}

#' count the frequency of a single variable
#'
#' @description
#' `mrr_count_single` returns a data frame with the counts and percent of total
#'
#' @details
#' Here is an example of using 'mrr_count_single'
#' count_df_now <- m23 |>  mrr_count(c_var = "relate_to_group_or_center") |>
#'   mutate(c_count_var = fct_relabel(c_count_var, word, 1))
#'
#' params <- m23 |>  mrr_get_dd(c_varname =  "relate_to_group_or_center")
#' params$count_df23 <- count_df_now
#'
#' count_df_then <- m22 |>  mrr_count(c_var = "yes_relate_to_a_local_center", c_now = FALSE ) |>
#'   mutate(c_count_var_then = fct_relabel(c_count_var_then, word, 1))
#'
#' params$count_df <- bind_cols(count_df_now, count_df_then)
#'
#' @returns df_count
#' @importFrom rlang ensym
#' @importFrom dplyr filter count mutate
#' @importFrom tibble as_tibble
#' @param c_df The dataset to be counted
#' @param c_var The variable with values to be counted
#' @param c_now A flag that appends "then" to putput variables when set to "FALSE"
#' @export mrr_count_single
mrr_count_single <- function(c_df, c_var, c_now = TRUE) {
  # returns a data frame
  my_df_name <- deparse(substitute(c_df))
  my_count_var <- rlang::ensym(c_var)
  params <- dd_all |>
    dplyr::filter(df == my_df_name, tag == {{c_var}} ) |>
    as.list()
  var_label <- params$var_label
  df_count <- c_df |>
    dplyr::count({{my_count_var}}) |>
    dplyr::filter(!is.na({{my_count_var}})) |>
    # any by_vars could still have NAs
    dplyr::mutate(c_pct = (n / sum(n)) ) |>
    tibble::as_tibble()
  if (c_now) {
    names(df_count) <- c("c_var_name", "c_n", "c_pct" )
  } else{
    names(df_count) <- c("c_count_var_then", "c_n_then", "c_pct_then")
  }
  df_count <- df_count |>
    mutate(var_label = var_label)
  return(df_count)
}

#' count the frequency of a single variable
#'
#' @description
#' `mrr_count_multiple_vars` returns a data frame with the counts and percent of total for a series of variables
#'
#' All of the variables in the series must have the same factor structure
#'
#' @details
#' params <- mrr_get_dd(m23, "people_in_center_can_give_help_emotional_support")
#'
#' params$count_df <- m23 |>
#'   mrr_count_multiple_vars(
#'     c_start_var = people_in_center_can_give_help_emotional_support,
#'     c_end_var = people_in_center_can_give_advice_about_practice_etc,
#'     "m23")
#'
#' @returns df_count
#' @importFrom dplyr filter count mutate select group_by
#' @importFrom tidyr pivot_longer
#' @param c_df The dataset to be counted
#' @param c_start_var The first variable in a sequence to be counted
#' @param c_end_var The variable in a sequence to be counted
#' @param c_df_name the survey id, for chained calls where 'c_df' is not *true*
#' @export mrr_count_multiple_vars
mrr_count_multiple_vars <- function(c_df, c_start_var, c_end_var, c_df_name) {
  c_denominator <- nrow(c_df)
  df_count <- c_df |>
    dplyr::select(respondent_id,
                  {{c_start_var}}:{{c_end_var}}) |>
    mutate(across(everything(), unclass)) |>
    # could have a step at the end that restores factor levels...
    tidyr::pivot_longer(names_to = "c_var_name",
                        values_to = "c_var_value",
                        -respondent_id) |>
    dplyr::filter(!is.na(c_var_value)) |>
    dplyr::count(c_var_name, c_var_value, name = "n_response_count") |>
    dplyr::group_by(c_var_name) |>
    dplyr::mutate(c_pct = (n_response_count / c_denominator),
                  df_name = c_df_name) |>
    dplyr::left_join(dd_all, by = c("c_var_name" = "tag", df_name = "df")) |>
    ungroup()
  return(df_count)
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
#' @param c_df_name the survey id, for chained calls where 'c_df' is not *true*
#' @export mrr_count_var_list
mrr_count_var_list <- function(c_df, c_var_list, c_df_name) {
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
    dplyr::mutate(c_pct = n_response_count / sum(n_response_count),
                  df_name = dfname) |>
    dplyr::left_join(dd_all, by = c("c_var_name" = "tag", df_name = "df"))
  return(df_count)
}

