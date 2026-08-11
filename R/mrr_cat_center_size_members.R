#' Categorize centers by member count into ordered size categories.
#'  Center size is categorized into five categories based on the 2025
#'  distribution of the number of members in the center:
#'    Very Small ( < 10),
#'    Small (11 - 20),
#'    Medium (21 - 50),
#'    Large (51 - 100),
#'    Very Large ( > 101)
#'
#' @param df A data frame with individual member data
#' @param center_var Column identifying centers
#' @param membertype_var Column identifying member types
#' @param center_size_var Name for output size category column
#'
#' @return Data frame with added ordered factor column for center size categories
#' @details Preserves existing group structure of input data frame
#' @importFrom dplyr group_by mutate case_when groups
#' @export
#'
#' @examples
#' \dontrun{
#' center_size_df <- mrr_cat_center_size_members(
#'   df = member_base_data,
#'   center_var = center,
#'   membertype_var = membertype,
#'   center_size_var = center_size
#' )
#'
#' center_size_df |> janitor::tabyl(center_size)
#' }
mrr_cat_center_size_members <- function(df,
                                        center_var = center,
                                        membertype_var = membertype,
                                        center_size_var = center_size) {
  groups_original <- groups(df)

  df |>
    group_by({{ center_var }}) |>
    mutate(
      {{ center_size_var }} := sum({{ membertype_var }} == "Member"),
      {{ center_size_var }} := factor(
        case_when(
          {{ center_size_var }} <= 10 ~ "Very Small ( < 10)",
          {{ center_size_var }} <= 20 ~ "Small (11 - 20)",
          {{ center_size_var }} <= 50 ~ "Medium (21 - 50)",
          {{ center_size_var }} <= 100 ~ "Large (51 - 100)",
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
    ) |>
    group_by(!!!groups_original)
}
