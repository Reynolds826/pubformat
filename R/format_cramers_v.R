#' Format Cramer's V
#'
#' Formats an already-computed Cramer's V effect size as
#' publication-ready text. An optional confidence interval can be supplied
#' using numeric lower and upper limits.
#'
#' `format_cramers_v()` does not calculate Cramer's V or interpret the
#' magnitude of the association.
#'
#' @param v Numeric vector of Cramer's V effect sizes. Values must lie
#'   between 0 and 1.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is supplied.
#'   Defaults to 0.95.
#' @param digits Number of decimal places used for Cramer's V.
#' @param ci_digits Number of decimal places used for confidence limits.
#' @param style Output style for the statistical symbol. One of `"plain"`,
#'   `"markdown"`, `"html"`, or `"latex"`.
#'
#' @return A character vector containing formatted Cramer's V values.
#'
#' @examples
#' format_cramers_v(0.32)
#'
#' format_cramers_v(
#'   0.32,
#'   lower = 0.18,
#'   upper = 0.45
#' )
#'
#' format_cramers_v(
#'   0.32,
#'   style = "markdown"
#' )
#'
#' @export
format_cramers_v <- function(
    v,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2,
    style = c("plain", "markdown", "html", "latex")
) {

  if (!is.numeric(v)) {
    stop("`v` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(v) & !is.finite(v))) {
    stop(
      "`v` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(v) & (v < 0 | v > 1))) {
    stop(
      "`v` must contain values between 0 and 1.",
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

  if (length(v) == 0L) {
    return(character(0))
  }

  v_text <- formatC(
    v,
    format = "f",
    digits = digits
  )

  zero <- !is.na(v) & round(v, digits) == 0

  v_text[zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )

  v_text <- sub("^0\\.", ".", v_text)

  symbol <- .style_stat_symbol(
    "V",
    style = style
  )

  out <- paste0(
    symbol,
    " = ",
    v_text
  )

  missing <- is.na(v)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(v) ||
      length(upper) != length(v)
    ) {
      stop(
        "`v`, `lower`, and `upper` must have the same length.",
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
      any(!is.na(lower) & (lower < 0 | lower > 1)) ||
      any(!is.na(upper) & (upper < 0 | upper > 1))
    ) {
      stop(
        "`lower` and `upper` must contain values between 0 and 1.",
        call. = FALSE
      )
    }

    ci_text <- format_ci(
      lower = lower,
      upper = upper,
      level = level,
      digits = ci_digits,
      prefix = TRUE,
      leading_zero = FALSE
    )

    out <- paste0(
      out,
      ", ",
      ci_text
    )

    missing <- missing | is.na(lower) | is.na(upper)
  }

  out[missing] <- NA_character_

  names(out) <- names(v)

  out
}
