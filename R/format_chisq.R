#' Format Chi-Square Statistics
#'
#' Formats an already-computed chi-square statistic and its degrees of
#' freedom as publication-ready text. An optional p-value can be supplied
#' and is formatted using [format_p()].
#'
#' `format_chisq()` does not calculate a chi-square test or determine
#' statistical significance.
#'
#' @param statistic Numeric vector of chi-square statistics.
#'   Values must be nonnegative.
#' @param df Numeric vector of degrees of freedom. Values must be positive.
#' @param p Optional numeric vector of p-values.
#' @param digits Number of decimal places used for the chi-square statistic.
#' @param df_digits Maximum number of decimal places used for degrees of
#'   freedom. Whole-number degrees of freedom are displayed without decimals.
#' @param p_digits Number of decimal places used for p-values.
#' @param p_threshold Optional reporting threshold passed to [format_p()].
#' @param p_sig Logical indicating whether significance codes should be
#'   appended to p-values.
#'
#' @return A character vector containing formatted chi-square statistics.
#'
#' @examples
#' format_chisq(8.43, df = 2)
#'
#' format_chisq(
#'   8.43,
#'   df = 2,
#'   p = 0.015
#' )
#'
#' format_chisq(
#'   18.38,
#'   df = 2,
#'   p = 0.000102
#' )
#'
#' @export
format_chisq <- function(
    statistic,
    df,
    p = NULL,
    digits = 2,
    df_digits = 2,
    p_digits = 3,
    p_threshold = NULL,
    p_sig = FALSE
) {

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

  if (any(!is.na(df) & !is.finite(df))) {
    stop(
      "`df` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(statistic) & statistic < 0)) {
    stop(
      "`statistic` cannot contain negative values.",
      call. = FALSE
    )
  }

  if (any(!is.na(df) & df <= 0)) {
    stop(
      "`df` must contain positive values.",
      call. = FALSE
    )
  }

  .validate_test_digits(digits, "digits")
  .validate_test_digits(df_digits, "df_digits")
  .validate_test_digits(p_digits, "p_digits")

  if (length(statistic) == 0L) {
    return(character(0))
  }

  statistic_text <- .format_test_number(
    statistic,
    digits = digits
  )

  df_text <- .format_test_df(
    df,
    digits = df_digits
  )

  out <- paste0(
    "\u03c7\u00b2(",
    df_text,
    ") = ",
    statistic_text
  )

  missing <- is.na(statistic) | is.na(df)

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

    p_text <- format_p(
      pval = p,
      digits = p_digits,
      threshold = p_threshold,
      sig = p_sig,
      prefix = TRUE
    )

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

