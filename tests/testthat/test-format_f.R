test_that("format_f formats basic F statistics", {
  expect_equal(
    format_f(2.50, df1 = 2, df2 = 30),
    "F(2, 30) = 2.50"
  )

  expect_equal(
    format_f(4.4344, df1 = 1, df2 = 3262.9),
    "F(1, 3262.9) = 4.43"
  )
})


test_that("format_f pairs results with format_p", {
  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 3262.9,
      p = 0.03530
    ),
    "F(1, 3262.9) = 4.43, p = .035"
  )

  expect_equal(
    format_f(
      107.8924,
      df1 = 1,
      df2 = 86.7,
      p = 2e-16
    ),
    "F(1, 86.7) = 107.89, p < .001"
  )
})


test_that("format_f respects the p-value boundary", {
  expect_equal(
    format_f(
      5.00,
      df1 = 1,
      df2 = 40,
      p = 0.001
    ),
    "F(1, 40) = 5.00, p = .001"
  )

  expect_equal(
    format_f(
      5.00,
      df1 = 1,
      df2 = 40,
      p = 0.0009
    ),
    "F(1, 40) = 5.00, p < .001"
  )
})


test_that("format_f handles fractional degrees of freedom", {
  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 3262.90
    ),
    "F(1, 3262.9) = 4.43"
  )

  expect_equal(
    format_f(
      3.25,
      df1 = 1.5,
      df2 = 86.60
    ),
    "F(1.5, 86.6) = 3.25"
  )
})


test_that("format_f respects requested precision", {
  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 30,
      digits = 3
    ),
    "F(1, 30) = 4.434"
  )

  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 30,
      p = 0.03526,
      p_digits = 4
    ),
    "F(1, 30) = 4.43, p = .0353"
  )
})


test_that("format_f supports styled output", {
  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 3262.9,
      p = 0.03530,
      style = "markdown"
    ),
    "*F*(1, 3262.9) = 4.43, *p* = .035"
  )

  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 3262.9,
      p = 0.03530,
      style = "html"
    ),
    "<i>F</i>(1, 3262.9) = 4.43, <i>p</i> = .035"
  )

  expect_equal(
    format_f(
      4.4344,
      df1 = 1,
      df2 = 3262.9,
      p = 0.03530,
      style = "latex"
    ),
    "\\textit{F}(1, 3262.9) = 4.43, \\textit{p} = .035"
  )
})


test_that("format_f is vectorized", {
  expect_equal(
    format_f(
      statistic = c(2.50, 4.4344),
      df1 = c(2, 1),
      df2 = c(30, 3262.9),
      p = c(0.091, 0.03530)
    ),
    c(
      "F(2, 30) = 2.50, p = .091",
      "F(1, 3262.9) = 4.43, p = .035"
    )
  )
})


test_that("format_f preserves names", {
  x <- c(first = 2.50, second = 4.4344)

  out <- format_f(
    statistic = x,
    df1 = c(2, 1),
    df2 = c(30, 3262.9)
  )

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_f preserves missing results", {
  expect_equal(
    format_f(
      statistic = c(2.50, NA),
      df1 = c(2, 1),
      df2 = c(30, 40)
    ),
    c(
      "F(2, 30) = 2.50",
      NA_character_
    )
  )

  expect_equal(
    format_f(
      statistic = c(2.50, 4.00),
      df1 = c(2, NA),
      df2 = c(30, 40)
    ),
    c(
      "F(2, 30) = 2.50",
      NA_character_
    )
  )

  expect_equal(
    format_f(
      statistic = c(2.50, 4.00),
      df1 = c(2, 1),
      df2 = c(30, 40),
      p = c(0.091, NA)
    ),
    c(
      "F(2, 30) = 2.50, p = .091",
      NA_character_
    )
  )
})


test_that("format_f handles empty vectors", {
  expect_equal(
    format_f(
      numeric(0),
      numeric(0),
      numeric(0)
    ),
    character(0)
  )
})


test_that("format_f rejects invalid inputs", {
  expect_error(
    format_f("2.50", df1 = 2, df2 = 30),
    "`statistic` must be numeric"
  )

  expect_error(
    format_f(2.50, df1 = "2", df2 = 30),
    "`df1` and `df2` must be numeric"
  )

  expect_error(
    format_f(
      c(2.50, 4.00),
      df1 = 2,
      df2 = c(30, 40)
    ),
    "must have the same length"
  )

  expect_error(
    format_f(-1, df1 = 1, df2 = 30),
    "cannot contain negative F values"
  )

  expect_error(
    format_f(2.50, df1 = 0, df2 = 30),
    "`df1` must contain positive finite values"
  )

  expect_error(
    format_f(2.50, df1 = 1, df2 = 0),
    "`df2` must contain positive finite values"
  )

  expect_error(
    format_f(Inf, df1 = 1, df2 = 30),
    "`statistic` must contain only finite values"
  )

  expect_error(
    format_f(
      2.50,
      df1 = 1,
      df2 = 30,
      p = "0.04"
    ),
    "`p` must be numeric"
  )
})
