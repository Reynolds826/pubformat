#' Format correlation coefficients for publication
#'
#' Formats Pearson, Spearman, and Kendall correlation coefficients
#' using publication-friendly conventions. The appropriate statistical
#' symbol is selected automatically from the requested correlation
#' method.
#'
#' @param r Numeric vector containing correlation coefficients.
#'   Values must be between -1 and 1.
#'
#' @param method Character string specifying the correlation method.
#'   Must be one of `"pearson"`, `"spearman"`, or `"kendall"`.
#'   Default is `"pearson"`.
#'
#' @param digits A single non-negative integer specifying the number
#'   of decimal places to display. Default is 2.
#'
#' @param prefix Logical. If TRUE, the method-appropriate statistical
#'   symbol and equals sign are included. Default is TRUE.
#'
#' @param leading_zero Logical. If FALSE, leading zeros are omitted
#'   for values between -1 and 1. Default is FALSE.
#'
#' @return A character vector containing formatted correlation
#'   coefficients.
#'
#' @details
#' `format_cor()` supports three correlation methods:
#'
#' * Pearson: `r`
#' * Spearman: rho
#' * Kendall: tau
#'
#' The function formats correlation coefficients only. It does not
#' calculate correlations, determine statistical significance, or
#' format associated p-values.
#'
#' Missing values are returned as `NA`.
#'
#' @examples
#' format_cor(0.42)
#' format_cor(0.42, method = "pearson")
#' format_cor(0.42, method = "spearman")
#' format_cor(0.42, method = "kendall")
#' format_cor(c(0.42, -0.31, 0), method = "spearman")
#'
#' @export
format_cor <- function(
    r,
    method = "pearson",
    digits = 2,
    prefix = TRUE,
    leading_zero = FALSE
) {

  # ----------------------------------------------------------
  # Validate correlation values
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
  # Validate correlation method
  # ----------------------------------------------------------

  if (
    !is.character(method) ||
    length(method) != 1L ||
    is.na(method)
  ) {
    stop(
      "`method` must be one of \"pearson\", \"spearman\", or \"kendall\".",
      call. = FALSE
    )
  }

  method <- tolower(method)

  valid_methods <- c(
    "pearson",
    "spearman",
    "kendall"
  )

  if (!method %in% valid_methods) {
    stop(
      "`method` must be one of \"pearson\", \"spearman\", or \"kendall\".",
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
  # Select statistical symbol
  #
  # Unicode escapes are used rather than placing Greek
  # characters directly in the source code.
  #
  # Pearson  -> r
  # Spearman -> rho
  # Kendall  -> tau
  # ----------------------------------------------------------

  symbol <- switch(
    method,
    pearson = "r",
    spearman = "\u03c1",
    kendall = "\u03c4"
  )


  # ----------------------------------------------------------
  # Format coefficients
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
  #
  #   -0.001 with digits = 2
  #
  # becomes:
  #
  #   .00
  #
  # rather than:
  #
  #   -.00
  # ----------------------------------------------------------

  rounded_zero <- !missing & round(r, digits) == 0

  values[rounded_zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Remove leading zeros by default
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
  # Add method-specific prefix
  # ----------------------------------------------------------

  if (prefix) {

    formatted <- paste0(
      symbol,
      " = ",
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
