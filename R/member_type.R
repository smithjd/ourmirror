#' @importFrom tibble tibble
NULL

#' SDB table "member_type"
#'
#' A convenient copy of SDB table "membership"
#'
#' @format ## `member_type`
#' A data frame with 6 rows andmember_type2 columns:
#' \describe{
#'   \item{member_type_id}{Member Type ID Number}
#'   \item{member_type_name}{Member Type Label}
#' }
#' @source membership <- tbl(con, "membership") |> collect()
"member_type"
