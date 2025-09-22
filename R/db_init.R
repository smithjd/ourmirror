#' Initialize Database Connection to the SDB
#'
#' Establishes a connection to either the SDB or Network database using RMariaDB.
#' The function automatically configures UTF-8 character encoding for proper
#' handling of international characters.
#'
#' @param db Character string specifying which database to connect to.
#'   Must be either "sdb" or "network". Default is "sdb".
#'
#' @return A database connection object of class MariaDBConnection.
#'
#' @details
#' The function requires the following environment variables to be set:
  #' \itemize{
  #'   \item \code{SDB_USER}: Database username
  #'   \item \code{SDB_PASSWORD}: Database password
  #'   \item \code{SDB_SERVER_IP}: Server IP address for SDB database
  #'   \item \code{SN_SERVER_IP}: Server IP address for Network database
  #' }
  #'
  #' Both databases connect on port 3306 and use the \code{bigint = "numeric"}
  #' parameter to properly handle unsigned integers.
  #'
  #' @examples
  #' \dontrun{
  #' # Connect to SDB database
  #' con_sdb <- db_init("sdb")
  #'
  #' # Connect to Network database
  #' con_network <- db_init("network")
  #'
  #' # Remember to close connections when done
  #' DBI::dbDisconnect(con_sdb)
  #' DBI::dbDisconnect(con_network)
  #' }
#'
#' @export
#' @importFrom RMariaDB dbConnect MariaDB
#' @importFrom DBI dbSendQuery
db_init <- function(db = c("sdb", "network")) {
  db_choice <- base::match.arg(db)

  # Get environment variables
  user <- base::Sys.getenv("SDB_USER")
  password <- base::Sys.getenv("SDB_PASSWORD")

  # Check if environment variables are set
  if (user == "" || password == "") {
    stop("Database credentials not found. Please set SDB_USER and SDB_PASSWORD environment variables.")
  }

  if (db_choice == "sdb") {
    host <- base::Sys.getenv("SDB_SERVER_IP")
    dbname <- "sdb"
  } else if (db_choice == "network") {
    host <- base::Sys.getenv("SN_SERVER_IP")
    dbname <- "db26780_25"
  }

  if (host == "") {
    stop(paste("Host IP not found. Please set",
               if(db_choice == "sdb") "SDB_SERVER_IP" else "SN_SERVER_IP",
               "environment variable."))
  }

  # Debug output (remove in production)
  cat("Attempting connection to:", host, "database:", dbname, "user:", user, "\n")

  # Attempt connection with explicit error handling
  tryCatch({
    con <- RMariaDB::dbConnect(
      RMariaDB::MariaDB(),
      user = user,
      password = password,
      dbname = dbname,
      host = host,
      port = as.integer(3306),
      bigint = "numeric"
    )

    # Set UTF-8 encoding
    DBI::dbSendQuery(con, "SET NAMES utf8;")
    DBI::dbSendQuery(con, "SET CHARACTER SET utf8;")
    DBI::dbSendQuery(con, "SET character_set_connection=utf8;")

    cat("Connection successful!\n")
    return(con)

  }, error = function(e) {
    cat("Connection failed with error:", e$message, "\n")
    stop("Database connection failed: ", e$message)
  })
}
