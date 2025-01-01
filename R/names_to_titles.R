#' Replace Underscores with Spaces and Capitalize Words
#'
#' This function takes a data frame and processes its column names by:
#' 1. Replacing underscores with spaces
#' 2. Capitalizing the first letter of each word
#'
#' @param df A data frame whose column names will be modified
#'
#' @return A character vector of modified column names where underscores are
#'   replaced by spaces and words are capitalized
#'
#' @examples
#' df <- data.frame(
#'   first_name = c("John", "Jane"),
#'   last_name = c("Doe", "Smith"),
#'   birth_date = as.Date(c("1990-01-01", "1992-06-15"))
#' )
#' names(df) <- names_to_titles(df)
#' # Column names are now "First Name", "Last Name", "Birth Date"
#'
#' @importFrom stringr str_replace_all str_to_title
#' @export
names_to_titles <- function(df) {
  # Replaces underscores with spaces and capitalizes first letter of each word
  new_names <- str_replace_all(names(df), "_", " ")
  new_names <- str_to_title(new_names)
  return(new_names)
}
