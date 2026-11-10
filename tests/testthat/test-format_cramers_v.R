test_that("format_cramers_v formats basic Cramer's V values", {
  expect_equal(
    format_cramers_v(0.32),
    "V = .32"
  )

  expect_equal(
    format_cramers_v(0),
    "V = .00"
  )

  expect_equal(
    format_cramers_v(1),
    "V = 1.00"
  )
})


test_that("format_cramers_v formats confidence intervals", {
  expect_equal(
    format_cramers_v(
      0.32,
      lower = 0.18,
      upper = 0.45
    ),
    "V = .32, 95% CI [.18, .45]"
  )
})


test_that("format_cramers_v supports alternate confidence levels", {
  expect_equal(
    format_cramers_v(
      0.32,
      lower = 0.14,
      upper = 0.49,
      level = 0.99
    ),
    "V = .32, 99% CI [.14, .49]"
  )
})


test_that("format_cramers_v respects requested precision", {
  expect_equal(
    format_cramers_v(
      0.3264,
      digits = 3
    ),
    "V = .326"
  )

  expect_equal(
    format_cramers_v(
      0.3264,
      lower = 0.1814,
      upper = 0.4536,
      digits = 3,
      ci_digits = 3
    ),
    "V = .326, 95% CI [.181, .454]"
  )
})


test_that("format_cramers_v supports output styles", {
  expect_equal(
    format_cramers_v(
      0.32,
      style = "plain"
    ),
    "V = .32"
  )

  expect_equal(
    format_cramers_v(
      0.32,
      style = "markdown"
    ),
    "*V* = .32"
  )

  expect_equal(
    format_cramers_v(
      0.32,
      style = "html"
    ),
    "<i>V</i> = .32"
  )

  expect_equal(
    format_cramers_v(
      0.32,
      style = "latex"
    ),
    "\\textit{V} = .32"
  )
})


test_that("format_cramers_v is vectorized", {
  expect_equal(
    format_cramers_v(
      v = c(0.32, 0.18, 0.47),
      lower = c(0.18, 0.05, 0.33),
      upper = c(0.45, 0.31, 0.58)
    ),
    c(
      "V = .32, 95% CI [.18, .45]",
      "V = .18, 95% CI [.05, .31]",
      "V = .47, 95% CI [.33, .58]"
    )
  )
})


test_that("format_cramers_v preserves names", {
  x <- c(first = 0.32, second = 0.18)

  out <- format_cramers_v(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_cramers_v preserves missing results", {
  expect_equal(
    format_cramers_v(
      v = c(0.32, NA, 0.47),
      lower = c(0.18, 0.05, 0.33),
      upper = c(0.45, 0.31, 0.58)
    ),
    c(
      "V = .32, 95% CI [.18, .45]",
      NA_character_,
      "V = .47, 95% CI [.33, .58]"
    )
  )
})


test_that("format_cramers_v handles empty vectors", {
  expect_equal(
    format_cramers_v(numeric(0)),
    character(0)
  )
})


test_that("format_cramers_v rejects incomplete confidence intervals", {
  expect_error(
    format_cramers_v(
      0.32,
      lower = 0.18
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_cramers_v(
      0.32,
      upper = 0.45
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_cramers_v rejects invalid coefficients", {
  expect_error(
    format_cramers_v("0.32"),
    "`v` must be numeric"
  )

  expect_error(
    format_cramers_v(Inf),
    "`v` must contain only finite values"
  )

  expect_error(
    format_cramers_v(-0.01),
    "`v` must contain values between 0 and 1"
  )

  expect_error(
    format_cramers_v(1.01),
    "`v` must contain values between 0 and 1"
  )
})


test_that("format_cramers_v rejects invalid confidence intervals", {
  expect_error(
    format_cramers_v(
      0.32,
      lower = "0.18",
      upper = 0.45
    ),
    "`lower` and `upper` must be numeric"
  )

  expect_error(
    format_cramers_v(
      c(0.32, 0.18),
      lower = 0.18,
      upper = c(0.45, 0.31)
    ),
    "must have the same length"
  )

  expect_error(
    format_cramers_v(
      0.32,
      lower = -0.01,
      upper = 0.45
    ),
    "`lower` and `upper` must contain values between 0 and 1"
  )

  expect_error(
    format_cramers_v(
      0.32,
      lower = 0.18,
      upper = 1.01
    ),
    "`lower` and `upper` must contain values between 0 and 1"
  )
})


test_that("format_cramers_v rejects invalid styles", {
  expect_error(
    format_cramers_v(
      0.32,
      style = "word"
    )
  )
})
