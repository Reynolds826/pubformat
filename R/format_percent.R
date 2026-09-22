#' Format percentages for publication
#'
#' Formats proportions or percentages using publication-friendly
#' conventions. By default, input values are interpreted as proportions
#' and converted to percentages.
#'
#' @param x Numeric vector containing proportions or percentages.
#'
#' @param digits A single non-negative integer specifying the number
#'   of decimal places to display. Default is 1.
#'
#' @param input Character string specifying how `x` should be interpreted.
#'   Must be either `"proportion"` or `"percent"`.
#'   Default is `"proportion"`.
#'
#' @param symbol Logical. If TRUE, the percent symbol is appended to
#'   each value. Default is TRUE.
#'
#' @return A character vector containing formatted percentages.
#'
#' @details
#' When `input = "proportion"`, values must fall between 0 and 1
#' and are multiplied by 100 before formatting.
#'
#' When `input = "percent"`, values are assumed to already be expressed
#' as percentages and are not rescaled.
#'
#' Missing values are returned as `NA`.
#'
#' @examples
#' format_percent(0.42)
#' format_percent(0.423, digits = 2)
#' format_percent(42, input = "percent")
#' format_percent(c(0.25, 0.50, 0.75))
#'
#' @export
format_percent <- function(
    x,
    digits = 1,
    input = "proportion",
    symbol = TRUE
) {

  # ----------------------------------------------------------
  # Validate x
  # ----------------------------------------------------------

  if (!is.numeric(x)) {
    stop(
      "`x` must be numeric.",
      call. = FALSE
    )
  }

  if (any(is.infinite(x))) {
    stop(
      "`x` cannot contain infinite values.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Validate input type
  # ----------------------------------------------------------

  if (
    !is.character(input) ||
    length(input) != 1L ||
    is.na(input)
  ) {
    stop(
      "`input` must be either \"proportion\" or \"percent\".",
      call. = FALSE
    )
  }

  input <- tolower(input)

  if (!input %in% c("proportion", "percent")) {
    stop(
      "`input` must be either \"proportion\" or \"percent\".",
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
  # Validate symbol
  # ----------------------------------------------------------

  if (
    !is.logical(symbol) ||
    length(symbol) != 1L ||
    is.na(symbol)
  ) {
    stop(
      "`symbol` must be either TRUE or FALSE.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Handle empty vectors
  # ----------------------------------------------------------

  if (length(x) == 0L) {
    return(character(0))
  }


  # ----------------------------------------------------------
  # Identify missing values
  # ----------------------------------------------------------

  missing <- is.na(x)


  # ----------------------------------------------------------
  # Validate proportions
  #
  # Proportions, by definition, must fall between 0 and 1.
  #
  # Percent input is not restricted to 0-100 because percentages
  # such as percent change can legitimately be negative or exceed
  # 100%.
  # ----------------------------------------------------------

  if (
    input == "proportion" &&
    any(x < 0 | x > 1, na.rm = TRUE)
  ) {
    stop(
      "Proportions must be between 0 and 1.",
      call. = FALSE
    )
  }


  # ----------------------------------------------------------
  # Convert proportions to percentages
  # ----------------------------------------------------------

  values <- if (input == "proportion") {
    x * 100
  } else {
    x
  }


  # ----------------------------------------------------------
  # Format values with fixed decimal places
  # ----------------------------------------------------------

  formatted <- formatC(
    values,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Avoid negative zero after rounding
  #
  # Example:
  #   -0.01 with digits = 1 -> 0.0%
  #   rather than -0.0%
  # ----------------------------------------------------------

  rounded_zero <- !missing & round(values, digits) == 0

  formatted[rounded_zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )


  # ----------------------------------------------------------
  # Add percent symbol
  # ----------------------------------------------------------

  if (symbol) {
    formatted <- paste0(
      formatted,
      "%"
    )
  }


  # ----------------------------------------------------------
  # Preserve missing values
  # ----------------------------------------------------------

  formatted[missing] <- NA_character_


  # ----------------------------------------------------------
  # Preserve names
  # ----------------------------------------------------------

  names(formatted) <- names(x)


  # ----------------------------------------------------------
  # Return
  # ----------------------------------------------------------

  formatted
}
