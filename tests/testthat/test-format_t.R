test_that("format_t formats basic t statistics", {
  expect_equal(
    format_t(0.86, df = 20),
    "t(20) = 0.86"
  )

  expect_equal(
    format_t(-2.14, df = 48),
    "t(48) = -2.14"
  )
})


test_that("format_t pairs results with format_p", {
  expect_equal(
    format_t(0.86, df = 20, p = 0.041),
    "t(20) = 0.86, p = .041"
  )

  expect_equal(
    format_t(3.10, df = 40, p = 0.001),
    "t(40) = 3.10, p = .001"
  )

  expect_equal(
    format_t(3.20, df = 40, p = 0.0009),
    "t(40) = 3.20, p < .001"
  )
})


test_that("format_t handles fractional degrees of freedom", {
  expect_equal(
    format_t(3.27, df = 105.5),
    "t(105.5) = 3.27"
  )

  expect_equal(
    format_t(3.27, df = 105.50),
    "t(105.5) = 3.27"
  )
})


test_that("format_t respects requested precision", {
  expect_equal(
    format_t(0.8642, df = 20, digits = 3),
    "t(20) = 0.864"
  )

  expect_equal(
    format_t(
      0.8642,
      df = 20,
      p = 0.04126,
      p_digits = 4
    ),
    "t(20) = 0.86, p = .0413"
  )
})


test_that("format_t supports styled output", {
  expect_equal(
    format_t(
      0.86,
      df = 20,
      p = 0.041,
      style = "markdown"
    ),
    "*t*(20) = 0.86, *p* = .041"
  )

  expect_equal(
    format_t(
      0.86,
      df = 20,
      p = 0.041,
      style = "html"
    ),
    "<i>t</i>(20) = 0.86, <i>p</i> = .041"
  )

  expect_equal(
    format_t(
      0.86,
      df = 20,
      p = 0.041,
      style = "latex"
    ),
    "\\textit{t}(20) = 0.86, \\textit{p} = .041"
  )
})


test_that("format_t is vectorized", {
  expect_equal(
    format_t(
      statistic = c(0.86, -2.14, 3.27),
      df = c(20, 48, 105.5),
      p = c(0.041, 0.038, 0.0012)
    ),
    c(
      "t(20) = 0.86, p = .041",
      "t(48) = -2.14, p = .038",
      "t(105.5) = 3.27, p = .001"
    )
  )
})


test_that("format_t preserves names", {
  x <- c(first = 0.86, second = -2.14)

  out <- format_t(
    statistic = x,
    df = c(20, 48)
  )

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_t preserves missing results", {
  expect_equal(
    format_t(
      statistic = c(0.86, NA),
      df = c(20, 30)
    ),
    c(
      "t(20) = 0.86",
      NA_character_
    )
  )

  expect_equal(
    format_t(
      statistic = c(0.86, 1.20),
      df = c(20, NA)
    ),
    c(
      "t(20) = 0.86",
      NA_character_
    )
  )

  expect_equal(
    format_t(
      statistic = c(0.86, 1.20),
      df = c(20, 30),
      p = c(0.041, NA)
    ),
    c(
      "t(20) = 0.86, p = .041",
      NA_character_
    )
  )
})


test_that("format_t handles empty vectors", {
  expect_equal(
    format_t(
      numeric(0),
      numeric(0)
    ),
    character(0)
  )
})


test_that("format_t rejects invalid inputs", {
  expect_error(
    format_t("0.86", df = 20),
    "`statistic` must be numeric"
  )

  expect_error(
    format_t(0.86, df = "20"),
    "`df` must be numeric"
  )

  expect_error(
    format_t(c(0.86, 1.2), df = 20),
    "must have the same length"
  )

  expect_error(
    format_t(0.86, df = 0),
    "`df` must contain positive finite values"
  )

  expect_error(
    format_t(0.86, df = -5),
    "`df` must contain positive finite values"
  )

  expect_error(
    format_t(Inf, df = 20),
    "`statistic` must contain only finite values"
  )

  expect_error(
    format_t(0.86, df = 20, p = "0.04"),
    "`p` must be numeric"
  )
})

