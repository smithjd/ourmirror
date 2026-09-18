#' Open SDB Connection in Positron Connections Pane
#'
#' Opens an interactive database connection in the Positron Connections pane,
#' allowing you to explore database tables and data through the IDE's UI.
#' This function uses the connections package to integrate with Positron's
#' Connections pane.
#'
#' @param db Character string specifying which database to connect to.
#'   Must be either "sdb" or "network". Default is "sdb".
#' @param name Character string for the connection display name in the
#'   Connections pane. Default is "SDB (Shambhala Database)" for sdb
#'   or "Network Database" for network.
#'
#' @return A connection object opened in the Positron Connections pane.
#'   The connection is also returned invisibly for programmatic use.
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
#' This function is designed for interactive exploration of the database
#' through Positron's Connections pane. For programmatic access, use
#' \code{\link{sdb_connect}} instead.
#'
#' @examples
#' \dontrun{
#' # Open SDB connection in Connections pane
#' sdb_open_connection()
#'
#' # Open Network database connection
#' sdb_open_connection(db = "network")
#'
#' # Customize the display name
#' sdb_open_connection(name = "My SDB Connection")
#' }
#'
#' @seealso \code{\link{sdb_connect}} for programmatic database connections
#' @export
sdb_open_connection <- function(db = "sdb", name = NULL) {
  # Validate db parameter
  if (!db %in% c("sdb", "network")) {
    stop('db must be either "sdb" or "network"')
  }
  
  # Set default connection name if not provided
  if (is.null(name)) {
    name <- if (db == "sdb") {
      "SDB (Shambhala Database)"
    } else {
      "Network Database"
    }
  }
  
  # Determine server IP based on database selection
  server_ip <- if (db == "sdb") {
    Sys.getenv("SDB_SERVER_IP")
  } else {
    Sys.getenv("SN_SERVER_IP")
  }
  
  # Check for required environment variables
  user <- Sys.getenv("SDB_USER")
  password <- Sys.getenv("SDB_PASSWORD")
  
  if (server_ip == "" || user == "" || password == "") {
    stop("Required environment variables not set. Please ensure SDB_USER, SDB_PASSWORD, and ",
         if (db == "sdb") "SDB_SERVER_IP" else "SN_SERVER_IP", " are configured.")
  }
  
  # Create the connection using the connections package
  con <- connections::connection_open(
    RMariaDB::MariaDB(),
    host = server_ip,
    user = user,
    password = password,
    db = db,
    port = 3306,
    name = name
  )
  
  message("\u2713 ", name, " connection opened in Positron's Connections pane!")
  message("You can now explore the database tables via the Connections interface.")
  
  invisible(con)
}
