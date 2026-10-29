test_that("format_omega2 formats basic omega-squared values", {
  expect_equal(
    format_omega2(0.08),
    "ω² = .08"
  )

  expect_equal(
    format_omega2(-0.02),
    "ω² = -.02"
  )

  expect_equal(
    format_omega2(0),
    "ω² = .00"
  )
})


test_that("format_omega2 formats confidence intervals", {
  expect_equal(
    format_omega2(
      0.08,
      lower = 0.02,
      upper = 0.15
    ),
    "ω² = .08, 95% CI [.02, .15]"
  )

  expect_equal(
    format_omega2(
      0.01,
      lower = -0.03,
      upper = 0.05
    ),
    "ω² = .01, 95% CI [-.03, .05]"
  )
})


test_that("format_omega2 supports alternate confidence levels", {
  expect_equal(
    format_omega2(
      0.08,
      lower = 0.01,
      upper = 0.17,
      level = 0.99
    ),
    "ω² = .08, 99% CI [.01, .17]"
  )
})


test_that("format_omega2 respects requested precision", {
  expect_equal(
    format_omega2(
      0.0837,
      digits = 3
    ),
    "ω² = .084"
  )

  expect_equal(
    format_omega2(
      0.0837,
      lower = 0.0212,
      upper = 0.1549,
      digits = 3,
      ci_digits = 3
    ),
    "ω² = .084, 95% CI [.021, .155]"
  )
})


test_that("format_omega2 is vectorized", {
  expect_equal(
    format_omega2(
      omega2 = c(0.08, -0.02, 0.31),
      lower = c(0.02, -0.06, 0.20),
      upper = c(0.15, 0.02, 0.42)
    ),
    c(
      "ω² = .08, 95% CI [.02, .15]",
      "ω² = -.02, 95% CI [-.06, .02]",
      "ω² = .31, 95% CI [.20, .42]"
    )
  )
})


test_that("format_omega2 preserves names", {
  x <- c(first = 0.08, second = -0.02)

  out <- format_omega2(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_omega2 preserves missing results", {
  expect_equal(
    format_omega2(
      omega2 = c(0.08, NA, -0.02),
      lower = c(0.02, -0.01, -0.06),
      upper = c(0.15, 0.03, 0.02)
    ),
    c(
      "ω² = .08, 95% CI [.02, .15]",
      NA_character_,
      "ω² = -.02, 95% CI [-.06, .02]"
    )
  )
})


test_that("format_omega2 handles empty vectors", {
  expect_equal(
    format_omega2(numeric(0)),
    character(0)
  )
})


test_that("format_omega2 rejects incomplete confidence intervals", {
  expect_error(
    format_omega2(
      0.08,
      lower = 0.02
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_omega2(
      0.08,
      upper = 0.15
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_omega2 rejects invalid effect sizes", {
  expect_error(
    format_omega2("0.08"),
    "`omega2` must be numeric"
  )

  expect_error(
    format_omega2(Inf),
    "`omega2` must contain only finite values"
  )

  expect_error(
    format_omega2(1.01),
    "`omega2` cannot contain values greater than 1"
  )
})


test_that("format_omega2 rejects invalid confidence intervals", {
  expect_error(
    format_omega2(
      0.08,
      lower = "0.02",
      upper = 0.15
    ),
    "`lower` and `upper` must be numeric"
  )

  expect_error(
    format_omega2(
      c(0.08, 0.12),
      lower = 0.02,
      upper = c(0.15, 0.20)
    ),
    "must have the same length"
  )

  expect_error(
    format_omega2(
      0.08,
      lower = 0.02,
      upper = 1.01
    ),
    "`lower` and `upper` cannot contain values greater than 1"
  )
})
