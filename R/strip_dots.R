#' Remove Dots from Factor Levels or Character Strings
#'
#' Removes all dots/periods from the levels of a factor variable or from
#' character strings using string replacement. This is useful for cleaning
#' factor levels that contain dots from data imports.
#'
#' @param x A factor, character vector, or other variable. Factors and characters
#'   will have dots removed; other types are returned unchanged.
#'
#' @return A factor or character vector with dots removed, or the original value
#'   if the input is neither factor nor character.
#'
#' @examples
#' # With factors
#' x <- factor(c("a.b", "c.d", "e.f"))
#' strip_dots(x)
#' # Returns factor with levels "ab", "cd", "ef"
#'
#' # With characters
#' y <- c("hello.world", "foo.bar")
#' strip_dots(y)
#' # Returns c("helloworld", "foobar")
#'
#' # With other types (returned unchanged)
#' strip_dots(42)
#' # Returns 42
#'
#' @importFrom forcats fct_relabel
#' @importFrom stringr str_replace_all
#' @export
strip_dots <- function(x) {
  if (is.factor(x)) {
    fct_relabel(x, ~ str_replace_all(., "\\.", ""))
  } else if (is.character(x)) {
    str_replace_all(x, "\\.", "")
  } else {
    x
  }
}
