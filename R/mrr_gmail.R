#' Send email using Gmail API
#'
#' This function allows you to send an email using the Gmail API.
#'
#' @param sender The email address of the sender.
#' @param recipient The email address of the recipient.
#' @param title The subject of the email.
#' @param text The HTML content of the email.
#'
#' @importFrom gmailr gm_mime
#' @importFrom gmailr gm_to
#' @importFrom gmailr gm_from
#' @importFrom gmailr gm_subject
#' @importFrom gmailr gm_html_body
#' @importFrom gmailr gm_send_message
#'
#' @export mrr_gmail
#'
#' @examples
#' # example code
#' # assumes https://gmailr.r-lib.org/dev/articles/oauth-client.html
#'
#'\dontrun{
#' # Simple single email example
#' mrr_gmail("john.smith@shambhala.info", "jd8.smith@gmail.com",
#'   "Hello", "Here is my list:<ul><li>Some text</li><li>More</li></ul>")
#'
#' # Sending personalized emails from a data frame
#' library(dplyr)
#' library(glue)
#' library(purrr)
#'
#' # Create data frame with recipient information
#' email_data <- tibble(
#'   recipient = c("alice@example.com", "bob@example.com", "charlie@example.com"),
#'   name = c("Alice", "Bob", "Charlie"),
#'   string_inserted = c("favorite books", "project updates", "meeting notes")
#' )
#'
#' # Function to send personalized emails
#' send_personalized_emails <- function(email_df, sender_email) {
#'   email_df |>
#'     pwalk(function(recipient, name, string_inserted) {
#'       # Create personalized email body using glue
#'       body <- glue(
#'         "<p>Dear {name},</p>
#'          <p>Here is my list of {string_inserted}:</p>
#'          <ul>
#'            <li>Some text</li>
#'            <li>More</li>
#'          </ul>
#'          <p>Best regards</p>"
#'       )
#'
#'       # Create personalized subject
#'       subject <- glue("Hello {name}")
#'
#'       # Send the email
#'       mrr_gmail(sender_email, recipient, subject, body)
#'
#'       cat("Email sent to:", recipient, "(", name, ")\n")
#'     })
#' }
#'
#' # Test with single recipient first
#' test_email <- tibble(
#'   recipient = "jd8.smith@gmail.com",
#'   name = "Test User",
#'   string_inserted = "test items"
#' )
#' send_personalized_emails(test_email, "john.smith@shambhala.info")
#'
#' # Then send to all recipients
#' send_personalized_emails(email_data, "john.smith@shambhala.info")
#'}
mrr_gmail <- function(sender, recipient, title, text) {
  email <- gmailr::gm_mime() |>
    gmailr::gm_to(recipient) |>
    gmailr::gm_from(sender) |>
    gmailr::gm_subject(title) |>
    gmailr::gm_html_body(text)

  email |>
    gmailr::gm_send_message()
}
