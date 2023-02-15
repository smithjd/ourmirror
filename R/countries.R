#' @importFrom tibble tibble
NULL

#' SDB table "countries"
#'
#' A convenient copy of SDB table "countries"
#'
#' @format ## `countries`
#' A data frame with 241 rows and 6 columns:
#' \describe{
#'   \item{id}{record sequence number}
#'   \item{country}{country name}
#'   \item{country_code}{numeric country code}
#'   \item{continent}{continent code number}
#'   \item{top_level_domain}{Internet domain}
#'   \item{currency}{Currency}
#' }
#' @source countries <- tbl(con, "countries") |> collect()
"countries"
