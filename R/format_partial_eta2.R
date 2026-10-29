#' Format Partial Eta Squared
#'
#' Formats an already-computed partial eta-squared effect size as
#' publication-ready text. An optional confidence interval can be
#' supplied using numeric lower and upper limits.
#'
#' `format_partial_eta2()` does not calculate partial eta squared or
#' interpret the magnitude of the effect. It formats an already-computed
#' numeric result.
#'
#' @param eta2p Numeric vector of partial eta-squared effect sizes.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is
#'   supplied. Defaults to 0.95.
#' @param digits Number of decimal places used for partial eta squared.
#' @param ci_digits Number of decimal places used for confidence limits.
#'
#' @return A character vector containing formatted partial eta-squared values.
#'
#' @examples
#' format_partial_eta2(0.14)
#'
#' format_partial_eta2(
#'   0.14,
#'   lower = 0.08,
#'   upper = 0.21
#' )
#'
#' @export
format_partial_eta2 <- function(
    eta2p,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2
) {

  if (!is.numeric(eta2p)) {
    stop("`eta2p` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(eta2p) & !is.finite(eta2p))) {
    stop(
      "`eta2p` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(eta2p) & (eta2p < 0 | eta2p > 1))) {
    stop(
      "`eta2p` must contain values between 0 and 1.",
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

  if (length(eta2p) == 0L) {
    return(character(0))
  }

  eta_text <- formatC(
    eta2p,
    format = "f",
    digits = digits
  )

  # Prevent negative zero
  zero <- !is.na(eta2p) & round(eta2p, digits) == 0
  eta_text[zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )

  # Remove leading zero because partial eta squared is bounded by 0 and 1
  eta_text <- sub("^0\\.", ".", eta_text)

  out <- paste0(
    "\u03b7\u209a\u00b2 = ",
    eta_text
  )

  missing <- is.na(eta2p)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(eta2p) ||
      length(upper) != length(eta2p)
    ) {
      stop(
        "`eta2p`, `lower`, and `upper` must have the same length.",
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

  names(out) <- names(eta2p)

  out
}
