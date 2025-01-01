#' Categorize values into ordered size categories.
#'  Center size is categorized into five categories based on the 2025
#'  distribution of the number of members in the center:
#'    Very Small ( < 10),
#'    Small (11 - 20),
#'    Medium (21 - 50),
#'    Large (51 - 100),
#'    Very Large ( > 101)
#' @param df A data frame
#' @param n_members_var Variable containing numeric values to categorize
#' @param center_size_category Name for the new categorical variable. Default: "center_size"
#'
#' @return Data frame with added ordered factor column for size categories
#' @export
#'
#' @examples
#' \dontrun{
#'
#' df <- mrr_cat_center_size_count(
#'   base_center_data,
#'   center_members_now,
#'   center_size_category
#' )
#'
#' df |>
#'   ggplot(aes(center_size_category, log(center_members_now))) +
#'   geom_boxplot() +
#'   coord_flip()
#' }
mrr_cat_center_size_count <- function(df, n_members_var,
                                      center_size_category = "center_size") {
  df |>
    mutate(
      {{ center_size_category }} := factor(
        case_when(
          {{ n_members_var }} <= 10 ~ "Very Small ( < 10)",
          {{ n_members_var }} <= 20 ~ "Small (11 - 20)",
          {{ n_members_var }} <= 50 ~ "Medium (21 - 50)",
          {{ n_members_var }} <= 100 ~ "Large (51 - 100)",
          TRUE ~ "Very Large ( > 101)"
        ),
        levels = c(
          "Very Small ( < 10)",
          "Small (11 - 20)",
          "Medium (21 - 50)",
          "Large (51 - 100)",
          "Very Large ( > 101)"
        ), ordered = TRUE
      )
    )
}
