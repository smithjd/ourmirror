# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

`ourmirror` is an R package providing shared utilities for SGS-IT (Shambhala Global Services IT) data analysis work. It standardizes ggplot2 themes, provides database connectivity to the SDB (Shambhala Database) and Network databases, and includes survey data analysis helpers.

## Common Commands

```r
# Document and rebuild package (run in R console after editing R/ files)
devtools::document()
devtools::load_all()

# Install package
devtools::install()

# Check package
devtools::check()

# Run a specific test (if tests exist)
devtools::test()
```

## Architecture

### Visualization (`mirror_theme.R`, `mrr_color_levels.R`, `mrr_lolly.R`, `mrr_waffles.R`)

- `mirror_theme()` — the standard ggplot2 theme for all SGS-IT plots. Uses "Gandhi Sans" font and Shambhala brand colors. Always add to ggplots.
- `shambhala_palette_function()` — returns the named Shambhala color palette vector (Light Text, Header Text, Dark Text, Grid, Green, Crimson, Yellow, Blue). Used internally by `mirror_theme()`.
- `mrr_color_steps()` / `mrr_color_both_ways()` — generate blended palettes from the Shambhala palette using `monochromeR`.
- `mrr_single_lolly()` / `mrr_comparison_lolly()` — lollipop plots for survey response frequencies; comparison variant shows current vs. prior wave side-by-side.
- `mrr_waffle()` — waffle plot wrapper for membership/category data.

### Database (`db_init.R`)

- `db_init(db = "sdb" | "network")` — connects to MariaDB via `RMariaDB`. Requires env vars: `SDB_USER`, `SDB_PASSWORD`, `SDB_SERVER_IP` (for "sdb"), `SN_SERVER_IP` (for "network"). Sets UTF-8 encoding on connect.

### Survey Data Analysis (`mrr_count.R`, `mrr_meta.R`, `mrr_factors.R`)

The `mrr_*` functions are designed around a `dd_all` data dictionary (loaded as package data or from the SDB) that maps variable names/tags across survey waves.

- `mrr_get_dd(c_dfname, c_varname)` — look up variable metadata from `dd_all` by df name and tag.
- `mrr_meta(c_df_name, c_varname)` — broader metadata search across tag, var_name, and old_var_stub fields.
- `mrr_count_var_sequence(c_df, c_start_var, c_end_var, c_df_name)` — counts a range of consecutive variables (e.g., a Likert battery) and joins results to `dd_all`.
- `mrr_count_var_list(c_df, c_var_list, c_df_name)` — counts a specified list of variables.
- `mrr_get_classifying_vars()` / `mrr_get_multi_vars()` — extract respondent_id plus demographic or response variables, pivoted long.
- `mrr_append_factor_pct(factor_var)` — returns a recode vector to append percentages to factor labels; use with `fct_recode(factor, !!!result)`.

### Categorization (`mrr_cat_center_size_count.R`, `mrr_cat_center_size_members.R`)

- `mrr_cat_center_size_count()` — adds an ordered factor column categorizing centers by member count into 5 tiers (Very Small to Very Large).

### Package Data (`data/`)

Four `.rda` files mirror SDB lookup tables: `continents`, `countries`, `location_type`, `member_type`.

### Utilities

- `mrr_job_doc()` — generates a documentation tibble (file path, run date, R version) for reproducibility tracking in analysis scripts.
- `strip_html_tags()` — removes HTML tags and decodes entities from character vectors.
- `strip_underscore()` / `names_to_titles()` — column name formatting for export (Google Sheets, reports).
- `mrr_gmail()` — sends HTML email via `gmailr`.

## Key Conventions

- All exported functions are documented with roxygen2. Run `devtools::document()` after editing roxygen comments.
- The `dd_all` data dictionary object is assumed to be in scope for `mrr_count_*` and `mrr_meta` functions. It is not bundled in the package — it must be loaded separately in the analysis environment.
- Lollipop plot functions reference `lolly_now` and `lolly_then` color constants that must be defined in the calling environment.
- Database credentials are never hardcoded; always read from environment variables via `.Renviron`.
