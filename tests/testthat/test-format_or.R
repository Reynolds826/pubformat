test_that("format_or formats basic odds ratios", {
  expect_equal(
    format_or(1.84),
    "OR = 1.84"
  )

  expect_equal(
    format_or(0.62),
    "OR = 0.62"
  )

  expect_equal(
    format_or(1),
    "OR = 1.00"
  )

  expect_equal(
    format_or(0),
    "OR = 0.00"
  )
})


test_that("format_or formats confidence intervals", {
  expect_equal(
    format_or(
      1.84,
      lower = 1.20,
      upper = 2.82
    ),
    "OR = 1.84, 95% CI [1.20, 2.82]"
  )

  expect_equal(
    format_or(
      0.62,
      lower = 0.41,
      upper = 0.94
    ),
    "OR = 0.62, 95% CI [0.41, 0.94]"
  )

  expect_equal(
    format_or(
      0,
      lower = 0,
      upper = 0.35
    ),
    "OR = 0.00, 95% CI [0.00, 0.35]"
  )
})


test_that("format_or supports alternate confidence levels", {
  expect_equal(
    format_or(
      1.84,
      lower = 1.10,
      upper = 3.07,
      level = 0.99
    ),
    "OR = 1.84, 99% CI [1.10, 3.07]"
  )
})


test_that("format_or respects requested precision", {
  expect_equal(
    format_or(
      1.8467,
      digits = 3
    ),
    "OR = 1.847"
  )

  expect_equal(
    format_or(
      1.8467,
      lower = 1.2034,
      upper = 2.8176,
      digits = 3,
      ci_digits = 3
    ),
    "OR = 1.847, 95% CI [1.203, 2.818]"
  )
})


test_that("format_or supports output styles", {
  expect_equal(
    format_or(
      1.84,
      style = "plain"
    ),
    "OR = 1.84"
  )

  expect_equal(
    format_or(
      1.84,
      style = "markdown"
    ),
    "*OR* = 1.84"
  )

  expect_equal(
    format_or(
      1.84,
      style = "html"
    ),
    "<i>OR</i> = 1.84"
  )

  expect_equal(
    format_or(
      1.84,
      style = "latex"
    ),
    "\\textit{OR} = 1.84"
  )
})


test_that("format_or is vectorized", {
  expect_equal(
    format_or(
      odds_ratio = c(1.84, 0.62, 3.10),
      lower = c(1.20, 0.41, 1.75),
      upper = c(2.82, 0.94, 5.49)
    ),
    c(
      "OR = 1.84, 95% CI [1.20, 2.82]",
      "OR = 0.62, 95% CI [0.41, 0.94]",
      "OR = 3.10, 95% CI [1.75, 5.49]"
    )
  )
})


test_that("format_or preserves names", {
  x <- c(first = 1.84, second = 0.62)

  out <- format_or(x)

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_or preserves missing results", {
  expect_equal(
    format_or(
      odds_ratio = c(1.84, NA, 0.62),
      lower = c(1.20, 0.80, 0.41),
      upper = c(2.82, 1.10, 0.94)
    ),
    c(
      "OR = 1.84, 95% CI [1.20, 2.82]",
      NA_character_,
      "OR = 0.62, 95% CI [0.41, 0.94]"
    )
  )
})


test_that("format_or handles empty vectors", {
  expect_equal(
    format_or(numeric(0)),
    character(0)
  )
})


test_that("format_or rejects incomplete confidence intervals", {
  expect_error(
    format_or(
      1.84,
      lower = 1.20
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )

  expect_error(
    format_or(
      1.84,
      upper = 2.82
    ),
    "`lower` and `upper` must either both be supplied or both be NULL"
  )
})


test_that("format_or rejects invalid odds ratios", {
  expect_error(
    format_or("1.84"),
    "`odds_ratio` must be numeric"
  )

  expect_error(
    format_or(Inf),
    "`odds_ratio` must contain only finite values"
  )

  expect_error(
    format_or(-0.50),
    "`odds_ratio` cannot contain negative values"
  )
})


test_that("format_or rejects invalid confidence intervals", {
  expect_error(
    format_or(
      1.84,
      lower = "1.20",
      upper = 2.82
    ),
    "`lower` and `upper` must be numeric"
  )

  expect_error(
    format_or(
      c(1.84, 0.62),
      lower = 1.20,
      upper = c(2.82, 0.94)
    ),
    "must have the same length"
  )

  expect_error(
    format_or(
      1.84,
      lower = -0.01,
      upper = 2.82
    ),
    "`lower` and `upper` cannot contain negative values"
  )

  expect_error(
    format_or(
      1.84,
      lower = 1.20,
      upper = -2.82
    ),
    "`lower` and `upper` cannot contain negative values"
  )
})


test_that("format_or rejects invalid styles", {
  expect_error(
    format_or(
      1.84,
      style = "word"
    )
  )
})
