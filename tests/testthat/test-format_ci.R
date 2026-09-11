# ============================================================
# Tests for format_ci()
# ============================================================


# ------------------------------------------------------------
# Basic formatting
# ------------------------------------------------------------

test_that("format_ci formats ordinary confidence intervals", {

  expect_equal(
    format_ci(1.08, 1.87),
    "95% CI [1.08, 1.87]"
  )

  expect_equal(
    format_ci(-0.42, 0.18),
    "95% CI [-0.42, 0.18]"
  )
})


# ------------------------------------------------------------
# Fixed decimal places
# ------------------------------------------------------------

test_that("format_ci preserves trailing zeros", {

  expect_equal(
    format_ci(1, 2),
    "95% CI [1.00, 2.00]"
  )

  expect_equal(
    format_ci(0.5, 0.8),
    "95% CI [0.50, 0.80]"
  )
})


# ------------------------------------------------------------
# Leading-zero behavior
# ------------------------------------------------------------

test_that("leading zeros are retained by default", {

  expect_equal(
    format_ci(0.21, 0.48),
    "95% CI [0.21, 0.48]"
  )

  expect_equal(
    format_ci(-0.43, -0.12),
    "95% CI [-0.43, -0.12]"
  )
})


test_that("leading zeros can be removed", {

  expect_equal(
    format_ci(0.21, 0.48, leading_zero = FALSE),
    "95% CI [.21, .48]"
  )

  expect_equal(
    format_ci(-0.43, -0.12, leading_zero = FALSE),
    "95% CI [-.43, -.12]"
  )

  expect_equal(
    format_ci(-0.43, 0.48, leading_zero = FALSE),
    "95% CI [-.43, .48]"
  )
})


# ------------------------------------------------------------
# Confidence level
# ------------------------------------------------------------

test_that("confidence level can be changed", {

  expect_equal(
    format_ci(1.08, 1.87, level = 0.90),
    "90% CI [1.08, 1.87]"
  )

  expect_equal(
    format_ci(1.08, 1.87, level = 0.99),
    "99% CI [1.08, 1.87]"
  )

  expect_equal(
    format_ci(1.08, 1.87, level = 0.925),
    "92.5% CI [1.08, 1.87]"
  )
})


# ------------------------------------------------------------
# Prefix
# ------------------------------------------------------------

test_that("confidence interval prefix can be removed", {

  expect_equal(
    format_ci(1.08, 1.87, prefix = FALSE),
    "[1.08, 1.87]"
  )

  expect_equal(
    format_ci(0.21, 0.48,
              prefix = FALSE,
              leading_zero = FALSE),
    "[.21, .48]"
  )
})


# ------------------------------------------------------------
# Decimal precision
# ------------------------------------------------------------

test_that("digits controls displayed precision", {

  expect_equal(
    format_ci(1.084, 1.876, digits = 3),
    "95% CI [1.084, 1.876]"
  )

  expect_equal(
    format_ci(1.084, 1.876, digits = 1),
    "95% CI [1.1, 1.9]"
  )
})


# ------------------------------------------------------------
# Intervals crossing zero
# ------------------------------------------------------------

test_that("format_ci handles intervals crossing zero", {

  expect_equal(
    format_ci(-0.25, 0.31),
    "95% CI [-0.25, 0.31]"
  )

  expect_equal(
    format_ci(-0.25, 0.31, leading_zero = FALSE),
    "95% CI [-.25, .31]"
  )
})


# ------------------------------------------------------------
# Equal confidence limits
# ------------------------------------------------------------

test_that("lower and upper may be equal", {

  expect_equal(
    format_ci(1.25, 1.25),
    "95% CI [1.25, 1.25]"
  )
})


# ------------------------------------------------------------
# Negative zero
# ------------------------------------------------------------

test_that("format_ci does not display negative zero", {

  expect_equal(
    format_ci(-0.001, 0.25, digits = 2),
    "95% CI [0.00, 0.25]"
  )

  expect_equal(
    format_ci(-0.001, 0.25,
              digits = 2,
              leading_zero = FALSE),
    "95% CI [.00, .25]"
  )
})


# ------------------------------------------------------------
# Vectorization
# ------------------------------------------------------------

test_that("format_ci is vectorized", {

  lower <- c(1.08, -0.42, 2.15)
  upper <- c(1.87, 0.18, 3.02)

  expected <- c(
    "95% CI [1.08, 1.87]",
    "95% CI [-0.42, 0.18]",
    "95% CI [2.15, 3.02]"
  )

  expect_equal(
    format_ci(lower, upper),
    expected
  )
})


# ------------------------------------------------------------
# Missing values
# ------------------------------------------------------------

test_that("missing confidence limits produce missing intervals", {

  expect_equal(
    format_ci(NA_real_, 1.87),
    NA_character_
  )

  expect_equal(
    format_ci(1.08, NA_real_),
    NA_character_
  )

  expect_equal(
    format_ci(NaN, 1.87),
    NA_character_
  )

  expect_equal(
    format_ci(
      c(1.08, NA, 2.15),
      c(1.87, 2.50, 3.02)
    ),
    c(
      "95% CI [1.08, 1.87]",
      NA_character_,
      "95% CI [2.15, 3.02]"
    )
  )
})


# ------------------------------------------------------------
# Named vectors
# ------------------------------------------------------------

test_that("format_ci preserves names from lower vector", {

  lower <- c(
    treatment = 1.08,
    interaction = -0.42
  )

  upper <- c(
    treatment = 1.87,
    interaction = 0.18
  )

  result <- format_ci(lower, upper)

  expect_equal(
    names(result),
    c("treatment", "interaction")
  )

  expect_equal(
    unname(result),
    c(
      "95% CI [1.08, 1.87]",
      "95% CI [-0.42, 0.18]"
    )
  )
})


# ------------------------------------------------------------
# Reversed intervals
# ------------------------------------------------------------

test_that("lower cannot exceed upper", {

  expect_error(
    format_ci(2, 1),
    "cannot be greater"
  )

  expect_error(
    format_ci(
      c(1, 5),
      c(2, 4)
    ),
    "cannot be greater"
  )
})


# ------------------------------------------------------------
# Lower and upper must be numeric
# ------------------------------------------------------------

test_that("confidence limits must be numeric", {

  expect_error(
    format_ci("1.08", 1.87),
    "`lower` must be numeric"
  )

  expect_error(
    format_ci(1.08, "1.87"),
    "`upper` must be numeric"
  )
})


# ------------------------------------------------------------
# Lower and upper lengths
# ------------------------------------------------------------

test_that("lower and upper must have equal lengths", {

  expect_error(
    format_ci(
      c(1, 2),
      c(2, 3, 4)
    ),
    "same length"
  )
})


# ------------------------------------------------------------
# Infinite values
# ------------------------------------------------------------

test_that("confidence interval limits must be finite", {

  expect_error(
    format_ci(-Inf, 1),
    "must be finite"
  )

  expect_error(
    format_ci(1, Inf),
    "must be finite"
  )
})


# ------------------------------------------------------------
# Invalid confidence levels
# ------------------------------------------------------------

test_that("level must be between zero and one", {

  expect_error(
    format_ci(1, 2, level = 0),
    "greater than 0"
  )

  expect_error(
    format_ci(1, 2, level = 1),
    "less than 1"
  )

  expect_error(
    format_ci(1, 2, level = -0.95),
    "greater than 0"
  )

  expect_error(
    format_ci(1, 2, level = NA_real_),
    "single numeric value"
  )

  expect_error(
    format_ci(1, 2, level = c(.90, .95)),
    "single numeric value"
  )
})


# ------------------------------------------------------------
# Invalid digits
# ------------------------------------------------------------

test_that("digits must be a non-negative integer", {

  expect_error(
    format_ci(1, 2, digits = -1),
    "non-negative integer"
  )

  expect_error(
    format_ci(1, 2, digits = 2.5),
    "non-negative integer"
  )

  expect_error(
    format_ci(1, 2, digits = NA),
    "non-negative integer"
  )

  expect_error(
    format_ci(1, 2, digits = "2"),
    "non-negative integer"
  )
})


# ------------------------------------------------------------
# Invalid logical arguments
# ------------------------------------------------------------

test_that("prefix must be TRUE or FALSE", {

  expect_error(
    format_ci(1, 2, prefix = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_ci(1, 2, prefix = 1),
    "TRUE or FALSE"
  )
})


test_that("leading_zero must be TRUE or FALSE", {

  expect_error(
    format_ci(1, 2, leading_zero = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_ci(1, 2, leading_zero = 1),
    "TRUE or FALSE"
  )
})


# ------------------------------------------------------------
# Empty vectors
# ------------------------------------------------------------

test_that("format_ci handles empty numeric vectors", {

  expect_equal(
    format_ci(numeric(0), numeric(0)),
    character(0)
  )
})
