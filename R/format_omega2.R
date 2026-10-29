#' Format Omega Squared
#'
#' Formats an already-computed omega-squared effect size as
#' publication-ready text. An optional confidence interval can be
#' supplied using numeric lower and upper limits.
#'
#' `format_omega2()` does not calculate omega squared or interpret the
#' magnitude of the effect. Negative estimates are preserved rather than
#' automatically truncated to zero.
#'
#' @param omega2 Numeric vector of omega-squared effect sizes.
#'   Negative estimates are permitted. Values greater than 1 are not.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is
#'   supplied. Defaults to 0.95.
#' @param digits Number of decimal places used for omega squared.
#' @param ci_digits Number of decimal places used for confidence limits.
#'
#' @return A character vector containing formatted omega-squared values.
#'
#' @examples
#' format_omega2(0.08)
#' format_omega2(-0.02)
#'
#' format_omega2(
#'   0.08,
#'   lower = 0.02,
#'   upper = 0.15
#' )
#'
#' @export
format_omega2 <- function(
    omega2,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2
) {

  if (!is.numeric(omega2)) {
    stop("`omega2` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(omega2) & !is.finite(omega2))) {
    stop(
      "`omega2` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(omega2) & omega2 > 1)) {
    stop(
      "`omega2` cannot contain values greater than 1.",
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

  if (length(omega2) == 0L) {
    return(character(0))
  }

  omega_text <- formatC(
    omega2,
    format = "f",
    digits = digits
  )

  # Prevent output such as "-0.00"
  zero <- !is.na(omega2) & round(omega2, digits) == 0
  omega_text[zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )

  # Remove leading zeros for values between -1 and 1
  omega_text <- sub("^0\\.", ".", omega_text)
  omega_text <- sub("^-0\\.", "-.", omega_text)

  out <- paste0(
    "\u03c9\u00b2 = ",
    omega_text
  )

  missing <- is.na(omega2)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(omega2) ||
      length(upper) != length(omega2)
    ) {
      stop(
        "`omega2`, `lower`, and `upper` must have the same length.",
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
      any(!is.na(lower) & lower > 1) ||
      any(!is.na(upper) & upper > 1)
    ) {
      stop(
        "`lower` and `upper` cannot contain values greater than 1.",
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

  names(out) <- names(omega2)

  out
}
