# ============================================================
# Tests for format_r()
# ============================================================


# ------------------------------------------------------------
# Basic formatting
# ------------------------------------------------------------

test_that("format_r formats correlations correctly", {

  expect_equal(
    format_r(0.423),
    "r = .42"
  )

  expect_equal(
    format_r(-0.314),
    "r = -.31"
  )

  expect_equal(
    format_r(0),
    "r = .00"
  )
})


# ------------------------------------------------------------
# Boundary values
# ------------------------------------------------------------

test_that("format_r handles correlation boundaries", {

  expect_equal(
    format_r(1),
    "r = 1.00"
  )

  expect_equal(
    format_r(-1),
    "r = -1.00"
  )
})


# ------------------------------------------------------------
# Leading-zero behavior
# ------------------------------------------------------------

test_that("leading zeros are omitted by default", {

  expect_equal(
    format_r(0.42),
    "r = .42"
  )

  expect_equal(
    format_r(-0.42),
    "r = -.42"
  )
})


test_that("leading zeros can be retained", {

  expect_equal(
    format_r(0.42, leading_zero = TRUE),
    "r = 0.42"
  )

  expect_equal(
    format_r(-0.42, leading_zero = TRUE),
    "r = -0.42"
  )
})


# ------------------------------------------------------------
# Decimal precision
# ------------------------------------------------------------

test_that("digits controls displayed precision", {

  expect_equal(
    format_r(0.4231, digits = 3),
    "r = .423"
  )

  expect_equal(
    format_r(0.4231, digits = 1),
    "r = .4"
  )
})


# ------------------------------------------------------------
# Prefix
# ------------------------------------------------------------

test_that("r prefix can be removed", {

  expect_equal(
    format_r(0.42, prefix = FALSE),
    ".42"
  )

  expect_equal(
    format_r(-0.42, prefix = FALSE),
    "-.42"
  )
})


# ------------------------------------------------------------
# Negative zero
# ------------------------------------------------------------

test_that("format_r does not display negative zero", {

  expect_equal(
    format_r(-0.001),
    "r = .00"
  )

  expect_equal(
    format_r(-0.001, digits = 3),
    "r = -.001"
  )
})


# ------------------------------------------------------------
# Vectorization
# ------------------------------------------------------------

test_that("format_r is vectorized", {

  r_values <- c(
    0.42,
    -0.31,
    0,
    0.78
  )

  expected <- c(
    "r = .42",
    "r = -.31",
    "r = .00",
    "r = .78"
  )

  expect_equal(
    format_r(r_values),
    expected
  )
})


# ------------------------------------------------------------
# Missing values
# ------------------------------------------------------------

test_that("format_r preserves missing values", {

  expect_equal(
    format_r(NA_real_),
    NA_character_
  )

  expect_equal(
    format_r(NaN),
    NA_character_
  )

  expect_equal(
    format_r(c(0.42, NA, -0.31)),
    c(
      "r = .42",
      NA_character_,
      "r = -.31"
    )
  )
})


# ------------------------------------------------------------
# Named vectors
# ------------------------------------------------------------

test_that("format_r preserves vector names", {

  r_values <- c(
    treatment = 0.42,
    control = -0.31
  )

  result <- format_r(r_values)

  expect_equal(
    names(result),
    c("treatment", "control")
  )

  expect_equal(
    unname(result),
    c(
      "r = .42",
      "r = -.31"
    )
  )
})


# ------------------------------------------------------------
# Invalid correlation values
# ------------------------------------------------------------

test_that("correlations must be between -1 and 1", {

  expect_error(
    format_r(1.01),
    "between -1 and 1"
  )

  expect_error(
    format_r(-1.01),
    "between -1 and 1"
  )
})


# ------------------------------------------------------------
# Infinite values
# ------------------------------------------------------------

test_that("correlations cannot be infinite", {

  expect_error(
    format_r(Inf),
    "infinite"
  )

  expect_error(
    format_r(-Inf),
    "infinite"
  )
})


# ------------------------------------------------------------
# Non-numeric input
# ------------------------------------------------------------

test_that("r must be numeric", {

  expect_error(
    format_r("0.42"),
    "must be numeric"
  )
})


# ------------------------------------------------------------
# Invalid digits
# ------------------------------------------------------------

test_that("digits must be a non-negative integer", {

  expect_error(
    format_r(0.42, digits = -1),
    "non-negative integer"
  )

  expect_error(
    format_r(0.42, digits = 2.5),
    "non-negative integer"
  )

  expect_error(
    format_r(0.42, digits = NA),
    "non-negative integer"
  )

  expect_error(
    format_r(0.42, digits = "2"),
    "non-negative integer"
  )
})


# ------------------------------------------------------------
# Invalid logical arguments
# ------------------------------------------------------------

test_that("prefix must be TRUE or FALSE", {

  expect_error(
    format_r(0.42, prefix = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_r(0.42, prefix = 1),
    "TRUE or FALSE"
  )
})


test_that("leading_zero must be TRUE or FALSE", {

  expect_error(
    format_r(0.42, leading_zero = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_r(0.42, leading_zero = 1),
    "TRUE or FALSE"
  )
})


# ------------------------------------------------------------
# Empty vectors
# ------------------------------------------------------------

test_that("format_r handles empty numeric vectors", {

  expect_equal(
    format_r(numeric(0)),
    character(0)
  )
})
