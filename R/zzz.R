# Suppress R CMD check NOTEs for variables that are intentionally in the calling environment
utils::globalVariables(c(
  # Data frame columns referenced in tidy evaluation contexts
  "dd_all", "df", "tag", "var_name", "var_label", "var_question", "old_var_stub",
  "respondent_id", "c_var_name", "c_var_value", "n_response_count", "c_pct",
  "var_response", "c_pct_then", "center", "membertype", "center_size",
  "modification_time", "path",
  # Environment variables for lollipop colors
  "lolly_now", "lolly_then",
  # Operators from rlang (recognized as undefined in dplyr quoting contexts)
  ":="
))
