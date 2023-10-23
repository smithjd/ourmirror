#' Replaces underscores with blanks for readability in a google spreadsheet
#'
#' @param df data frame where column names will be modified
#' @return modified column names with underscores replaced by blanks
#'
#' @examples
#' \dontrun{
#' # names(df) <- strip_underscore(df)
#'}
#'
#' @importFrom stringr str_replace_all
#' @export strip_underscore

strip_underscore <- function(df) {
  # replaces underscores with blanks for readibility in a google spreadsheet
  # usage:
  #   names(df) <- strip_underscore(df)
  str_replace_all(names(df), "_", " ")
}
