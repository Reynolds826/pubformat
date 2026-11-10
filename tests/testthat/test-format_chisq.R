test_that("format_chisq formats basic chi-square statistics", {
  expect_equal(
    format_chisq(8.43, df = 2),
    "χ²(2) = 8.43"
  )

  expect_equal(
    format_chisq(0, df = 1),
    "χ²(1) = 0.00"
  )
})


test_that("format_chisq formats p-values", {
  expect_equal(
    format_chisq(
      8.43,
      df = 2,
      p = 0.015
    ),
    "χ²(2) = 8.43, p = .015"
  )

  expect_equal(
    format_chisq(
      18.38,
      df = 2,
      p = 0.000102
    ),
    "χ²(2) = 18.38, p < .001"
  )
})


test_that("format_chisq preserves strict p-value boundary", {
  expect_equal(
    format_chisq(
      10.83,
      df = 2,
      p = 0.001
    ),
    "χ²(2) = 10.83, p = .001"
  )

  expect_equal(
    format_chisq(
      10.84,
      df = 2,
      p = 0.0009
    ),
    "χ²(2) = 10.84, p < .001"
  )
})


test_that("format_chisq supports fractional degrees of freedom", {
  expect_equal(
    format_chisq(
      8.43,
      df = 2.5
    ),
    "χ²(2.5) = 8.43"
  )
})


test_that("format_chisq respects requested precision", {
  expect_equal(
    format_chisq(
      8.436,
      df = 2,
      digits = 3
    ),
    "χ²(2) = 8.436"
  )

  expect_equal(
    format_chisq(
      8.43,
      df = 2.567,
      df_digits = 2
    ),
    "χ²(2.57) = 8.43"
  )
})


test_that("format_chisq is vectorized", {
  expect_equal(
    format_chisq(
      statistic = c(8.43, 18.38, 3.21),
      df = c(2, 2, 1),
      p = c(0.015, 0.000102, 0.073)
    ),
    c(
      "χ²(2) = 8.43, p = .015",
      "χ²(2) = 18.38, p < .001",
      "χ²(1) = 3.21, p = .073"
    )
  )
})


test_that("format_chisq preserves names", {
  x <- c(first = 8.43, second = 3.21)

  out <- format_chisq(
    statistic = x,
    df = c(2, 1)
  )

  expect_equal(
    names(out),
    c("first", "second")
  )
})


test_that("format_chisq preserves missing results", {
  expect_equal(
    format_chisq(
      statistic = c(8.43, NA, 3.21),
      df = c(2, 2, 1),
      p = c(0.015, 0.041, NA)
    ),
    c(
      "χ²(2) = 8.43, p = .015",
      NA_character_,
      NA_character_
    )
  )
})


test_that("format_chisq handles empty vectors", {
  expect_equal(
    format_chisq(
      statistic = numeric(0),
      df = numeric(0)
    ),
    character(0)
  )
})


test_that("format_chisq rejects invalid statistics", {
  expect_error(
    format_chisq("8.43", df = 2),
    "`statistic` must be numeric"
  )

  expect_error(
    format_chisq(-1, df = 2),
    "`statistic` cannot contain negative values"
  )

  expect_error(
    format_chisq(Inf, df = 2),
    "`statistic` must contain only finite values"
  )
})


test_that("format_chisq rejects invalid degrees of freedom", {
  expect_error(
    format_chisq(8.43, df = "2"),
    "`df` must be numeric"
  )

  expect_error(
    format_chisq(8.43, df = 0),
    "`df` must contain positive values"
  )

  expect_error(
    format_chisq(8.43, df = -1),
    "`df` must contain positive values"
  )

  expect_error(
    format_chisq(8.43, df = Inf),
    "`df` must contain only finite values"
  )
})


test_that("format_chisq rejects mismatched lengths", {
  expect_error(
    format_chisq(
      statistic = c(8.43, 3.21),
      df = 2
    ),
    "`statistic` and `df` must have the same length"
  )

  expect_error(
    format_chisq(
      statistic = c(8.43, 3.21),
      df = c(2, 1),
      p = 0.015
    ),
    "`p` must have the same length as `statistic`"
  )
})


test_that("format_chisq rejects nonnumeric p-values", {
  expect_error(
    format_chisq(
      8.43,
      df = 2,
      p = "0.015"
    ),
    "`p` must be numeric"
  )
})
