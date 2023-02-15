#' Open a connection to the SDB
#'
#' @description
#' `sdb_init` runs 2 queries to insure that downloads come back in utf8 format
#'
#' @param db which of 2 databases to query
#' @returns con object
#' @importFrom RMySQL dbConnect MySQL
#' @importFrom DBI dbSendQuery
#' @export db_init
db_init <- function(db = c("sdb", "network")) {
db_choice <- base::match.arg(db)
  if (db_choice == "sdb") {
  con <- RMySQL::dbConnect(
    RMySQL::MySQL(),
    user = base::Sys.getenv("SDB_USER"),
    password = base::Sys.getenv("SDB_PASSWORD"),
    dbname = "sdb",
    host = base::Sys.getenv("SDB_SERVER_IP"),
    port = 3306
  )
  } else if (db_choice == "network") {
    con <- dbConnect(
      RMySQL::MySQL(),
      user = base::Sys.getenv("SDB_USER"),
      password = base::Sys.getenv("SDB_PASSWORD"),
      dbname = "db26780_25",
      host = base::Sys.getenv("SN_SERVER_IP"), port = 3306
    )
  }
  DBI::dbSendQuery(con, "SET NAMES utf8;")
  DBI::dbSendQuery(con, "SET CHARACTER SET utf8;")
  DBI::dbSendQuery(con, "SET character_set_connection=utf8;")
  con
}
