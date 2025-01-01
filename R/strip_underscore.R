#' Replace Underscores with Spaces in Column Names
#'
#' This function processes data frame column names by replacing underscores with
#' spaces to improve readability, particularly when exporting to Google Sheets.
#'
#' @param df A data frame whose column names will be modified
#'
#' @return A character vector of modified column names with underscores replaced
#'   by spaces
#'
#' @examples
#' df <- data.frame(
#'   customer_id = 1:3,
#'   first_name = c("John", "Jane", "Bob"),
#'   last_login_date = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03"))
#' )
#' names(df) <- strip_underscore(df)
#' # Column names are now "customer id", "first name", "last login date"
#'
#' @importFrom stringr str_replace_all
#' @export
strip_underscore <- function(df) {
  new_names <- str_replace_all(names(df), "_", " ")
  return(new_names)
}
