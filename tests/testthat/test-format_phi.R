test_that("format_phi formats basic phi coefficients", {
  expect_equal(
    format_phi(0.32),
    "φ = .32"
  )

  expect_equal(
    format_phi(-0.24),
    "φ = -.24"
  )

  expect_equal(
    format_phi(0),
    "φ = .00"
  )
})


test_that("format_phi formats confidence intervals", {
  expect_equal(
    format_phi(
      0.32,
      lower = 0.12,
      upper = 0.49
    ),
    "φ = .32, 95% CI [.12, .49]"
  )

  expect_equal(
    format_phi(
      -0.24,
      lower = -0.41,
      upper = 0.03
    ),
    "φ = -.24, 95% CI [-.41, .03]"
  )
})


test_that("format_phi supports alternate confidence levels", {
  expect_equal(
    format_phi(
      0.32,
      lower = 0.08,
      upper = 0.53,
      level = 0.99
    ),
    "φ = .32, 99% CI [.08, .53]"
  )
})


test_that("format_phi respects requested precision", {
  expect_equal(
    format_phi(
      0.3264,
      digits = 3
    ),
    "φ = .326"
  )

  expect_equal(
    format_phi(
      0.3264,
      lower = 0.1214,
      upper = 0.4936,
      digits = 3,
      ci_digits = 3
    ),
    "φ = .326, 95% CI [.121, .494]"
  )
})


test_that("format_phi is vectorized", {
  expect_equal(
    format_phi(
      phi = c(0.32, -0.24, 0.08),
      lower = c(0.12, -0.41, -0.05),
      upper = c(0.49, 0.03, 0.21)
    ),
    c(
      "φ = .32, 95% CI [.12, .49]",
      "φ = -.24, 95% CI [-.41, .03]",
      "φ = .08, 95% CI [-.05, .21]"
    )
  )
})


test_that("format_phi preserves names", {
  x <- c(first = 0.32, second = -0.24)

  out <- format_phi(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_phi preserves missing results", {
  expect_equal(
    format_phi(
      phi = c(0.32, NA, -0.24),
      lower = c(0.12, 0.01, -0.41),
      upper = c(0.49, 0.10, 0.03)
    ),
    c(
      "φ = .32, 95% CI [.12, .49]",
      NA_character_,
      "φ = -.24, 95% CI [-.41, .03]"
    )
  )
})


test_that("format_phi handles empty vectors", {
  expect_equal(
    format_phi(numeric(0)),
    character(0)
  )
})


test_that("format_phi rejects incomplete confidence intervals", {
  expect_error(
    format_phi(
      0.32,
      lower = 0.12
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_phi(
      0.32,
      upper = 0.49
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_phi rejects invalid coefficients", {
  expect_error(
    format_phi("0.32"),
    "`phi` must be numeric"
  )

  expect_error(
    format_phi(Inf),
    "`phi` must contain only finite values"
  )

  expect_error(
    format_phi(1.01),
    "`phi` must contain values between -1 and 1"
  )

  expect_error(
    format_phi(-1.01),
    "`phi` must contain values between -1 and 1"
  )
})


test_that("format_phi rejects invalid confidence intervals", {
  expect_error(
    format_phi(
      0.32,
      lower = "0.12",
      upper = 0.49
    ),
    "`lower` and `upper` must be numeric"
  )

  expect_error(
    format_phi(
      c(0.32, 0.21),
      lower = 0.12,
      upper = c(0.49, 0.35)
    ),
    "must have the same length"
  )

  expect_error(
    format_phi(
      0.32,
      lower = -1.01,
      upper = 0.49
    ),
    "`lower` and `upper` must contain values between -1 and 1"
  )

  expect_error(
    format_phi(
      0.32,
      lower = 0.12,
      upper = 1.01
    ),
    "`lower` and `upper` must contain values between -1 and 1"
  )
})
