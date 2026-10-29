test_that("format_d formats basic Cohen's d values", {
  expect_equal(
    format_d(0.52),
    "d = 0.52"
  )

  expect_equal(
    format_d(-0.31),
    "d = -0.31"
  )

  expect_equal(
    format_d(1.14),
    "d = 1.14"
  )
})


test_that("format_d formats confidence intervals", {
  expect_equal(
    format_d(
      0.52,
      lower = 0.18,
      upper = 0.86
    ),
    "d = 0.52, 95% CI [0.18, 0.86]"
  )

  expect_equal(
    format_d(
      -0.31,
      lower = -0.62,
      upper = 0.00
    ),
    "d = -0.31, 95% CI [-0.62, 0.00]"
  )
})


test_that("format_d supports alternate confidence levels", {
  expect_equal(
    format_d(
      0.52,
      lower = 0.10,
      upper = 0.94,
      level = 0.99
    ),
    "d = 0.52, 99% CI [0.10, 0.94]"
  )
})


test_that("format_d respects requested precision", {
  expect_equal(
    format_d(
      0.5237,
      digits = 3
    ),
    "d = 0.524"
  )

  expect_equal(
    format_d(
      0.5237,
      lower = 0.1812,
      upper = 0.8649,
      digits = 3,
      ci_digits = 3
    ),
    "d = 0.524, 95% CI [0.181, 0.865]"
  )
})


test_that("format_d supports styled output", {
  expect_equal(
    format_d(
      0.52,
      lower = 0.18,
      upper = 0.86,
      style = "markdown"
    ),
    "*d* = 0.52, 95% CI [0.18, 0.86]"
  )

  expect_equal(
    format_d(
      0.52,
      style = "html"
    ),
    "<i>d</i> = 0.52"
  )

  expect_equal(
    format_d(
      0.52,
      style = "latex"
    ),
    "\\textit{d} = 0.52"
  )
})


test_that("format_d is vectorized", {
  expect_equal(
    format_d(
      d = c(0.52, -0.31, 1.14),
      lower = c(0.18, -0.62, 0.80),
      upper = c(0.86, 0.00, 1.48)
    ),
    c(
      "d = 0.52, 95% CI [0.18, 0.86]",
      "d = -0.31, 95% CI [-0.62, 0.00]",
      "d = 1.14, 95% CI [0.80, 1.48]"
    )
  )
})


test_that("format_d preserves names", {
  x <- c(first = 0.52, second = -0.31)

  out <- format_d(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_d preserves missing results", {
  expect_equal(
    format_d(
      d = c(0.52, NA, -0.31),
      lower = c(0.18, 0.10, -0.62),
      upper = c(0.86, 0.50, 0.00)
    ),
    c(
      "d = 0.52, 95% CI [0.18, 0.86]",
      NA_character_,
      "d = -0.31, 95% CI [-0.62, 0.00]"
    )
  )
})


test_that("format_d handles empty vectors", {
  expect_equal(
    format_d(numeric(0)),
    character(0)
  )
})


test_that("format_d rejects incomplete confidence intervals", {
  expect_error(
    format_d(
      0.52,
      lower = 0.18
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_d(
      0.52,
      upper = 0.86
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_d rejects invalid inputs", {
  expect_error(
    format_d("0.52"),
    "`d` must be numeric"
  )

  expect_error(
    format_d(Inf),
    "`d` must contain only finite values"
  )

  expect_error(
    format_d(
      c(0.52, 0.31),
      lower = 0.18,
      upper = c(0.86, 0.60)
    ),
    "must have the same length"
  )

  expect_error(
    format_d(
      0.52,
      lower = "0.18",
      upper = 0.86
    ),
    "`lower` and `upper` must be numeric"
  )
})
