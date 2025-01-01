#' @importFrom tibble tibble
NULL

#' SDB table "location_type"
#'
#' A convenient copy of SDB table "location_type"
#'
#' @format ## `location_type`
#' A data frame with 8 rows and 2 columns:
#' \describe{
#'   \item{id}{Location Code}
#'   \item{location_type}{Location Type}
#' }
#' @source location_type <- tbl(con, "location_type")
#'   |> collect() |> rename(location_type = name)
"location_type"
