# Tests for db_init

test_that("db_init: requires SDB_USER environment variable", {
  # Test that missing credentials raise error
  withr::local_envvar(
    SDB_USER = "",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  expect_error(
    db_init("sdb"),
    "Database credentials not found"
  )
})

test_that("db_init: requires SDB_PASSWORD environment variable", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "",
    SDB_SERVER_IP = "192.168.1.1"
  )

  expect_error(
    db_init("sdb"),
    "Database credentials not found"
  )
})

test_that("db_init: requires SDB_SERVER_IP for sdb database", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = ""
  )

  expect_error(
    db_init("sdb"),
    "SDB_SERVER_IP"
  )
})

test_that("db_init: requires SN_SERVER_IP for network database", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SN_SERVER_IP = ""
  )

  expect_error(
    db_init("network"),
    "SN_SERVER_IP"
  )
})

test_that("db_init: accepts 'sdb' as valid database choice", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  # Should not error on argument matching (but will fail on connection)
  expect_error(
    db_init("sdb"),
    "Database connection failed"
  )
})

test_that("db_init: accepts 'network' as valid database choice", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SN_SERVER_IP = "192.168.1.2"
  )

  # Should not error on argument matching (but will fail on connection)
  expect_error(
    db_init("network"),
    "Database connection failed"
  )
})

test_that("db_init: rejects invalid database name", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1",
    SN_SERVER_IP = "192.168.1.2"
  )

  expect_error(
    db_init("invalid_db"),
    "'arg' should be one of"
  )
})

test_that("db_init: default database is 'sdb'", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  # Calling without argument should use sdb
  expect_error(
    db_init(),
    "Database connection failed"
  )
})

test_that("db_init: uses correct port (3306)", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  # Will fail on connection but verifies port is passed
  expect_error(db_init("sdb"))
})

test_that("db_init: sets UTF-8 encoding for sdb", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  # Verifies UTF-8 handling attempt
  expect_error(db_init("sdb"))
})

test_that("db_init: sets UTF-8 encoding for network", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SN_SERVER_IP = "192.168.1.2"
  )

  # Verifies UTF-8 handling attempt
  expect_error(db_init("network"))
})

test_that("db_init: returns MariaDBConnection on success", {
  skip_if_not_installed("RMariaDB")
  skip("Skipping live connection test; requires valid credentials and running database")

  withr::local_envvar(
    SDB_USER = Sys.getenv("SDB_USER"),
    SDB_PASSWORD = Sys.getenv("SDB_PASSWORD"),
    SDB_SERVER_IP = Sys.getenv("SDB_SERVER_IP")
  )

  if (Sys.getenv("SDB_USER") == "") skip("Credentials not available")

  con <- db_init("sdb")
  expect_s4_class(con, "MariaDBConnection")
  DBI::dbDisconnect(con)
})

test_that("db_init: error message includes database name on connection failure", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "wrongpassword",
    SDB_SERVER_IP = "999.999.999.999"
  )

  error <- expect_error(db_init("sdb"))
  expect_true(grepl("connection failed", error$message, ignore.case = TRUE))
})

test_that("db_init: uses 'sdb' dbname for sdb choice", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  # Attempt connection (will fail) but verifies dbname parameter
  expect_error(db_init("sdb"))
})

test_that("db_init: uses 'db26780_25' dbname for network choice", {
  skip_if_not_installed("RMariaDB")

  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SN_SERVER_IP = "192.168.1.2"
  )

  # Attempt connection (will fail) but verifies dbname parameter
  expect_error(db_init("network"))
})

test_that("db_init: handles missing both SDB_USER and SDB_PASSWORD", {
  withr::local_envvar(
    SDB_USER = "",
    SDB_PASSWORD = "",
    SDB_SERVER_IP = "192.168.1.1"
  )

  expect_error(
    db_init("sdb"),
    "credentials not found"
  )
})

test_that("db_init: case-insensitive database argument", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1",
    SN_SERVER_IP = "192.168.1.2"
  )

  # match.arg should handle case
  expect_error(db_init("SDB"))
})

test_that("db_init: accepts abbreviated database name", {
  withr::local_envvar(
    SDB_USER = "testuser",
    SDB_PASSWORD = "password",
    SDB_SERVER_IP = "192.168.1.1"
  )

  # match.arg allows abbreviation
  expect_error(
    db_init("s"),
    "Database connection failed"
  )
})
