#' Format confidence intervals for publication
#'
#' Formats lower and upper confidence interval limits using
#' publication-friendly conventions. By default, confidence intervals
#' are displayed using APA-style square brackets.
#'
#' @param lower Numeric vector containing lower confidence limits.
#' @param upper Numeric vector containing upper confidence limits.
#' @param level A single numeric value between 0 and 1 specifying the
#'   confidence level. Default is 0.95.
#' @param digits A single non-negative integer specifying the number
#'   of decimal places to display. Default is 2.
#' @param prefix Logical. If TRUE, the confidence level and `"CI"`
#'   are included. Default is TRUE.
#' @param leading_zero Logical. If TRUE, values between -1 and 1
#'   retain a leading zero. Default is TRUE.
#'
#' @return A character vector containing formatted confidence intervals.
#'
#' @details
#' Confidence intervals are formatted using square brackets with the
#' lower and upper limits separated by a comma.
#'
#' The function does not infer the type of statistic being reported.
#' For statistics that cannot exceed 1 in absolute value, such as
#' correlations, `leading_zero = FALSE` can be used.
#'
#' @examples
#' format_ci(1.08, 1.87)
#' format_ci(-0.42, 0.18)
#' format_ci(0.21, 0.48, leading_zero = FALSE)
#' format_ci(c(1.08, 2.15), c(1.87, 3.02))
#'
#' @export
format_ci <- function(
    lower,
    upper,
    level = 0.95,
    digits = 2,
    prefix = TRUE,
    leading_zero = TRUE
) {

  # ----------------------------------------------------------
  # Validate lower and upper limits
  # ----------------------------------------------------------

  if (!is.numeric(lower)) {
    stop(
      "`lower` must be numeric.",
      call. = FALSE
    )
  }

  if (!is.numeric(upper)) {
    stop(
      "`upper` must be numeric.",
      call. = FALSE
    )
  }

  if (length(lower) != length(upper)) {
    stop(
      "`lower` and `upper` must have the same length.",
      call. = FALSE
    )
  }

  if (any(is.infinite(lower)) || any(is.infinite(upper))) {
    stop(
      "Confidence interval limits must be finite.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Handle empty vectors
  # ----------------------------------------------------------

  if (length(lower) == 0L) {
    return(character(0))
  }


  # ----------------------------------------------------------
  # Validate confidence level
  # ----------------------------------------------------------

  if (
    !is.numeric(level) ||
    length(level) != 1L ||
    is.na(level) ||
    !is.finite(level) ||
    level <= 0 ||
    level >= 1
  ) {
    stop(
      "`level` must be a single numeric value greater than 0 and less than 1.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Validate digits
  # ----------------------------------------------------------

  if (
    !is.numeric(digits) ||
    length(digits) != 1L ||
    is.na(digits) ||
    !is.finite(digits) ||
    digits < 0 ||
    digits != floor(digits)
  ) {
    stop(
      "`digits` must be a single non-negative integer.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Validate logical arguments
  # ----------------------------------------------------------

  if (
    !is.logical(prefix) ||
    length(prefix) != 1L ||
    is.na(prefix)
  ) {
    stop(
      "`prefix` must be either TRUE or FALSE.",
      call. = FALSE
    )
  }

  if (
    !is.logical(leading_zero) ||
    length(leading_zero) != 1L ||
    is.na(leading_zero)
  ) {
    stop(
      "`leading_zero` must be either TRUE or FALSE.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Identify missing intervals
  #
  # If either bound is missing, the entire formatted CI is NA.
  # ----------------------------------------------------------

  missing <- is.na(lower) | is.na(upper)


  # ----------------------------------------------------------
  # Validate interval order
  # ----------------------------------------------------------

  if (any(lower > upper, na.rm = TRUE)) {
    stop(
      "`lower` cannot be greater than `upper`.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Format confidence limits
  # ----------------------------------------------------------

  lower_text <- formatC(
    lower,
    format = "f",
    digits = digits
  )

  upper_text <- formatC(
    upper,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Avoid negative zero after rounding
  #
  # Example:
  #   -0.001 with digits = 2 should display as 0.00,
  #   not -0.00.
  # ----------------------------------------------------------

  zero_lower <- !missing & round(lower, digits) == 0
  zero_upper <- !missing & round(upper, digits) == 0

  lower_text[zero_lower] <- formatC(
    0,
    format = "f",
    digits = digits
  )

  upper_text[zero_upper] <- formatC(
    0,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Optionally remove leading zeros
  #
  #  0.21 -> .21
  # -0.21 -> -.21
  # ----------------------------------------------------------

  if (!leading_zero) {

    lower_text <- sub(
      "^(-?)0\\.",
      "\\1.",
      lower_text
    )

    upper_text <- sub(
      "^(-?)0\\.",
      "\\1.",
      upper_text
    )
  }


  # ----------------------------------------------------------
  # Construct interval
  # ----------------------------------------------------------

  formatted <- paste0(
    "[",
    lower_text,
    ", ",
    upper_text,
    "]"
  )


  # ----------------------------------------------------------
  # Add confidence-level prefix
  # ----------------------------------------------------------

  if (prefix) {

    level_text <- format(
      level * 100,
      scientific = FALSE,
      trim = TRUE
    )

    formatted <- paste0(
      level_text,
      "% CI ",
      formatted
    )
  }


  # ----------------------------------------------------------
  # Preserve missing intervals
  # ----------------------------------------------------------

  formatted[missing] <- NA_character_


  # ----------------------------------------------------------
  # Preserve names from lower vector
  # ----------------------------------------------------------

  names(formatted) <- names(lower)


  # ----------------------------------------------------------
  # Return
  # ----------------------------------------------------------

  formatted
}
