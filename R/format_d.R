#' Format Cohen's d
#'
#' Formats an already-computed Cohen's d effect size as
#' publication-ready text. An optional confidence interval can be
#' supplied using numeric lower and upper limits.
#'
#' `format_d()` does not calculate Cohen's d or interpret the magnitude
#' of the effect. It formats an already-computed numeric result.
#'
#' @param d Numeric vector of Cohen's d effect sizes.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is
#'   supplied. Defaults to 0.95.
#' @param digits Number of decimal places used for Cohen's d.
#' @param ci_digits Number of decimal places used for confidence limits.
#' @param style Output style. One of `"plain"`, `"markdown"`, `"html"`,
#'   or `"latex"`.
#'
#' @return A character vector containing formatted Cohen's d values.
#'
#' @examples
#' format_d(0.52)
#'
#' format_d(
#'   0.52,
#'   lower = 0.18,
#'   upper = 0.86
#' )
#'
#' format_d(
#'   0.52,
#'   lower = 0.18,
#'   upper = 0.86,
#'   style = "markdown"
#' )
#'
#' @export
format_d <- function(
    d,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2,
    style = c("plain", "markdown", "html", "latex")
) {

  style <- match.arg(style)

  if (!is.numeric(d)) {
    stop("`d` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(d) & !is.finite(d))) {
    stop(
      "`d` must contain only finite values.",
      call. = FALSE
    )
  }

  .validate_test_digits(digits, "digits")
  .validate_test_digits(ci_digits, "ci_digits")

  has_lower <- !is.null(lower)
  has_upper <- !is.null(upper)

  if (has_lower != has_upper) {
    stop(
      "`lower` and `upper` must either both be supplied or both be NULL.",
      call. = FALSE
    )
  }

  if (length(d) == 0L) {
    return(character(0))
  }

  d_text <- .format_test_number(d, digits)

  symbol <- .style_stat_symbol("d", style)

  out <- paste0(
    symbol,
    " = ",
    d_text
  )

  missing <- is.na(d)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(d) ||
      length(upper) != length(d)
    ) {
      stop(
        "`d`, `lower`, and `upper` must have the same length.",
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

  names(out) <- names(d)

  out
}
