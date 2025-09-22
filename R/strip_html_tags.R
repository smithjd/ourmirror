#' Strip HTML tags and decode entities from text
#'
#' Removes HTML tags and decodes common HTML entities from character vectors.
#' Handles NA and empty values gracefully.
#'
#' @param html_string A character vector containing HTML strings to clean
#'
#' @return A character vector with HTML tags removed and entities decoded
#'
#' @examples
#' strip_html_tags("<p>Hello &amp; welcome</p>")
#' strip_html_tags(c("<b>Bold</b>", NA, ""))
#'
#' @export
strip_html_tags <- function(html_string) {
  # Handle NA or empty values vectorized
  if (length(html_string) == 0) {
    return(character(0))
  }

  # Initialize result vector
  result <- character(length(html_string))

  # Process each element
  for (i in seq_along(html_string)) {
    if (is.na(html_string[i]) || html_string[i] == "") {
      result[i] <- html_string[i]
    } else {
      # Remove HTML tags
      no_tags <- gsub("<[^>]*>", "", html_string[i])

      # Decode common HTML entities
      no_tags <- gsub("&nbsp;", " ", no_tags)
      no_tags <- gsub("&amp;", "&", no_tags)
      no_tags <- gsub("&lt;", "<", no_tags)
      no_tags <- gsub("&gt;", ">", no_tags)
      no_tags <- gsub("&quot;", '"', no_tags)

      # Clean up whitespace
      no_tags <- gsub("\\s+", " ", no_tags)
      result[i] <- trimws(no_tags)
    }
  }

  return(result)
}
strip_html_tags <- function(html_string) {
  # Handle NA or empty values vectorized
  if (length(html_string) == 0) {
    return(character(0))
  }

  # Initialize result vector
  result <- character(length(html_string))

  # Process each element
  for (i in seq_along(html_string)) {
    if (is.na(html_string[i]) || html_string[i] == "") {
      result[i] <- html_string[i]
    } else {
      # Remove HTML tags
      no_tags <- gsub("<[^>]*>", "", html_string[i])

      # Decode common HTML entities
      no_tags <- gsub("&nbsp;", " ", no_tags)
      no_tags <- gsub("&amp;", "&", no_tags)
      no_tags <- gsub("&lt;", "<", no_tags)
      no_tags <- gsub("&gt;", ">", no_tags)
      no_tags <- gsub("&quot;", '"', no_tags)

      # Clean up whitespace
      no_tags <- gsub("\\s+", " ", no_tags)
      result[i] <- trimws(no_tags)
    }
  }

  return(result)
}
