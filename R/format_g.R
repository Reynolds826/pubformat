#' Format Hedges' g
#'
#' Formats an already-computed Hedges' g effect size as
#' publication-ready text. An optional confidence interval can be
#' supplied using numeric lower and upper limits.
#'
#' `format_g()` does not calculate Hedges' g or interpret the magnitude
#' of the effect. It formats an already-computed numeric result.
#'
#' @param g Numeric vector of Hedges' g effect sizes.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is
#'   supplied. Defaults to 0.95.
#' @param digits Number of decimal places used for Hedges' g.
#' @param ci_digits Number of decimal places used for confidence limits.
#' @param style Output style. One of `"plain"`, `"markdown"`, `"html"`,
#'   or `"latex"`.
#'
#' @return A character vector containing formatted Hedges' g values.
#'
#' @examples
#' format_g(0.49)
#'
#' format_g(
#'   0.49,
#'   lower = 0.16,
#'   upper = 0.82
#' )
#'
#' format_g(
#'   0.49,
#'   lower = 0.16,
#'   upper = 0.82,
#'   style = "markdown"
#' )
#'
#' @export
format_g <- function(
    g,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2,
    style = c("plain", "markdown", "html", "latex")
) {

  style <- match.arg(style)

  if (!is.numeric(g)) {
    stop("`g` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(g) & !is.finite(g))) {
    stop(
      "`g` must contain only finite values.",
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

  if (length(g) == 0L) {
    return(character(0))
  }

  g_text <- .format_test_number(g, digits)

  symbol <- .style_stat_symbol("g", style)

  out <- paste0(
    symbol,
    " = ",
    g_text
  )

  missing <- is.na(g)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(g) ||
      length(upper) != length(g)
    ) {
      stop(
        "`g`, `lower`, and `upper` must have the same length.",
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

  names(out) <- names(g)

  out
}
