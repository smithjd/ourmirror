#' Replaces underscores with blanks and capitalizes first letter of each word
#'
#' @param df data frame where column names will be modified
#' @return modified column names with underscores replaced by blanks
#'
#' @usage names(df) <- names_to_titles(df)
#'
#' @examples
#' \dontrun{
#' # names(df) <- names_to_titles(df)
#'}
#'
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_to_title
#' @export names_to_titles
names_to_titles <- function(df) {
  # Replaces underscores with blanks and capitalizes first letter of each word
  # usage:
  #   names(df) <- names_to_titles(df)
  new_names <- str_replace_all(names(df), "_", " ")
  new_names <- str_to_title(new_names)

}
