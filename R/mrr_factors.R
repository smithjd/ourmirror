#' Append Percentages to Categorical Variable Labels
#'
#' This function appends the percentage of observations in each category
#' to the label of a categorial variable.
#'
#' @param factor_var A categorical variable to transform
#'
#' @return A named character vector with original labels appended with percentages
#' @export mrr_append_factor_pct
#'
#' @examples
#' x <- c('A', 'A', 'B', 'C', 'C', 'C')
#' mrr_append_factor_pct(x)
#'
#' @author John David Smith
mrr_append_factor_pct <- function(factor_var) {
  counts <- table(factor_var)
  old_name <- as.vector(unlist(attributes(counts)$dimnames))
  counts <- unclass(counts)
  total <- sum(counts)
  percents <- round(100 * counts / total, 1)
  new_name <- paste0(names(counts), " (", percents, "%)")
  recode_string <- setNames(old_name, new_name)
  return(recode_string)
}
