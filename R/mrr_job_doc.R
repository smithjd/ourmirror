#' Generates a tibble with information about the job
#'
#' This function generates a tibble with information about the job, including
#' the file name, run date, and R version.
#'
#' @return A tibble with a single column and three rows:
#'   file_doc, run_date, and r_version.
#'
#' @importFrom tibble tibble
#' @importFrom devtools session_info
#' @importFrom here here
#'
#' @export mrr_job_doc
#'
mrr_job_doc <- function() {
  file_name <- paste0(here::here(), "/", mrr_get_last_updated_source())
  run_date <- format(Sys.Date(),"%Y-%m-%d")
  r_version <- devtools::session_info()$platform$version
  documentation_tibble <- tibble::tibble(
    file_doc = c(file_name,
                 run_date,
                 r_version) )
}

#' Get the most recently modified file with specified extensions
#'
#' This function retrieves the most recently modified file with extensions
#' specified by the regular expression pattern. The function searches for
#' files with extensions 'Rmd', 'Qmd', and 'R'. It returns the path of the
#' most recently modified file.
#'
#' @return A character string containing the path of the most recently modified file
#' @importFrom fs dir_ls
#' @importFrom dplyr arrange desc pull select
#' @importFrom tibble as_tibble
#' @export mrr_get_last_updated_source
mrr_get_last_updated_source <- function() {
  fs::dir_ls(regexp = "Rmd$|Qmd$|R$") |>
    as.vector() |>
    fs::file_info() |>
    dplyr::arrange(desc(modification_time)) |>
    select(path) |>
    head(1) |>
    dplyr::pull()
}
