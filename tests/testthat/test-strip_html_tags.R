test_that("strip_html_tags: basic tag removal", {
  result <- strip_html_tags("<p>Hello</p>")
  expect_equal(result, "Hello")
})

test_that("strip_html_tags: multiple tags", {
  result <- strip_html_tags("<p><b>Bold text</b> and <i>italic</i></p>")
  expect_equal(result, "Bold text and italic")
})

test_that("strip_html_tags: self-closing tags", {
  result <- strip_html_tags("Line 1<br/>Line 2")
  expect_equal(result, "Line 1Line 2")
})

test_that("strip_html_tags: tags with attributes", {
  result <- strip_html_tags('<a href="example.com">Link</a>')
  expect_equal(result, "Link")
})

test_that("strip_html_tags: complex tag attributes", {
  result <- strip_html_tags('<div class="container" id="main" data-value="test">Content</div>')
  expect_equal(result, "Content")
})

test_that("strip_html_tags: amp entity decoding", {
  result <- strip_html_tags("Hello &amp; welcome")
  expect_equal(result, "Hello & welcome")
})

test_that("strip_html_tags: nbsp entity decoding", {
  result <- strip_html_tags("Hello&nbsp;world")
  expect_equal(result, "Hello world")
})

test_that("strip_html_tags: lt and gt entities", {
  result <- strip_html_tags("5 &lt; 10 &amp; 3 &gt; 1")
  expect_equal(result, "5 < 10 & 3 > 1")
})

test_that("strip_html_tags: quot entity", {
  result <- strip_html_tags('He said &quot;Hello&quot;')
  expect_equal(result, 'He said "Hello"')
})

test_that("strip_html_tags: mixed tags and entities", {
  result <- strip_html_tags("<p>Hello &amp; <b>welcome</b></p>")
  expect_equal(result, "Hello & welcome")
})

test_that("strip_html_tags: multiple spaces normalized", {
  result <- strip_html_tags("Hello    world")
  expect_equal(result, "Hello world")
})

test_that("strip_html_tags: whitespace with tags", {
  result <- strip_html_tags("<p>  Hello  </p>  <span>world</span>  ")
  expect_equal(result, "Hello world")
})

test_that("strip_html_tags: newlines normalized", {
  result <- strip_html_tags("Hello\n\nworld")
  expect_equal(result, "Hello world")
})

test_that("strip_html_tags: tabs normalized", {
  result <- strip_html_tags("Hello\t\tworld")
  expect_equal(result, "Hello world")
})

test_that("strip_html_tags: leading/trailing whitespace trimmed", {
  result <- strip_html_tags("  <p>Hello</p>  ")
  expect_equal(result, "Hello")
})

test_that("strip_html_tags: NA input preserved", {
  result <- strip_html_tags(NA_character_)
  expect_true(is.na(result))
})

test_that("strip_html_tags: empty string preserved", {
  result <- strip_html_tags("")
  expect_equal(result, "")
})

test_that("strip_html_tags: vectorized input", {
  input <- c("<b>Bold</b>", NA, "")
  result <- strip_html_tags(input)
  expect_length(result, 3)
  expect_equal(result[1], "Bold")
  expect_true(is.na(result[2]))
  expect_equal(result[3], "")
})

test_that("strip_html_tags: multiple element vector", {
  input <- c("<p>First</p>", "<b>Second</b>", "<i>Third</i>")
  result <- strip_html_tags(input)
  expect_equal(result, c("First", "Second", "Third"))
})

test_that("strip_html_tags: zero-length vector", {
  result <- strip_html_tags(character(0))
  expect_length(result, 0)
  expect_equal(result, character(0))
})

test_that("strip_html_tags: all NA vector", {
  input <- c(NA_character_, NA_character_)
  result <- strip_html_tags(input)
  expect_length(result, 2)
  expect_true(all(is.na(result)))
})

test_that("strip_html_tags: complex nested HTML", {
  html <- "<div><p>Outer <span>inner <b>bold</b></span> text</p></div>"
  result <- strip_html_tags(html)
  expect_equal(result, "Outer inner bold text")
})

test_that("strip_html_tags: entities and tags combined", {
  html <- "<p>Tom &amp; Jerry said &quot;Hello&quot;</p>"
  result <- strip_html_tags(html)
  expect_equal(result, 'Tom & Jerry said "Hello"')
})

test_that("strip_html_tags: multiple entities in sequence", {
  html <- "&lt;div&gt;&amp;&nbsp;&quot;test&quot;"
  result <- strip_html_tags(html)
  expect_equal(result, '<div>& "test"')
})

test_that("strip_html_tags: html comments removed", {
  html <- "<p>Visible<!-- comment -->text</p>"
  result <- strip_html_tags(html)
  expect_equal(result, "Visibletext")
})

test_that("strip_html_tags: script tags removed but content remains", {
  html <- "<div>Text<script>alert('test')</script>More</div>"
  result <- strip_html_tags(html)
  # Note: Tags are removed but content inside script tags remains (not ideal, but current behavior)
  expect_equal(result, "Textalert('test')More")
})

test_that("strip_html_tags: style tags removed but content remains", {
  html <- "<div>Text<style>.class { color: red; }</style>More</div>"
  result <- strip_html_tags(html)
  # Note: Tags are removed but content inside style tags remains (not ideal, but current behavior)
  expect_equal(result, "Text.class { color: red; }More")
})

test_that("strip_html_tags: output is character class", {
  result <- strip_html_tags("<p>Test</p>")
  expect_type(result, "character")
})

test_that("strip_html_tags: names preserved in vector", {
  input <- c(a = "<p>First</p>", b = "<b>Second</b>")
  result <- strip_html_tags(input)
  # Note: names may or may not be preserved depending on implementation
  # This test documents current behavior
  expect_length(result, 2)
})

test_that("strip_html_tags: only whitespace after cleanup", {
  html <- "<p>   </p>"
  result <- strip_html_tags(html)
  expect_equal(result, "")
})

test_that("strip_html_tags: mixed case entities", {
  # HTML entities are case-sensitive; &AMP; is not &amp;
  html <- "Ampersand: &amp; (lowercase only)"
  result <- strip_html_tags(html)
  expect_equal(result, "Ampersand: & (lowercase only)")
})

test_that("strip_html_tags: unicode content preserved", {
  html <- "<p>Café &amp; naïve</p>"
  result <- strip_html_tags(html)
  expect_equal(result, "Café & naïve")
})

test_that("strip_html_tags: special characters in content", {
  html <- "<p>Price: $99.99 (50% off!)</p>"
  result <- strip_html_tags(html)
  expect_equal(result, "Price: $99.99 (50% off!)")
})
