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

