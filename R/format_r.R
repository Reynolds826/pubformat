#' Format correlation coefficients for publication
#'
#' Formats correlation coefficients using publication-friendly
#' conventions. By default, values are displayed with two decimal
#' places and leading zeros are omitted, consistent with common
#' APA-style reporting for statistics that cannot exceed 1 in
#' absolute value.
#'
#' @param r Numeric vector containing correlation coefficients.
#'   Values must be between -1 and 1.
#'
#' @param digits A single non-negative integer specifying the number
#'   of decimal places to display. Default is 2.
#'
#' @param prefix Logical. If TRUE, `"r = "` is included before the
#'   formatted value. Default is TRUE.
#'
#' @param leading_zero Logical. If FALSE, leading zeros are omitted
#'   for values between -1 and 1. Default is FALSE.
#'
#' @return A character vector containing formatted correlation
#'   coefficients.
#'
#' @details
#' `format_r()` formats correlation coefficients only. It does not
#' determine statistical significance or format associated p-values.
#'
#' Missing values are returned as `NA`.
#'
#' @examples
#' format_r(0.42)
#' format_r(-0.31)
#' format_r(c(0.42, -0.31, 0))
#' format_r(0.42, leading_zero = TRUE)
#'
#' @export
format_r <- function(
    r,
    digits = 2,
    prefix = TRUE,
    leading_zero = FALSE
) {

  # ----------------------------------------------------------
  # Validate r
  # ----------------------------------------------------------

  if (!is.numeric(r)) {
    stop(
      "`r` must be numeric.",
      call. = FALSE
    )
  }

  if (any(is.infinite(r))) {
    stop(
      "`r` cannot contain infinite values.",
      call. = FALSE
    )
  }

  if (any(r < -1 | r > 1, na.rm = TRUE)) {
    stop(
      "All correlation coefficients must be between -1 and 1.",
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
  # Handle empty vectors
  # ----------------------------------------------------------

  if (length(r) == 0L) {
    return(character(0))
  }


  # ----------------------------------------------------------
  # Identify missing values
  # ----------------------------------------------------------

  missing <- is.na(r)


  # ----------------------------------------------------------
  # Format values
  # ----------------------------------------------------------

  values <- formatC(
    r,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Avoid negative zero after rounding
  #
  # Example:
  #   -.001 with digits = 2 -> .00
  #   rather than -.00
  # ----------------------------------------------------------

  rounded_zero <- !missing & round(r, digits) == 0

  values[rounded_zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Optionally remove leading zeros
  #
  #  0.42 -> .42
  # -0.42 -> -.42
  # ----------------------------------------------------------

  if (!leading_zero) {

    values <- sub(
      "^(-?)0\\.",
      "\\1.",
      values
    )
  }


  # ----------------------------------------------------------
  # Add r prefix
  # ----------------------------------------------------------

  if (prefix) {
    formatted <- paste0(
      "r = ",
      values
    )
  } else {
    formatted <- values
  }


  # ----------------------------------------------------------
  # Preserve missing values
  # ----------------------------------------------------------

  formatted[missing] <- NA_character_


  # ----------------------------------------------------------
  # Preserve names
  # ----------------------------------------------------------

  names(formatted) <- names(r)


  # ----------------------------------------------------------
  # Return
  # ----------------------------------------------------------

  formatted
}
