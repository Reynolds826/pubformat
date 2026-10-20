#' Format a t Test Statistic
#'
#' Formats an already-computed t statistic and its degrees of freedom
#' as publication-ready text. An optional p-value can be supplied and
#' is formatted using [format_p()].
#'
#' @param statistic Numeric vector of t statistics.
#' @param df Numeric vector of degrees of freedom.
#' @param p Optional numeric vector of p-values.
#' @param digits Number of decimal places used for the t statistic.
#' @param df_digits Maximum number of decimal places used for
#'   non-integer degrees of freedom. Trailing zeros are removed.
#' @param p_digits Number of decimal places passed to [format_p()].
#' @param p_threshold Optional reporting threshold passed to [format_p()].
#' @param p_sig Logical. Whether significance codes should be appended
#'   to the p-value.
#' @param style Output style. One of `"plain"`, `"markdown"`, `"html"`,
#'   or `"latex"`.
#'
#' @return A character vector containing formatted t-test results.
#'
#' @examples
#' format_t(0.86, df = 20)
#' format_t(0.86, df = 20, p = 0.041)
#' format_t(0.86, df = 20, p = 0.041, style = "markdown")
#'
#' @export
format_t <- function(
    statistic,
    df,
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

  if (!is.numeric(df)) {
    stop("`df` must be numeric.", call. = FALSE)
  }

  if (length(statistic) != length(df)) {
    stop(
      "`statistic` and `df` must have the same length.",
      call. = FALSE
    )
  }

  if (any(!is.na(statistic) & !is.finite(statistic))) {
    stop(
      "`statistic` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(df) & (!is.finite(df) | df <= 0))) {
    stop(
      "`df` must contain positive finite values.",
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
  df_text <- .format_test_df(df, df_digits)

  symbol <- .style_stat_symbol("t", style)

  out <- paste0(
    symbol,
    "(",
    df_text,
    ") = ",
    stat_text
  )

  missing <- is.na(statistic) | is.na(df)

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
