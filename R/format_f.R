#' Format an F Test Statistic
#'
#' Formats an already-computed F statistic and its numerator and
#' denominator degrees of freedom as publication-ready text. An
#' optional p-value can be supplied and is formatted using [format_p()].
#'
#' @param statistic Numeric vector of F statistics.
#' @param df1 Numeric vector of numerator degrees of freedom.
#' @param df2 Numeric vector of denominator degrees of freedom.
#' @param p Optional numeric vector of p-values.
#' @param digits Number of decimal places used for the F statistic.
#' @param df_digits Maximum number of decimal places used for
#'   non-integer degrees of freedom. Trailing zeros are removed.
#' @param p_digits Number of decimal places passed to [format_p()].
#' @param p_threshold Optional reporting threshold passed to [format_p()].
#' @param p_sig Logical. Whether significance codes should be appended
#'   to the p-value.
#' @param style Output style. One of `"plain"`, `"markdown"`, `"html"`,
#'   or `"latex"`.
#'
#' @return A character vector containing formatted F-test results.
#'
#' @examples
#' format_f(2.50, df1 = 2, df2 = 30)
#' format_f(4.4344, df1 = 1, df2 = 3262.9, p = 0.03530)
#' format_f(
#'   4.4344,
#'   df1 = 1,
#'   df2 = 3262.9,
#'   p = 0.03530,
#'   style = "markdown"
#' )
#'
#' @export
format_f <- function(
    statistic,
    df1,
    df2,
    p = NULL,
    digits = 2,
    df_digits = 2,
    p_digits = 3,
    p_threshold = NULL,
    p_sig = FALSE,
    style = c("plain", "markdown", "html", "latex")
) {

  style <- match.arg(style)

  if (!is.numeric(statistic)) {
    stop("`statistic` must be numeric.", call. = FALSE)
  }

  if (!is.numeric(df1) || !is.numeric(df2)) {
    stop("`df1` and `df2` must be numeric.", call. = FALSE)
  }

  if (
    length(statistic) != length(df1) ||
    length(statistic) != length(df2)
  ) {
    stop(
      "`statistic`, `df1`, and `df2` must have the same length.",
      call. = FALSE
    )
  }

  if (any(!is.na(statistic) & !is.finite(statistic))) {
    stop(
      "`statistic` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(statistic) & statistic < 0)) {
    stop(
      "`statistic` cannot contain negative F values.",
      call. = FALSE
    )
  }

  if (any(!is.na(df1) & (!is.finite(df1) | df1 <= 0))) {
    stop(
      "`df1` must contain positive finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(df2) & (!is.finite(df2) | df2 <= 0))) {
    stop(
      "`df2` must contain positive finite values.",
      call. = FALSE
    )
  }

  .validate_test_digits(digits, "digits")
  .validate_test_digits(df_digits, "df_digits")
  .validate_test_digits(p_digits, "p_digits")

  if (
    !is.logical(p_sig) ||
    length(p_sig) != 1L ||
    is.na(p_sig)
  ) {
    stop(
      "`p_sig` must be TRUE or FALSE.",
      call. = FALSE
    )
  }

  if (!is.null(p)) {

    if (!is.numeric(p)) {
      stop("`p` must be numeric.", call. = FALSE)
    }

    if (length(p) != length(statistic)) {
      stop(
        "`p` must have the same length as `statistic`.",
        call. = FALSE
      )
    }
  }

  if (length(statistic) == 0L) {
    return(character(0))
  }

  stat_text <- .format_test_number(statistic, digits)
  df1_text <- .format_test_df(df1, df_digits)
  df2_text <- .format_test_df(df2, df_digits)

  symbol <- .style_stat_symbol("F", style)

  out <- paste0(
    symbol,
    "(",
    df1_text,
    ", ",
    df2_text,
    ") = ",
    stat_text
  )

  missing <- is.na(statistic) | is.na(df1) | is.na(df2)

  if (!is.null(p)) {

    p_text <- format_p(
      p,
      digits = p_digits,
      threshold = p_threshold,
      sig = p_sig,
      prefix = TRUE
    )

    p_text <- .style_p_value(p_text, style)

    out <- paste0(
      out,
      ", ",
      p_text
    )

    missing <- missing | is.na(p)
  }

  out[missing] <- NA_character_

  names(out) <- names(statistic)

  out
}
