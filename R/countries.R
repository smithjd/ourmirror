#' @importFrom tibble tibble
NULL

#' SDB table "countries"
#'
#' A convenient copy of SDB table "countries"
#'
#' @format ## `countries`
#' A data frame with 241 rows and 6 columns:
#' \describe{
#'   \item{id}{sdb country id}
#'   \item{country}{country name}
#'   \item{country_code}{character country code}
#'   \item{continent}{character continent code}
#'   \item{top_level_domain}{Internet domain}
#'   \item{currency2}{Currency code}
#' }
#' save(countries,
#' file = "data/countries.rda",
#' compress = "xz")

#' @source countries <- tbl(con, "countries") |> collect()
"countries"
