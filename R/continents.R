#' @importFrom tibble tibble
NULL

#' SDB table "continents"
#'
#' A convenient copy of SDB table "continents"
#'
#' @format ## `continents`
#' A data frame with 6 rows and 2 columns:
#' \describe{
#'   \item{continent_id}{record sequence number}
#'   \item{continent_name}{Continent Name}
#' }
#' @source membership <- tbl(con, "continents") |> collect()
"continents"
