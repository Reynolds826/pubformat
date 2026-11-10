#' Format Phi Coefficients
#'
#' Formats an already-computed phi coefficient as publication-ready text.
#' An optional confidence interval can be supplied using numeric lower and
#' upper limits.
#'
#' `format_phi()` does not calculate a phi coefficient or interpret the
#' magnitude of the association.
#'
#' @param phi Numeric vector of phi coefficients. Values must lie between
#'   -1 and 1.
#' @param lower Optional numeric vector of lower confidence limits.
#' @param upper Optional numeric vector of upper confidence limits.
#' @param level Confidence level used when a confidence interval is supplied.
#'   Defaults to 0.95.
#' @param digits Number of decimal places used for phi coefficients.
#' @param ci_digits Number of decimal places used for confidence limits.
#'
#' @return A character vector containing formatted phi coefficients.
#'
#' @examples
#' format_phi(0.32)
#' format_phi(-0.24)
#'
#' format_phi(
#'   0.32,
#'   lower = 0.12,
#'   upper = 0.49
#' )
#'
#' @export
format_phi <- function(
    phi,
    lower = NULL,
    upper = NULL,
    level = 0.95,
    digits = 2,
    ci_digits = 2
) {

  if (!is.numeric(phi)) {
    stop("`phi` must be numeric.", call. = FALSE)
  }

  if (any(!is.na(phi) & !is.finite(phi))) {
    stop(
      "`phi` must contain only finite values.",
      call. = FALSE
    )
  }

  if (any(!is.na(phi) & (phi < -1 | phi > 1))) {
    stop(
      "`phi` must contain values between -1 and 1.",
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

  if (length(phi) == 0L) {
    return(character(0))
  }

  phi_text <- formatC(
    phi,
    format = "f",
    digits = digits
  )

  zero <- !is.na(phi) & round(phi, digits) == 0

  phi_text[zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )

  phi_text <- sub("^0\\.", ".", phi_text)
  phi_text <- sub("^-0\\.", "-.", phi_text)

  out <- paste0(
    "\u03c6 = ",
    phi_text
  )

  missing <- is.na(phi)

  if (has_lower && has_upper) {

    if (!is.numeric(lower) || !is.numeric(upper)) {
      stop(
        "`lower` and `upper` must be numeric.",
        call. = FALSE
      )
    }

    if (
      length(lower) != length(phi) ||
      length(upper) != length(phi)
    ) {
      stop(
        "`phi`, `lower`, and `upper` must have the same length.",
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
      any(!is.na(lower) & (lower < -1 | lower > 1)) ||
      any(!is.na(upper) & (upper < -1 | upper > 1))
    ) {
      stop(
        "`lower` and `upper` must contain values between -1 and 1.",
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

  names(out) <- names(phi)

  out
}
