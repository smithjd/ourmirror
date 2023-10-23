#' Send email using Gmail API
#'
#' This function allows you to send an email using the Gmail API.
#'
#' @param sender The email address of the sender.
#' @param recipient The email address of the recipient.
#' @param title The subject of the email.
#' @param text The content of the email.
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
#'
#'\dontrun{
#' mrr_gmail("sender@gmail.com", "recipient@gmail.com",
#' "Hello", "This is the body of the email.")
#'}
mrr_gmail <- function(sender, recipient, title, text) {
  email <- gmailr::gm_mime() |>
    gmailr::gm_to(recipient) |>
    gmailr::gm_from(sender) |>
    gmailr::gm_subject(title) |>
    gmailr::gm_html_body(text)

  email  |>
    gmailr::gm_send_message()
}
