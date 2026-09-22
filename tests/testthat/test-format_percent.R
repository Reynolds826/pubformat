# ============================================================
# Tests for format_percent()
# ============================================================


# ------------------------------------------------------------
# Basic proportion formatting
# ------------------------------------------------------------

test_that("format_percent formats proportions correctly", {

  expect_equal(
    format_percent(0.423),
    "42.3%"
  )

  expect_equal(
    format_percent(0.5),
    "50.0%"
  )

  expect_equal(
    format_percent(1),
    "100.0%"
  )
})


# ------------------------------------------------------------
# Percent input
# ------------------------------------------------------------

test_that("format_percent accepts already-scaled percentages", {

  expect_equal(
    format_percent(42.3, input = "percent"),
    "42.3%"
  )

  expect_equal(
    format_percent(150, input = "percent"),
    "150.0%"
  )

  expect_equal(
    format_percent(-12.5, input = "percent"),
    "-12.5%"
  )
})


# ------------------------------------------------------------
# Input matching
# ------------------------------------------------------------

test_that("input matching is case insensitive", {

  expect_equal(
    format_percent(0.42, input = "PROPORTION"),
    "42.0%"
  )

  expect_equal(
    format_percent(42, input = "Percent"),
    "42.0%"
  )
})


# ------------------------------------------------------------
# Decimal precision
# ------------------------------------------------------------

test_that("digits controls displayed precision", {

  expect_equal(
    format_percent(0.423, digits = 2),
    "42.30%"
  )

  expect_equal(
    format_percent(0.423, digits = 0),
    "42%"
  )

  expect_equal(
    format_percent(42.345, input = "percent", digits = 2),
    "42.34%"
  )
})


# ------------------------------------------------------------
# Percent symbol
# ------------------------------------------------------------

test_that("percent symbol can be removed", {

  expect_equal(
    format_percent(0.42, symbol = FALSE),
    "42.0"
  )

  expect_equal(
    format_percent(42, input = "percent", symbol = FALSE),
    "42.0"
  )
})


# ------------------------------------------------------------
# Vectorization
# ------------------------------------------------------------

test_that("format_percent is vectorized", {

  x <- c(
    0.25,
    0.50,
    0.75
  )

  expected <- c(
    "25.0%",
    "50.0%",
    "75.0%"
  )

  expect_equal(
    format_percent(x),
    expected
  )
})


# ------------------------------------------------------------
# Missing values
# ------------------------------------------------------------

test_that("format_percent preserves missing values", {

  expect_equal(
    format_percent(NA_real_),
    NA_character_
  )

  expect_equal(
    format_percent(NaN),
    NA_character_
  )

  expect_equal(
    format_percent(c(0.25, NA, 0.75)),
    c(
      "25.0%",
      NA_character_,
      "75.0%"
    )
  )
})


# ------------------------------------------------------------
# Named vectors
# ------------------------------------------------------------

test_that("format_percent preserves names", {

  x <- c(
    treatment = 0.25,
    control = 0.75
  )

  result <- format_percent(x)

  expect_equal(
    names(result),
    c("treatment", "control")
  )

  expect_equal(
    unname(result),
    c(
      "25.0%",
      "75.0%"
    )
  )
})


# ------------------------------------------------------------
# Proportion boundaries
# ------------------------------------------------------------

test_that("proportions must be between 0 and 1", {

  expect_equal(
    format_percent(0),
    "0.0%"
  )

  expect_equal(
    format_percent(1),
    "100.0%"
  )

  expect_error(
    format_percent(-0.01),
    "between 0 and 1"
  )

  expect_error(
    format_percent(1.01),
    "between 0 and 1"
  )
})


# ------------------------------------------------------------
# Percent input may exceed 100 or be negative
# ------------------------------------------------------------

test_that("percent input may exceed 100 or be negative", {

  expect_equal(
    format_percent(125, input = "percent"),
    "125.0%"
  )

  expect_equal(
    format_percent(-25, input = "percent"),
    "-25.0%"
  )
})


# ------------------------------------------------------------
# Negative zero
# ------------------------------------------------------------

test_that("format_percent does not display negative zero", {

  expect_equal(
    format_percent(-0.01, input = "percent", digits = 1),
    "0.0%"
  )

  expect_equal(
    format_percent(-0.001, input = "percent", digits = 2),
    "0.00%"
  )
})


# ------------------------------------------------------------
# Infinite values
# ------------------------------------------------------------

test_that("x cannot contain infinite values", {

  expect_error(
    format_percent(Inf),
    "infinite"
  )

  expect_error(
    format_percent(-Inf, input = "percent"),
    "infinite"
  )
})


# ------------------------------------------------------------
# Non-numeric input
# ------------------------------------------------------------

test_that("x must be numeric", {

  expect_error(
    format_percent("0.42"),
    "must be numeric"
  )
})


# ------------------------------------------------------------
# Invalid input argument
# ------------------------------------------------------------

test_that("input must be supported", {

  expect_error(
    format_percent(0.42, input = "fraction"),
    "proportion"
  )

  expect_error(
    format_percent(0.42, input = NA_character_),
    "proportion"
  )

  expect_error(
    format_percent(0.42, input = c("proportion", "percent")),
    "proportion"
  )

  expect_error(
    format_percent(0.42, input = 1),
    "proportion"
  )
})


# ------------------------------------------------------------
# Invalid digits
# ------------------------------------------------------------

test_that("digits must be a non-negative integer", {

  expect_error(
    format_percent(0.42, digits = -1),
    "non-negative integer"
  )

  expect_error(
    format_percent(0.42, digits = 1.5),
    "non-negative integer"
  )

  expect_error(
    format_percent(0.42, digits = NA),
    "non-negative integer"
  )

  expect_error(
    format_percent(0.42, digits = "1"),
    "non-negative integer"
  )
})


# ------------------------------------------------------------
# Invalid symbol argument
# ------------------------------------------------------------

test_that("symbol must be TRUE or FALSE", {

  expect_error(
    format_percent(0.42, symbol = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_percent(0.42, symbol = 1),
    "TRUE or FALSE"
  )

  expect_error(
    format_percent(0.42, symbol = c(TRUE, FALSE)),
    "TRUE or FALSE"
  )
})


# ------------------------------------------------------------
# Empty vectors
# ------------------------------------------------------------

test_that("format_percent handles empty numeric vectors", {

  expect_equal(
    format_percent(numeric(0)),
    character(0)
  )
})
