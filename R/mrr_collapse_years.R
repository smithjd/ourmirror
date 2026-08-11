#' Collapse Survey Year-Joined into Grouped Periods
#'
#' Converts a labelled survey variable into a factor and collapses decade-level
#' categories into broader time periods. This is specifically designed for the
#' "What year did you join?" survey question.
#'
#' @param x A labelled or factor variable containing year-joined values with
#'   levels: "1970s", "1980s", "1990s", "2000-2007", "2008-2012", "2013-2017",
#'   "2018-2025".
#'
#' @return A factor with collapsed levels:
#'   \describe{
#'     \item{70's-'80s}{Combined 1970s and 1980s}
#'     \item{90's-2007}{Combined 1990s and 2000-2007}
#'     \item{2008-2017}{Combined 2008-2012 and 2013-2017}
#'     \item{2018-2025}{Unchanged from original}
#'   }
#'
#' @examples
#' \dontrun{
#' # Collapse year-joined in a pipeline
#' m26 |>
#'   mutate(q0080 = mrr_collapse_years(q0080)) |>
#'   count(q0080)
#'
#' # Use in visualization
#' m26 |>
#'   mutate(year_joined = mrr_collapse_years(q0080)) |>
#'   ggplot(aes(year_joined)) +
#'   geom_bar()
#' }
#'
#' @importFrom forcats fct_collapse
#' @export
mrr_collapse_years <- function(x) {
  fct_collapse(
    x,
    "70's-'80s" = c("1970s", "1980s"),
    "90's-2007" = c("1990s", "2000-2007"),
    "2008-2017" = c("2008-2012", "2013-2017")
  )
}
