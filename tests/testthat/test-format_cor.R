# ============================================================
# Tests for format_cor()
# ============================================================


# ------------------------------------------------------------
# Basic method formatting
# ------------------------------------------------------------

test_that("format_cor formats Pearson correlations", {

  expect_equal(
    format_cor(0.42),
    "r = .42"
  )

  expect_equal(
    format_cor(-0.31),
    "r = -.31"
  )
})


test_that("format_cor formats Spearman correlations", {

  expect_equal(
    format_cor(0.42, method = "spearman"),
    "ρ = .42"
  )

  expect_equal(
    format_cor(-0.31, method = "spearman"),
    "ρ = -.31"
  )
})


test_that("format_cor formats Kendall correlations", {

  expect_equal(
    format_cor(0.42, method = "kendall"),
    "τ = .42"
  )

  expect_equal(
    format_cor(-0.31, method = "kendall"),
    "τ = -.31"
  )
})


# ------------------------------------------------------------
# Method matching
# ------------------------------------------------------------

test_that("method matching is case insensitive", {

  expect_equal(
    format_cor(0.42, method = "PEARSON"),
    "r = .42"
  )

  expect_equal(
    format_cor(0.42, method = "Spearman"),
    "ρ = .42"
  )

  expect_equal(
    format_cor(0.42, method = "KENDALL"),
    "τ = .42"
  )
})


# ------------------------------------------------------------
# Boundary values
# ------------------------------------------------------------

test_that("format_cor handles correlation boundaries", {

  expect_equal(
    format_cor(1),
    "r = 1.00"
  )

  expect_equal(
    format_cor(-1),
    "r = -1.00"
  )

  expect_equal(
    format_cor(1, method = "spearman"),
    "ρ = 1.00"
  )

  expect_equal(
    format_cor(-1, method = "kendall"),
    "τ = -1.00"
  )
})


# ------------------------------------------------------------
# Leading zeros
# ------------------------------------------------------------

test_that("leading zeros are omitted by default", {

  expect_equal(
    format_cor(0.42),
    "r = .42"
  )

  expect_equal(
    format_cor(-0.42),
    "r = -.42"
  )
})


test_that("leading zeros can be retained", {

  expect_equal(
    format_cor(0.42, leading_zero = TRUE),
    "r = 0.42"
  )

  expect_equal(
    format_cor(-0.42, leading_zero = TRUE),
    "r = -0.42"
  )
})


# ------------------------------------------------------------
# Decimal precision
# ------------------------------------------------------------

test_that("digits controls displayed precision", {

  expect_equal(
    format_cor(0.4231, digits = 3),
    "r = .423"
  )

  expect_equal(
    format_cor(0.4231, digits = 1),
    "r = .4"
  )

  expect_equal(
    format_cor(0.4231, digits = 3, method = "spearman"),
    "ρ = .423"
  )
})


# ------------------------------------------------------------
# Prefix
# ------------------------------------------------------------

test_that("prefix can be removed", {

  expect_equal(
    format_cor(0.42, prefix = FALSE),
    ".42"
  )

  expect_equal(
    format_cor(-0.42, method = "kendall", prefix = FALSE),
    "-.42"
  )
})


# ------------------------------------------------------------
# Negative zero
# ------------------------------------------------------------

test_that("format_cor does not display negative zero", {

  expect_equal(
    format_cor(-0.001),
    "r = .00"
  )

  expect_equal(
    format_cor(-0.001, method = "spearman"),
    "ρ = .00"
  )

  expect_equal(
    format_cor(-0.001, digits = 3),
    "r = -.001"
  )
})


# ------------------------------------------------------------
# Vectorization
# ------------------------------------------------------------

test_that("format_cor is vectorized", {

  values <- c(
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
    format_cor(values),
    expected
  )
})


test_that("format_cor vectorizes Spearman coefficients", {

  values <- c(
    0.42,
    -0.31,
    0
  )

  expected <- c(
    "ρ = .42",
    "ρ = -.31",
    "ρ = .00"
  )

  expect_equal(
    format_cor(values, method = "spearman"),
    expected
  )
})


# ------------------------------------------------------------
# Missing values
# ------------------------------------------------------------

test_that("format_cor preserves missing values", {

  expect_equal(
    format_cor(NA_real_),
    NA_character_
  )

  expect_equal(
    format_cor(NaN),
    NA_character_
  )

  expect_equal(
    format_cor(c(0.42, NA, -0.31)),
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

test_that("format_cor preserves names", {

  values <- c(
    treatment = 0.42,
    control = -0.31
  )

  result <- format_cor(values)

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
# Invalid correlations
# ------------------------------------------------------------

test_that("correlations must be between -1 and 1", {

  expect_error(
    format_cor(1.01),
    "between -1 and 1"
  )

  expect_error(
    format_cor(-1.01),
    "between -1 and 1"
  )
})


# ------------------------------------------------------------
# Infinite values
# ------------------------------------------------------------

test_that("correlations cannot be infinite", {

  expect_error(
    format_cor(Inf),
    "infinite"
  )

  expect_error(
    format_cor(-Inf),
    "infinite"
  )
})


# ------------------------------------------------------------
# Non-numeric input
# ------------------------------------------------------------

test_that("r must be numeric", {

  expect_error(
    format_cor("0.42"),
    "must be numeric"
  )
})


# ------------------------------------------------------------
# Invalid methods
# ------------------------------------------------------------

test_that("method must be supported", {

  expect_error(
    format_cor(0.42, method = "point-biserial"),
    "pearson"
  )

  expect_error(
    format_cor(0.42, method = NA_character_),
    "pearson"
  )

  expect_error(
    format_cor(0.42, method = c("pearson", "spearman")),
    "pearson"
  )

  expect_error(
    format_cor(0.42, method = 1),
    "pearson"
  )
})


# ------------------------------------------------------------
# Invalid digits
# ------------------------------------------------------------

test_that("digits must be a non-negative integer", {

  expect_error(
    format_cor(0.42, digits = -1),
    "non-negative integer"
  )

  expect_error(
    format_cor(0.42, digits = 2.5),
    "non-negative integer"
  )

  expect_error(
    format_cor(0.42, digits = NA),
    "non-negative integer"
  )

  expect_error(
    format_cor(0.42, digits = "2"),
    "non-negative integer"
  )
})


# ------------------------------------------------------------
# Invalid logical arguments
# ------------------------------------------------------------

test_that("prefix must be TRUE or FALSE", {

  expect_error(
    format_cor(0.42, prefix = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_cor(0.42, prefix = 1),
    "TRUE or FALSE"
  )
})


test_that("leading_zero must be TRUE or FALSE", {

  expect_error(
    format_cor(0.42, leading_zero = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_cor(0.42, leading_zero = 1),
    "TRUE or FALSE"
  )
})


# ------------------------------------------------------------
# Empty vectors
# ------------------------------------------------------------

test_that("format_cor handles empty numeric vectors", {

  expect_equal(
    format_cor(numeric(0)),
    character(0)
  )
})

