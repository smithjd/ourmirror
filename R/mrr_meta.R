#' Convenience function to get data dictionary info
#'
#' @description
#' `mrr_meta` returns a list that contains metadata
#'
#' @importFrom dplyr filter select
#' @returns meta_list
#' @param c_df_name documented in the dd_all data frame
#' @param c_varname The variable to be documented
#' @export mrr_meta
mrr_meta <- function(c_df_name, c_varname){
  meta_list <- dd_all |> dplyr::filter(
    df == {{c_df_name}} &
      (tag == {{c_varname}} |
       var_name == {{c_varname}} |
       old_var_stub == {{c_varname}} )) |>
    dplyr::select(df, var_name, tag, old_var_stub, var_label) |>
    as.list()
  meta_list
}
