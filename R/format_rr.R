#' Format Risk Ratios
#'
#' Formats an already-computed risk ratio as publication-ready text.
#' An optional confidence interval can be supplied using numeric lower and
#' upper limits.
#'
#' `format_rr()` does not calculate a risk ratio or interpret the
#' magnitude or direction of the association.
#'
#' @param risk_ratio Numeric vector of risk ratios. Values must be
#'   nonnegative.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is supplied.
#'   Defaults to 0.95.
#' @param digits Number of decimal places used for risk ratios.
#' @param ci_digits Number of decimal places used for confidence limits.
#' @param style Output style for the statistical symbol. One of `"plain"`,
#'   `"markdown"`, `"html"`, or `"latex"`.
#'
#' @return A character vector containing formatted risk ratios.
#'
#' @examples
#' format_rr(1.52)
#' format_rr(0.74)
#' format_rr(0)
#'
#' format_rr(
#'   1.52,
#'   lower = 1.18,
#'   upper = 1.96
#' )
#'
#' format_rr(
#'   0.74,
#'   lower = 0.58,
#'   upper = 0.95
#' )
#'
#' @export
format_rr <- function(
    risk_ratio,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2,
    style = c("plain", "markdown", "html", "latex")
) {

  if (!is.numeric(risk_ratio)) {
    stop("`risk_ratio` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(risk_ratio) & !is.finite(risk_ratio))) {
    stop(
      "`risk_ratio` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(risk_ratio) & risk_ratio < 0)) {
    stop(
      "`risk_ratio` cannot contain negative values.",
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

  if (length(risk_ratio) == 0L) {
    return(character(0))
  }

  rr_text <- .format_test_number(
    risk_ratio,
    digits = digits
  )

  symbol <- .style_stat_symbol(
    "RR",
    style = style
  )

  out <- paste0(
    symbol,
    " = ",
    rr_text
  )

  missing <- is.na(risk_ratio)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(risk_ratio) ||
      length(upper) != length(risk_ratio)
    ) {
      stop(
        "`risk_ratio`, `lower`, and `upper` must have the same length.",
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

  names(out) <- names(risk_ratio)

  out
}
