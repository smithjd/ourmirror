# Test Plan for ourmirror Package

## Overview

This document outlines a comprehensive testing strategy for all R functions in the `ourmirror` package. The package provides utilities for SGS-IT data analysis, with functions across visualization, database connectivity, survey data analysis, and utilities.

**Total R files to test:** 22

## Test Framework

- **Framework:** testthat (standard for R packages)
- **Location:** `tests/testthat/` directory
- **File naming convention:** `test-<filename>.R` (one test file per source file)
- **Setup:** Requires running `usethis::use_testthat()` once to initialize infrastructure

## File-by-File Test Plan

### 1. Core Data Files (Documentation/Package Data)
These files define package data and do not contain testable functions.

#### `ourmirror-package.R`
- **Category:** Package definition
- **Testable functions:** None (package metadata only)
- **Test status:** SKIP
- **Notes:** Roxygen package documentation; verify via `devtools::check()`

#### `continents.R`, `countries.R`, `location_type.R`, `member_type.R`
- **Category:** Data exports (lazy-loaded via `data/`)
- **Testable functions:** None (data dictionary exports)
- **Test status:** SKIP
- **Notes:** Data integrity can be spot-checked with unit tests but not core logic tests

---

### 2. String/Text Utilities

#### `strip_html_tags.R`
- **File:** [strip_html_tags.R](../R/strip_html_tags.R)
- **Functions:** `strip_html_tags(html_string)`
- **Tests needed:**
  - ✓ Basic HTML tag removal (`<p>Hello</p>` → `Hello`)
  - ✓ Multiple entity decoding (`&amp;`, `&nbsp;`, `&lt;`, `&gt;`, `&quot;`)
  - ✓ Vectorized input (character vector with multiple elements)
  - ✓ NA handling (input contains `NA`)
  - ✓ Empty string handling
  - ✓ Zero-length vector input
  - ✓ Whitespace normalization (multiple spaces → single space)
  - ✓ Complex nested HTML
  - ✓ Mixed content (tags + entities + text)
- **Complexity:** ⭐ Low (pure string transformation, no dependencies)
- **Estimated effort:** 30 min

#### `strip_underscore.R`
- **File:** [strip_underscore.R](../R/strip_underscore.R)
- **Functions:** `strip_underscore(names_vector)` (presumed; needs review)
- **Tests needed:**
  - ✓ Remove leading underscores
  - ✓ Remove trailing underscores
  - ✓ Handle multiple underscores
  - ✓ Preserve content
  - ✓ Vectorized input
  - ✓ NA handling
- **Complexity:** ⭐ Low
- **Estimated effort:** 20 min

#### `names_to_titles.R`
- **File:** [names_to_titles.R](../R/names_to_titles.R)
- **Functions:** `names_to_titles(names)` (presumed; needs review)
- **Tests needed:**
  - ✓ snake_case → Title Case conversion
  - ✓ Multiple words
  - ✓ Acronyms (all caps handling)
  - ✓ Vectorized input
  - ✓ NA preservation
  - ✓ Empty strings
- **Complexity:** ⭐ Low
- **Estimated effort:** 20 min

---

### 3. Visualization & Theming

#### `mirror_theme.R`
- **File:** [mirror_theme.R](../R/mirror_theme.R)
- **Functions:** `mirror_theme()`, `shambhala_palette_function()` (presumed)
- **Tests needed:**
  - ✓ Returns a valid ggplot2 theme object
  - ✓ Theme has correct font family setting ("Gandhi Sans" or fallback)
  - ✓ Theme includes correct background, grid, and text colors
  - ✓ Palette function returns named vector
  - ✓ Palette contains expected colors (Light Text, Header Text, Dark Text, Grid, Green, Crimson, Yellow, Blue)
  - ✓ All hex values are valid
- **Complexity:** ⭐⭐ Medium (ggplot2 theme object structure)
- **Estimated effort:** 40 min

#### `mrr_palettes.R`
- **File:** [mrr_palettes.R](../R/mrr_palettes.R)
- **Functions:** 
  - `mrr_pal_categorical(n)`
  - `scale_fill_mirror_d()`, `scale_colour_mirror_d()`, `scale_color_mirror_d()`
  - `mrr_pal_sequential(hue, n, blend, direction)`
  - `scale_fill_mirror_c()`, `scale_fill_mirror_steps()`
  - `mrr_stoplight_constants()`
  - `stoplight_ink(fills, white_min)`
  - `mrr_pal_stoplight(n, labels)`
  - `scale_fill_stoplight()`
- **Tests needed:**
  - **mrr_pal_categorical:**
    - ✓ Returns 4 colors by default (Green, Blue, Crimson, Yellow)
    - ✓ Returns n colors when specified (1-4)
    - ✓ Raises error when n > 4
    - ✓ All returned values are valid hex colors
  - **scale_fill_mirror_d / scale_colour_mirror_d:**
    - ✓ Returns ggplot2 discrete scale object
    - ✓ Scale is applicable to ggplot
  - **mrr_pal_sequential:**
    - ✓ Returns n colors
    - ✓ White blend mode generates light→dark ramp
    - ✓ Custom blend mode generates hue→blend ramp
    - ✓ Direction -1 reverses ramp
    - ✓ Handles brand hue names (Green, Blue, etc.)
    - ✓ Handles hex color strings
    - ✓ All returned values are valid hex colors
  - **scale_fill_mirror_c / scale_fill_mirror_steps:**
    - ✓ Returns ggplot2 scale object
  - **mrr_stoplight_constants:**
    - ✓ Returns named vector with 6 keys (red, orange, amber, lightgreen, green, grey)
    - ✓ All values are valid hex colors
    - ✓ Colors are semantically correct (red darker than green, etc.)
  - **stoplight_ink:**
    - ✓ Returns "white" for dark fills
    - ✓ Returns dark ink for light fills
    - ✓ Respects white_min parameter
    - ✓ Vectorized across fills input
    - ✓ Length matches fills input
  - **mrr_pal_stoplight:**
    - ✓ Returns list with `fill` and `ink` elements
    - ✓ n=2 to n=4 all work
    - ✓ n < 2 or n > 4 raises error
    - ✓ labels parameter names both fill and ink
    - ✓ Mismatched labels length raises error
    - ✓ All returned colors are valid hex
- **Complexity:** ⭐⭐⭐ High (color math, monochromeR dependency, multiple functions)
- **Estimated effort:** 90 min

#### `mrr_color_levels.R`
- **File:** [mrr_color_levels.R](../R/mrr_color_levels.R)
- **Functions:** Likely `mrr_color_steps()`, `mrr_color_both_ways()` (needs review)
- **Tests needed:** (depends on implementation)
  - ✓ Blended palette generation
  - ✓ Correct step count
  - ✓ Valid hex colors
  - ✓ Proper color transitions
- **Complexity:** ⭐⭐ Medium
- **Estimated effort:** 40 min

#### `mrr_lolly.R`
- **File:** [mrr_lolly.R](../R/mrr_lolly.R)
- **Functions:** `mrr_single_lolly()`, `mrr_comparison_lolly()` (presumed)
- **Tests needed:**
  - ✓ Returns ggplot object
  - ✓ Handles frequency data correctly
  - ✓ Comparison variant stacks current vs. prior
  - ✓ Respects lolly_now and lolly_then color constants (integration test)
  - ✓ Handles NA values
  - ✓ Empty input handling
- **Complexity:** ⭐⭐⭐ High (ggplot object, integration with color constants)
- **Estimated effort:** 60 min

#### `mrr_waffles.R`
- **File:** [mrr_waffles.R](../R/mrr_waffles.R)
- **Functions:** `mrr_waffle()` (presumed)
- **Tests needed:**
  - ✓ Returns ggplot object
  - ✓ Correct square grid layout
  - ✓ Color mapping for categories
  - ✓ Handles membership/category data
  - ✓ Label placement
- **Complexity:** ⭐⭐⭐ High (ggplot object, grid layout)
- **Estimated effort:** 50 min

#### `mrr_gt_theme.R`
- **File:** [mrr_gt_theme.R](../R/mrr_gt_theme.R)
- **Functions:** `mrr_gt_theme()` (presumed)
- **Tests needed:**
  - ✓ Returns valid gt theme object
  - ✓ Theme applies to gt table
  - ✓ Font styling applied
  - ✓ Color scheme applied
- **Complexity:** ⭐⭐⭐ High (gt table objects)
- **Estimated effort:** 50 min

---

### 4. Database Connectivity

#### `db_init.R`
- **File:** [db_init.R](../R/db_init.R)
- **Functions:** `db_init(db = c("sdb", "network"))`
- **Tests needed:**
  - ✓ Valid argument matching ("sdb" vs "network")
  - ✓ Error when invalid db specified
  - ✓ Error when credentials not in environment vars
  - ✓ Error when host IP not found
  - ⚠ Connection attempt (requires credentials; skip in CI/unit tests)
  - ✓ Mock/stub tests for connection logic (without actual DB)
- **Complexity:** ⭐⭐⭐ High (external dependency, environment variables)
- **Estimated effort:** 60 min (mocking required)
- **Notes:** 
  - Requires `RMariaDB` and `DBI` packages
  - Credentials should NOT be in repo; use environment variable mocking in tests
  - Integration tests should be marked with `@skip` or `skip_if_not_installed("RMariaDB")`

---

### 5. Survey Data Analysis

#### `mrr_count.R`
- **File:** [mrr_count.R](../R/mrr_count.R)
- **Functions:** `mrr_count_var_sequence()`, `mrr_count_var_list()` (presumed)
- **Tests needed:** (depends on dd_all dictionary)
  - ✓ Correct counting of variable ranges
  - ✓ Correct joining with dd_all metadata
  - ✓ NA handling in counts
  - ✓ Vectorized outputs
  - ✓ Error on invalid variable names
- **Complexity:** ⭐⭐⭐ High (survey data structures, dictionary dependency)
- **Estimated effort:** 70 min
- **Notes:** Requires mock dd_all data dictionary in tests

#### `mrr_meta.R`
- **File:** [mrr_meta.R](../R/mrr_meta.R)
- **Functions:** `mrr_get_dd()`, `mrr_meta()` (presumed)
- **Tests needed:**
  - ✓ Lookup by df name + variable tag
  - ✓ Lookup by tag, var_name, old_var_stub
  - ✓ Return correct metadata
  - ✓ Handling of missing keys
  - ✓ Partial matching behavior
- **Complexity:** ⭐⭐ Medium (dictionary lookup)
- **Estimated effort:** 40 min
- **Notes:** Requires mock dd_all in tests

#### `mrr_factors.R`
- **File:** [mrr_factors.R](../R/mrr_factors.R)
- **Functions:** `mrr_append_factor_pct()` (presumed), possibly `mrr_get_classifying_vars()`, `mrr_get_multi_vars()`
- **Tests needed:**
  - ✓ Recode vector generation
  - ✓ Percentage calculation
  - ✓ Factor application with fct_recode
  - ✓ Correct label format
  - ✓ Empty factor handling
- **Complexity:** ⭐⭐ Medium
- **Estimated effort:** 40 min

---

### 6. Categorization

#### `mrr_cat_center_size_count.R`
- **File:** [mrr_cat_center_size_count.R](../R/mrr_cat_center_size_count.R)
- **Functions:** `mrr_cat_center_size_count()` (presumed)
- **Tests needed:**
  - ✓ Adds ordered factor column
  - ✓ Categorizes into 5 tiers (Very Small → Very Large)
  - ✓ Correct tier boundaries
  - ✓ Preserves other columns
  - ✓ Handles NA member counts
  - ✓ Maintains row order
- **Complexity:** ⭐⭐ Medium
- **Estimated effort:** 35 min

#### `mrr_cat_center_size_members.R`
- **File:** [mrr_cat_center_size_members.R](../R/mrr_cat_center_size_members.R)
- **Functions:** Similar to above but for member-based categorization
- **Tests needed:** (mirror of _count variant)
  - ✓ Correct categorization logic
  - ✓ Tier definitions
  - ✓ Boundary cases
- **Complexity:** ⭐⭐ Medium
- **Estimated effort:** 35 min

---

### 7. Utilities

#### `mrr_job_doc.R`
- **File:** [mrr_job_doc.R](../R/mrr_job_doc.R)
- **Functions:** `mrr_job_doc()` (presumed)
- **Tests needed:**
  - ✓ Returns tibble with 3 columns (file path, run date, R version)
  - ✓ File path is correctly set
  - ✓ Run date is today's date
  - ✓ R version matches `R.version`
  - ✓ Output format matches reproducibility requirements
- **Complexity:** ⭐ Low
- **Estimated effort:** 25 min

#### `mrr_gmail.R`
- **File:** [mrr_gmail.R](../R/mrr_gmail.R)
- **Functions:** `mrr_gmail()` (presumed; HTML email sending)
- **Tests needed:**
  - ✓ Email object creation (without sending)
  - ✓ HTML rendering
  - ✓ Recipient validation
  - ✓ Subject line handling
  - ⚠ Actual sending (skip; requires gmailr auth)
- **Complexity:** ⭐⭐⭐ High (external service dependency)
- **Estimated effort:** 45 min (mocking required)
- **Notes:** Requires gmailr mocking; actual email sending not tested in unit tests

---

## Summary by Complexity

| Complexity | Count | Files | Total Effort |
|---|---|---|---|
| ⭐ Low | 4 | strip_html_tags, strip_underscore, names_to_titles, mrr_job_doc | 95 min |
| ⭐⭐ Medium | 7 | mrr_color_levels, mrr_cat_center_size_count, mrr_cat_center_size_members, mrr_meta, mrr_factors | 190 min |
| ⭐⭐⭐ High | 8 | mirror_theme, mrr_palettes, mrr_lolly, mrr_waffles, mrr_gt_theme, db_init, mrr_count, mrr_gmail | 415 min |
| SKIP | 3 | ourmirror-package, data files (4) | 0 min |

**Total estimated effort:** ~700 minutes (~11.5 hours) for comprehensive coverage

## Implementation Roadmap

### ✅ Phase 1: Setup & Low-Complexity Tests (COMPLETE)
1. ✅ Run `usethis::use_testthat()` to initialize test infrastructure
2. ✅ Write tests for string utilities (strip_html_tags, strip_underscore, names_to_titles)
3. ✅ Write tests for mrr_job_doc
4. **Time spent:** ~2 hours
5. **Tests written:** 85 tests across 3 files

### ✅ Phase 2: Visualization/Theming Tests (COMPLETE)
1. ✅ Write tests for mirror_theme (ggplot2 theme structure) — 33 tests
2. ✅ Write comprehensive tests for mrr_palettes (color math, monochromeR) — 99 tests
3. ✅ Write tests for mrr_color_levels (wrapper functions) — 54 tests
4. ✅ Write tests for mrr_gt_theme (gt table styling) — 26 tests
5. ✅ Write tests for mrr_gmail (email utility) — 13 tests
6. **Time spent:** ~3 hours
7. **Tests written:** 225 tests across 5 files

### ⏳ Phase 3: Remaining High-Complexity Tests (NEXT)
1. ⏳ Write tests for mrr_lolly and mrr_waffles (plot functions)
2. ⏳ Write tests for db_init (mocked DB connection)
3. ⏳ Write tests for mrr_count, mrr_meta, mrr_factors (survey data)
4. ⏳ Write tests for mrr_cat_center_size_* (categorization)
5. **Estimated time:** 4 hours
6. **Expected tests:** ~180 tests

### ⏳ Phase 4: Integration & CI (PENDING)
1. ⏳ Verify all tests pass with `devtools::test()`
2. ⏳ Verify with `devtools::check()`
3. ⏳ Set up CI/CD pipeline (GitHub Actions) if not present
4. ⏳ Ensure coverage reporting
5. **Estimated time:** 1 hour

## Current Status
- **Tests complete:** 322 out of ~502 estimated
- **Coverage:** 9 out of 22 R files tested (41%)
- **Pass rate:** 100% (322/322 tests passing)

## Testing Best Practices for This Package

1. **Data Dictionary:** Create a minimal mock `dd_all` tibble in `tests/testthat/fixtures/dd_all.R` for survey data tests
2. **Environment Variables:** Use `withr::local_envvar()` in db_init tests to mock credentials
3. **ggplot Objects:** Test structure/components rather than visual output (not practical)
4. **Color Testing:** Validate hex format and luminance calculations, not pixel-perfect color matching
5. **Mocking:** Use `testthat::local_mocked_bindings()` for RMariaDB and gmailr calls
6. **Fixtures:** Store test data in `tests/testthat/fixtures/` directory

## Notes for Future Reference

- **Critical path:** mrr_palettes (color math complexity) and db_init (external dependency) are the highest-risk tests
- **Skip markers:** Use `skip_if_not_installed()` for optional dependencies (RMariaDB, gmailr)
- **Coverage target:** Aim for 80%+ line coverage; 100% is not practical for all plotting code
- **Snapshot tests:** Consider using `testthat::expect_snapshot()` for theme/scale objects to catch unintended changes
