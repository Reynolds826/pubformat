#' Format Odds Ratios
#'
#' Formats an already-computed odds ratio as publication-ready text.
#' An optional confidence interval can be supplied using numeric lower and
#' upper limits.
#'
#' `format_or()` does not calculate an odds ratio or interpret the
#' magnitude or direction of the association.
#'
#' @param odds_ratio Numeric vector of odds ratios. Values must be
#'   nonnegative.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is supplied.
#'   Defaults to 0.95.
#' @param digits Number of decimal places used for odds ratios.
#' @param ci_digits Number of decimal places used for confidence limits.
#' @param style Output style for the statistical symbol. One of `"plain"`,
#'   `"markdown"`, `"html"`, or `"latex"`.
#'
#' @return A character vector containing formatted odds ratios.
#'
#' @examples
#' format_or(1.84)
#' format_or(0.62)
#' format_or(0)
#'
#' format_or(
#'   1.84,
#'   lower = 1.20,
#'   upper = 2.82
#' )
#'
#' format_or(
#'   0.62,
#'   lower = 0.41,
#'   upper = 0.94
#' )
#'
#' @export
format_or <- function(
    odds_ratio,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2,
    style = c("plain", "markdown", "html", "latex")
) {

  if (!is.numeric(odds_ratio)) {
    stop("`odds_ratio` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(odds_ratio) & !is.finite(odds_ratio))) {
    stop(
      "`odds_ratio` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(odds_ratio) & odds_ratio < 0)) {
    stop(
      "`odds_ratio` cannot contain negative values.",
      call. = FALSE
    )
  }

  .validate_test_digits(digits, "digits")
  .validate_test_digits(ci_digits, "ci_digits")

  style <- match.arg(style)

  has_lower <- !is.null(lower)
  has_upper <- !is.null(upper)

  if (has_lower != has_upper) {
    stop(
      "`lower` and `upper` must either both be supplied or both be NULL.",
      call. = FALSE
    )
  }

  if (length(odds_ratio) == 0L) {
    return(character(0))
  }

  or_text <- .format_test_number(
    odds_ratio,
    digits = digits
  )

  symbol <- .style_stat_symbol(
    "OR",
    style = style
  )

  out <- paste0(
    symbol,
    " = ",
    or_text
  )

  missing <- is.na(odds_ratio)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(odds_ratio) ||
      length(upper) != length(odds_ratio)
    ) {
      stop(
        "`odds_ratio`, `lower`, and `upper` must have the same length.",
        call. = FALSE
      )
    }

    if (
      any(!is.na(lower) & !is.finite(lower)) ||
      any(!is.na(upper) & !is.finite(upper))
    ) {
      stop(
        "`lower` and `upper` must contain only finite values.",
        call. = FALSE
      )
    }

    if (
      any(!is.na(lower) & lower < 0) ||
      any(!is.na(upper) & upper < 0)
    ) {
      stop(
        "`lower` and `upper` cannot contain negative values.",
        call. = FALSE
      )
    }

    ci_text <- format_ci(
      lower = lower,
      upper = upper,
      level = level,
      digits = ci_digits,
      prefix = TRUE,
      leading_zero = TRUE
    )

    out <- paste0(
      out,
      ", ",
      ci_text
    )

    missing <- missing | is.na(lower) | is.na(upper)
  }

  out[missing] <- NA_character_

  names(out) <- names(odds_ratio)

  out
}
