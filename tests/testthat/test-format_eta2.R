test_that("format_eta2 formats basic eta-squared values", {
  expect_equal(
    format_eta2(0.14),
    "η² = .14"
  )

  expect_equal(
    format_eta2(0),
    "η² = .00"
  )

  expect_equal(
    format_eta2(0.67),
    "η² = .67"
  )
})


test_that("format_eta2 formats confidence intervals", {
  expect_equal(
    format_eta2(
      0.14,
      lower = 0.08,
      upper = 0.21
    ),
    "η² = .14, 95% CI [.08, .21]"
  )
})


test_that("format_eta2 supports alternate confidence levels", {
  expect_equal(
    format_eta2(
      0.14,
      lower = 0.05,
      upper = 0.25,
      level = 0.99
    ),
    "η² = .14, 99% CI [.05, .25]"
  )
})


test_that("format_eta2 respects requested precision", {
  expect_equal(
    format_eta2(
      0.1437,
      digits = 3
    ),
    "η² = .144"
  )

  expect_equal(
    format_eta2(
      0.1437,
      lower = 0.0812,
      upper = 0.2149,
      digits = 3,
      ci_digits = 3
    ),
    "η² = .144, 95% CI [.081, .215]"
  )
})


test_that("format_eta2 is vectorized", {
  expect_equal(
    format_eta2(
      eta2 = c(0.14, 0.00, 0.67),
      lower = c(0.08, 0.00, 0.55),
      upper = c(0.21, 0.04, 0.78)
    ),
    c(
      "η² = .14, 95% CI [.08, .21]",
      "η² = .00, 95% CI [.00, .04]",
      "η² = .67, 95% CI [.55, .78]"
    )
  )
})


test_that("format_eta2 preserves names", {
  x <- c(first = 0.14, second = 0.67)

  out <- format_eta2(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_eta2 preserves missing results", {
  expect_equal(
    format_eta2(
      eta2 = c(0.14, NA, 0.67),
      lower = c(0.08, 0.01, 0.55),
      upper = c(0.21, 0.10, 0.78)
    ),
    c(
      "η² = .14, 95% CI [.08, .21]",
      NA_character_,
      "η² = .67, 95% CI [.55, .78]"
    )
  )
})


test_that("format_eta2 handles empty vectors", {
  expect_equal(
    format_eta2(numeric(0)),
    character(0)
  )
})


test_that("format_eta2 rejects incomplete confidence intervals", {
  expect_error(
    format_eta2(
      0.14,
      lower = 0.08
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_eta2(
      0.14,
      upper = 0.21
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_eta2 rejects invalid effect sizes", {
  expect_error(
    format_eta2("0.14"),
    "`eta2` must be numeric"
  )

  expect_error(
    format_eta2(Inf),
    "`eta2` must contain only finite values"
  )

  expect_error(
    format_eta2(-0.01),
    "`eta2` must contain values between 0 and 1"
  )

  expect_error(
    format_eta2(1.01),
    "`eta2` must contain values between 0 and 1"
  )
})


test_that("format_eta2 rejects invalid confidence intervals", {
  expect_error(
    format_eta2(
      0.14,
      lower = "0.08",
      upper = 0.21
    ),
    "`lower` and `upper` must be numeric"
  )

  expect_error(
    format_eta2(
      c(0.14, 0.20),
      lower = 0.08,
      upper = c(0.21, 0.30)
    ),
    "must have the same length"
  )

  expect_error(
    format_eta2(
      0.14,
      lower = -0.01,
      upper = 0.21
    ),
    "`lower` and `upper` must contain values between 0 and 1"
  )

  expect_error(
    format_eta2(
      0.14,
      lower = 0.08,
      upper = 1.01
    ),
    "`lower` and `upper` must contain values between 0 and 1"
  )
})
