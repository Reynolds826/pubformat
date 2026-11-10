test_that("format_rr formats basic risk ratios", {
  expect_equal(
    format_rr(1.52),
    "RR = 1.52"
  )

  expect_equal(
    format_rr(0.74),
    "RR = 0.74"
  )

  expect_equal(
    format_rr(1),
    "RR = 1.00"
  )

  expect_equal(
    format_rr(0),
    "RR = 0.00"
  )
})


test_that("format_rr formats confidence intervals", {
  expect_equal(
    format_rr(
      1.52,
      lower = 1.18,
      upper = 1.96
    ),
    "RR = 1.52, 95% CI [1.18, 1.96]"
  )

  expect_equal(
    format_rr(
      0.74,
      lower = 0.58,
      upper = 0.95
    ),
    "RR = 0.74, 95% CI [0.58, 0.95]"
  )

  expect_equal(
    format_rr(
      0,
      lower = 0,
      upper = 0.35
    ),
    "RR = 0.00, 95% CI [0.00, 0.35]"
  )
})


test_that("format_rr supports alternate confidence levels", {
  expect_equal(
    format_rr(
      1.52,
      lower = 1.08,
      upper = 2.14,
      level = 0.99
    ),
    "RR = 1.52, 99% CI [1.08, 2.14]"
  )
})


test_that("format_rr respects requested precision", {
  expect_equal(
    format_rr(
      1.5267,
      digits = 3
    ),
    "RR = 1.527"
  )

  expect_equal(
    format_rr(
      1.5267,
      lower = 1.1834,
      upper = 1.9576,
      digits = 3,
      ci_digits = 3
    ),
    "RR = 1.527, 95% CI [1.183, 1.958]"
  )
})


test_that("format_rr supports output styles", {
  expect_equal(
    format_rr(
      1.52,
      style = "plain"
    ),
    "RR = 1.52"
  )

  expect_equal(
    format_rr(
      1.52,
      style = "markdown"
    ),
    "*RR* = 1.52"
  )

  expect_equal(
    format_rr(
      1.52,
      style = "html"
    ),
    "<i>RR</i> = 1.52"
  )

  expect_equal(
    format_rr(
      1.52,
      style = "latex"
    ),
    "\\textit{RR} = 1.52"
  )
})


test_that("format_rr is vectorized", {
  expect_equal(
    format_rr(
      risk_ratio = c(1.52, 0.74, 2.10),
      lower = c(1.18, 0.58, 1.40),
      upper = c(1.96, 0.95, 3.15)
    ),
    c(
      "RR = 1.52, 95% CI [1.18, 1.96]",
      "RR = 0.74, 95% CI [0.58, 0.95]",
      "RR = 2.10, 95% CI [1.40, 3.15]"
    )
  )
})


test_that("format_rr preserves names", {
  x <- c(first = 1.52, second = 0.74)

  out <- format_rr(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_rr preserves missing results", {
  expect_equal(
    format_rr(
      risk_ratio = c(1.52, NA, 0.74),
      lower = c(1.18, 0.80, 0.58),
      upper = c(1.96, 1.10, 0.95)
    ),
    c(
      "RR = 1.52, 95% CI [1.18, 1.96]",
      NA_character_,
      "RR = 0.74, 95% CI [0.58, 0.95]"
    )
  )
})


test_that("format_rr handles empty vectors", {
  expect_equal(
    format_rr(numeric(0)),
    character(0)
  )
})


test_that("format_rr rejects incomplete confidence intervals", {
  expect_error(
    format_rr(
      1.52,
      lower = 1.18
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_rr(
      1.52,
      upper = 1.96
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_rr rejects invalid risk ratios", {
  expect_error(
    format_rr("1.52"),
    "`risk_ratio` must be numeric"
  )

  expect_error(
    format_rr(Inf),
    "`risk_ratio` must contain only finite values"
  )

  expect_error(
    format_rr(-0.50),
    "`risk_ratio` cannot contain negative values"
  )
})


test_that("format_rr rejects invalid confidence intervals", {
  expect_error(
    format_rr(
      1.52,
      lower = "1.18",
      upper = 1.96
    ),
    "`lower` and `upper` must be numeric"
  )

  expect_error(
    format_rr(
      c(1.52, 0.74),
      lower = 1.18,
      upper = c(1.96, 0.95)
    ),
    "must have the same length"
  )

  expect_error(
    format_rr(
      1.52,
      lower = -0.01,
      upper = 1.96
    ),
    "`lower` and `upper` cannot contain negative values"
  )

  expect_error(
    format_rr(
      1.52,
      lower = 1.18,
      upper = -1.96
    ),
    "`lower` and `upper` cannot contain negative values"
  )
})


test_that("format_rr rejects invalid styles", {
  expect_error(
    format_rr(
      1.52,
      style = "word"
    )
  )
})
