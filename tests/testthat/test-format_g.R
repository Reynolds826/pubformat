test_that("format_g formats basic Hedges' g values", {
  expect_equal(
    format_g(0.49),
    "g = 0.49"
  )

  expect_equal(
    format_g(-0.28),
    "g = -0.28"
  )

  expect_equal(
    format_g(1.05),
    "g = 1.05"
  )
})


test_that("format_g formats confidence intervals", {
  expect_equal(
    format_g(
      0.49,
      lower = 0.16,
      upper = 0.82
    ),
    "g = 0.49, 95% CI [0.16, 0.82]"
  )

  expect_equal(
    format_g(
      -0.28,
      lower = -0.55,
      upper = -0.01
    ),
    "g = -0.28, 95% CI [-0.55, -0.01]"
  )
})


test_that("format_g supports alternate confidence levels", {
  expect_equal(
    format_g(
      0.49,
      lower = 0.08,
      upper = 0.90,
      level = 0.99
    ),
    "g = 0.49, 99% CI [0.08, 0.90]"
  )
})


test_that("format_g respects requested precision", {
  expect_equal(
    format_g(
      0.4937,
      digits = 3
    ),
    "g = 0.494"
  )

  expect_equal(
    format_g(
      0.4937,
      lower = 0.1612,
      upper = 0.8249,
      digits = 3,
      ci_digits = 3
    ),
    "g = 0.494, 95% CI [0.161, 0.825]"
  )
})


test_that("format_g supports styled output", {
  expect_equal(
    format_g(
      0.49,
      lower = 0.16,
      upper = 0.82,
      style = "markdown"
    ),
    "*g* = 0.49, 95% CI [0.16, 0.82]"
  )

  expect_equal(
    format_g(
      0.49,
      style = "html"
    ),
    "<i>g</i> = 0.49"
  )

  expect_equal(
    format_g(
      0.49,
      style = "latex"
    ),
    "\\textit{g} = 0.49"
  )
})


test_that("format_g is vectorized", {
  expect_equal(
    format_g(
      g = c(0.49, -0.28, 1.05),
      lower = c(0.16, -0.55, 0.71),
      upper = c(0.82, -0.01, 1.39)
    ),
    c(
      "g = 0.49, 95% CI [0.16, 0.82]",
      "g = -0.28, 95% CI [-0.55, -0.01]",
      "g = 1.05, 95% CI [0.71, 1.39]"
    )
  )
})


test_that("format_g preserves names", {
  x <- c(first = 0.49, second = -0.28)

  out <- format_g(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_g preserves missing results", {
  expect_equal(
    format_g(
      g = c(0.49, NA, -0.28),
      lower = c(0.16, 0.05, -0.55),
      upper = c(0.82, 0.40, -0.01)
    ),
    c(
      "g = 0.49, 95% CI [0.16, 0.82]",
      NA_character_,
      "g = -0.28, 95% CI [-0.55, -0.01]"
    )
  )
})


test_that("format_g handles empty vectors", {
  expect_equal(
    format_g(numeric(0)),
    character(0)
  )
})


test_that("format_g rejects incomplete confidence intervals", {
  expect_error(
    format_g(
      0.49,
      lower = 0.16
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_g(
      0.49,
      upper = 0.82
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_g rejects invalid inputs", {
  expect_error(
    format_g("0.49"),
    "`g` must be numeric"
  )

  expect_error(
    format_g(Inf),
    "`g` must contain only finite values"
  )

  expect_error(
    format_g(
      c(0.49, 0.28),
      lower = 0.16,
      upper = c(0.82, 0.60)
    ),
    "must have the same length"
  )

  expect_error(
    format_g(
      0.49,
      lower = "0.16",
      upper = 0.82
    ),
    "`lower` and `upper` must be numeric"
  )
})
