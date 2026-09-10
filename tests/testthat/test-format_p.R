# ============================================================
# Tests for format_p()
# ============================================================


# ------------------------------------------------------------
# Basic formatting
# ------------------------------------------------------------

test_that("format_p formats ordinary p-values correctly", {

  expect_equal(
    format_p(0.048),
    "p = .048"
  )

  expect_equal(
    format_p(0.2),
    "p = .200"
  )

  expect_equal(
    format_p(1),
    "p = 1.000"
  )
})


# ------------------------------------------------------------
# Leading zeros and trailing zeros
# ------------------------------------------------------------

test_that("format_p uses publication-style decimal formatting", {

  expect_equal(
    format_p(0.5),
    "p = .500"
  )

  expect_equal(
    format_p(0.05),
    "p = .050"
  )

  expect_equal(
    format_p(0.01),
    "p = .010"
  )
})


# ------------------------------------------------------------
# Critical .001 reporting boundary
# ------------------------------------------------------------

test_that("format_p handles the .001 boundary correctly", {

  # Exact threshold should NOT be converted to < .001
  expect_equal(
    format_p(0.001),
    "p = .001"
  )

  # Values truly below .001 use less-than notation
  expect_equal(
    format_p(0.000999),
    "p < .001"
  )

  expect_equal(
    format_p(0.0001),
    "p < .001"
  )
})


# ------------------------------------------------------------
# Zero p-values
# ------------------------------------------------------------

test_that("format_p never reports p = .000", {

  expect_equal(
    format_p(0),
    "p < .001"
  )

  expect_equal(
    format_p(0.0004),
    "p < .001"
  )

  expect_false(
    any(grepl("= \\.000$", format_p(c(0, 0.0001, 0.0004))))
  )
})


# ------------------------------------------------------------
# Significance-code boundaries
# ------------------------------------------------------------

test_that("significance codes use strict inequality boundaries", {

  # .10 boundary
  expect_equal(
    format_p(0.10, sig = TRUE),
    "p = .100 ns"
  )

  expect_equal(
    format_p(0.0999, sig = TRUE),
    "p = .100 ."
  )


  # .05 boundary
  expect_equal(
    format_p(0.05, sig = TRUE),
    "p = .050 ."
  )

  expect_equal(
    format_p(0.0499, sig = TRUE),
    "p = .050 *"
  )


  # .01 boundary
  expect_equal(
    format_p(0.01, sig = TRUE),
    "p = .010 *"
  )

  expect_equal(
    format_p(0.0099, sig = TRUE),
    "p = .010 **"
  )


  # .001 boundary
  expect_equal(
    format_p(0.001, sig = TRUE),
    "p = .001 **"
  )

  expect_equal(
    format_p(0.0009, sig = TRUE),
    "p < .001 ***"
  )
})


# ------------------------------------------------------------
# Significance codes use underlying values, not rounded values
# ------------------------------------------------------------

test_that("significance codes are based on unrounded p-values", {

  # Displays .050 but underlying p-value is < .05
  expect_equal(
    format_p(0.0499, sig = TRUE),
    "p = .050 *"
  )

  # Displays .010 but underlying p-value is < .01
  expect_equal(
    format_p(0.0099, sig = TRUE),
    "p = .010 **"
  )
})


# ------------------------------------------------------------
# Significance codes are optional
# ------------------------------------------------------------

test_that("significance codes are off by default", {

  expect_equal(
    format_p(0.048),
    "p = .048"
  )

  expect_equal(
    format_p(0.048, sig = TRUE),
    "p = .048 *"
  )
})


# ------------------------------------------------------------
# Prefix behavior
# ------------------------------------------------------------

test_that("p prefix can be removed", {

  expect_equal(
    format_p(0.048, prefix = FALSE),
    "= .048"
  )

  expect_equal(
    format_p(0.0002, prefix = FALSE),
    "< .001"
  )

  expect_equal(
    format_p(0.048, prefix = FALSE, sig = TRUE),
    "= .048 *"
  )
})


# ------------------------------------------------------------
# Vectorization
# ------------------------------------------------------------

test_that("format_p is vectorized", {

  p_values <- c(
    0.048,
    0.006,
    0.0002,
    0.213
  )

  expected <- c(
    "p = .048",
    "p = .006",
    "p < .001",
    "p = .213"
  )

  expect_equal(
    format_p(p_values),
    expected
  )
})


test_that("format_p vectorizes significance codes", {

  p_values <- c(
    0.20,
    0.08,
    0.04,
    0.008,
    0.0008
  )

  expected <- c(
    "p = .200 ns",
    "p = .080 .",
    "p = .040 *",
    "p = .008 **",
    "p < .001 ***"
  )

  expect_equal(
    format_p(p_values, sig = TRUE),
    expected
  )
})


# ------------------------------------------------------------
# Missing values
# ------------------------------------------------------------

test_that("format_p preserves missing values", {

  expect_equal(
    format_p(NA_real_),
    NA_character_
  )

  expect_equal(
    format_p(NaN),
    NA_character_
  )

  expect_equal(
    format_p(c(0.05, NA, 0.01)),
    c(
      "p = .050",
      NA_character_,
      "p = .010"
    )
  )
})


# ------------------------------------------------------------
# Named vectors
# ------------------------------------------------------------

test_that("format_p preserves vector names", {

  p_values <- c(
    treatment = 0.032,
    interaction = 0.0004
  )

  result <- format_p(p_values)

  expect_equal(
    names(result),
    c("treatment", "interaction")
  )

  expect_equal(
    unname(result),
    c(
      "p = .032",
      "p < .001"
    )
  )
})


# ------------------------------------------------------------
# Different decimal precision
# ------------------------------------------------------------

test_that("digits controls displayed precision", {

  expect_equal(
    format_p(0.0483, digits = 2),
    "p = .05"
  )

  expect_equal(
    format_p(0.0483, digits = 4),
    "p = .0483"
  )
})


# ------------------------------------------------------------
# Reporting threshold follows digits by default
# ------------------------------------------------------------

test_that("default reporting threshold follows displayed precision", {

  # digits = 2 -> threshold = .01
  expect_equal(
    format_p(0.005, digits = 2),
    "p < .01"
  )

  expect_equal(
    format_p(0.01, digits = 2),
    "p = .01"
  )


  # digits = 3 -> threshold = .001
  expect_equal(
    format_p(0.0005, digits = 3),
    "p < .001"
  )

  expect_equal(
    format_p(0.001, digits = 3),
    "p = .001"
  )


  # digits = 4 -> threshold = .0001
  expect_equal(
    format_p(0.00005, digits = 4),
    "p < .0001"
  )

  expect_equal(
    format_p(0.0001, digits = 4),
    "p = .0001"
  )
})


# ------------------------------------------------------------
# Explicit reporting thresholds
# ------------------------------------------------------------

test_that("custom reporting thresholds work correctly", {

  expect_equal(
    format_p(0.004, threshold = 0.005),
    "p < .005"
  )

  expect_equal(
    format_p(0.005, threshold = 0.005),
    "p = .005"
  )

  expect_equal(
    format_p(0.006, threshold = 0.005),
    "p = .006"
  )
})


# ------------------------------------------------------------
# Reporting threshold is independent of significance
# ------------------------------------------------------------

test_that("reporting threshold does not change significance classification", {

  expect_equal(
    format_p(
      0.004,
      threshold = 0.005,
      sig = TRUE
    ),
    "p < .005 **"
  )

  expect_equal(
    format_p(
      0.04,
      threshold = 0.05,
      sig = TRUE
    ),
    "p < .05 *"
  )
})


# ------------------------------------------------------------
# Unsafe threshold / precision combinations
# ------------------------------------------------------------

test_that("threshold cannot be smaller than displayed precision", {

  expect_error(
    format_p(
      0.0005,
      digits = 3,
      threshold = 0.0001
    ),
    "cannot be smaller"
  )

  expect_error(
    format_p(
      0.005,
      digits = 2,
      threshold = 0.001
    ),
    "cannot be smaller"
  )
})


# ------------------------------------------------------------
# Invalid p-values
# ------------------------------------------------------------

test_that("invalid p-values produce informative errors", {

  expect_error(
    format_p(-0.01),
    "between 0 and 1"
  )

  expect_error(
    format_p(1.01),
    "between 0 and 1"
  )

  expect_error(
    format_p(Inf),
    "infinite"
  )

  expect_error(
    format_p(-Inf),
    "infinite"
  )

  expect_error(
    format_p("0.05"),
    "must be numeric"
  )
})


# ------------------------------------------------------------
# Invalid digits
# ------------------------------------------------------------

test_that("digits must be a non-negative integer", {

  expect_error(
    format_p(0.05, digits = -1),
    "non-negative integer"
  )

  expect_error(
    format_p(0.05, digits = 2.5),
    "non-negative integer"
  )

  expect_error(
    format_p(0.05, digits = NA),
    "non-negative integer"
  )

  expect_error(
    format_p(0.05, digits = Inf),
    "non-negative integer"
  )

  expect_error(
    format_p(0.05, digits = "3"),
    "non-negative integer"
  )
})


# ------------------------------------------------------------
# Invalid thresholds
# ------------------------------------------------------------

test_that("threshold must be valid when supplied", {

  expect_error(
    format_p(0.05, threshold = 0),
    "greater than 0"
  )

  expect_error(
    format_p(0.05, threshold = -0.001),
    "greater than 0"
  )

  expect_error(
    format_p(0.05, threshold = 1.1),
    "no greater than 1"
  )

  expect_error(
    format_p(0.05, threshold = NA_real_),
    "single numeric value"
  )

  expect_error(
    format_p(0.05, threshold = c(0.001, 0.01)),
    "single numeric value"
  )
})


# ------------------------------------------------------------
# Invalid logical arguments
# ------------------------------------------------------------

test_that("sig must be TRUE or FALSE", {

  expect_error(
    format_p(0.05, sig = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_p(0.05, sig = 1),
    "TRUE or FALSE"
  )

  expect_error(
    format_p(0.05, sig = c(TRUE, FALSE)),
    "TRUE or FALSE"
  )
})


test_that("prefix must be TRUE or FALSE", {

  expect_error(
    format_p(0.05, prefix = NA),
    "TRUE or FALSE"
  )

  expect_error(
    format_p(0.05, prefix = 1),
    "TRUE or FALSE"
  )

  expect_error(
    format_p(0.05, prefix = c(TRUE, FALSE)),
    "TRUE or FALSE"
  )
})


# ------------------------------------------------------------
# Empty vectors
# ------------------------------------------------------------

test_that("format_p handles empty numeric vectors", {

  expect_equal(
    format_p(numeric(0)),
    character(0)
  )
})
