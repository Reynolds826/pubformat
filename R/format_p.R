# ============================================================
# pubformat: format_p()
# ============================================================
#
# Format p-values for publication-ready output.
#
# Design principles:
#   - Preserve the underlying p-value for statistical decisions.
#   - Formatting should never determine statistical significance.
#   - Never report a positive p-value as p = .000.
#   - Exact threshold values remain exact:
#         p = .001
#     while values below the threshold are reported:
#         p < .001
#   - Significance codes are optional and independent of the
#     reporting threshold.
#
# ============================================================


#' Format p-values for publication
#'
#' Formats numeric p-values using publication-friendly conventions.
#' Values are displayed with a fixed number of decimal places,
#' leading zeros are omitted, and very small p-values are reported
#' using less-than notation.
#'
#' @param pval Numeric vector containing p-values.
#'
#' @param digits A single non-negative integer specifying the number
#'   of decimal places to display. Default is 3.
#'
#' @param threshold Optional numeric reporting threshold. Values
#'   strictly below this threshold are displayed using less-than
#'   notation. If NULL (the default), the threshold is automatically
#'   set to 10^-digits. For example, digits = 3 produces a threshold
#'   of .001.
#'
#' @param sig Logical. If TRUE, conventional significance codes are
#'   appended. Default is FALSE.
#'
#' @param prefix Logical. If TRUE, "p" is included before the
#'   formatted value. Default is TRUE.
#'
#' @return A character vector containing formatted p-values.
#'
#' @details
#' The reporting threshold controls only how a p-value is displayed.
#' It does not represent an alpha level or statistical decision rule.
#'
#' With digits = 3:
#'
#'   p = .001 is reported as "p = .001"
#'   p = .0009 is reported as "p < .001"
#'
#' Significance codes use the conventional strict thresholds:
#'
#'   ***  p < .001
#'   **   p < .01
#'   *    p < .05
#'   .    p < .10
#'   ns   otherwise
#'
#' @examples
#' format_p(0.048)
#' format_p(0.0002)
#' format_p(0.001)
#' format_p(0.048, sig = TRUE)
#' format_p(c(0.048, 0.006, 0.0002, 0.213))
#'
#' @export
format_p <- function(
    pval,
    digits = 3,
    threshold = NULL,
    sig = FALSE,
    prefix = TRUE
) {

  # ----------------------------------------------------------
  # Validate p-values
  # ----------------------------------------------------------

  if (!is.numeric(pval)) {
    stop(
      "`pval` must be numeric.",
      call. = FALSE
    )
  }

  if (any(is.infinite(pval))) {
    stop(
      "`pval` cannot contain infinite values.",
      call. = FALSE
    )
  }

  if (any(pval < 0 | pval > 1, na.rm = TRUE)) {
    stop(
      "All p-values must be between 0 and 1.",
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
  # Determine minimum displayable value
  #
  # digits = 3 -> .001
  # digits = 2 -> .01
  # digits = 4 -> .0001
  # ----------------------------------------------------------

  reporting_floor <- 10^(-digits)


  # ----------------------------------------------------------
  # Determine / validate reporting threshold
  # ----------------------------------------------------------

  if (is.null(threshold)) {

    threshold <- reporting_floor

  } else {

    if (
      !is.numeric(threshold) ||
      length(threshold) != 1L ||
      is.na(threshold) ||
      !is.finite(threshold) ||
      threshold <= 0 ||
      threshold > 1
    ) {
      stop(
        "`threshold` must be a single numeric value greater than 0 and no greater than 1.",
        call. = FALSE
      )
    }

    # Prevent combinations capable of producing p = .000
    if (threshold < reporting_floor) {
      stop(
        paste0(
          "`threshold` cannot be smaller than ",
          format(reporting_floor, scientific = FALSE, trim = TRUE),
          " when `digits = ",
          digits,
          "`. Increase `digits` or use a larger threshold."
        ),
        call. = FALSE
      )
    }
  }


  # ----------------------------------------------------------
  # Validate logical arguments
  # ----------------------------------------------------------

  if (
    !is.logical(sig) ||
    length(sig) != 1L ||
    is.na(sig)
  ) {
    stop(
      "`sig` must be either TRUE or FALSE.",
      call. = FALSE
    )
  }

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
  # ----------------------------------------------------------
  # Handle empty vectors
  # ----------------------------------------------------------

  if (length(pval) == 0L) {
    return(character(0))
  }

  # ----------------------------------------------------------
  # Identify missing values
  # ----------------------------------------------------------

  missing <- is.na(pval)


  # ----------------------------------------------------------
  # Format ordinary p-values
  #
  # formatC() preserves trailing zeros:
  #
  #   0.2 -> ".200"
  #
  # rather than:
  #
  #   0.2 -> ".2"
  # ----------------------------------------------------------

  values <- formatC(
    pval,
    format = "f",
    digits = digits
  )

  # Publication style: omit leading zero
  values <- sub(
    "^0\\.",
    ".",
    values
  )


  # ----------------------------------------------------------
  # Format reporting threshold
  # ----------------------------------------------------------

  threshold_text <- format(
    threshold,
    scientific = FALSE,
    trim = TRUE
  )

  threshold_text <- sub(
    "^0\\.",
    ".",
    threshold_text
  )


  # ----------------------------------------------------------
  # Apply reporting threshold
  #
  # IMPORTANT:
  #
  # p < threshold
  #
  # not
  #
  # p <= threshold
  #
  # Therefore:
  #
  #   .001  -> p = .001
  #   .0009 -> p < .001
  # ----------------------------------------------------------

  formatted <- ifelse(
    pval < threshold,
    paste0("< ", threshold_text),
    paste0("= ", values)
  )


  # ----------------------------------------------------------
  # Add p prefix
  # ----------------------------------------------------------

  if (prefix) {
    formatted <- paste(
      "p",
      formatted
    )
  }


  # ----------------------------------------------------------
  # Add optional significance codes
  #
  # These thresholds are deliberately independent of the
  # reporting threshold.
  # ----------------------------------------------------------

  if (sig) {

    sig_code <- ifelse(
      pval < 0.001,
      "***",
      ifelse(
        pval < 0.01,
        "**",
        ifelse(
          pval < 0.05,
          "*",
          ifelse(
            pval < 0.10,
            ".",
            "ns"
          )
        )
      )
    )

    formatted <- paste(
      formatted,
      sig_code
    )
  }


  # ----------------------------------------------------------
  # Preserve missing values
  # ----------------------------------------------------------

  formatted[missing] <- NA_character_


  # ----------------------------------------------------------
  # Preserve names from named vectors
  # ----------------------------------------------------------

  names(formatted) <- names(pval)


  # ----------------------------------------------------------
  # Return
  # ----------------------------------------------------------

  formatted
}


# ============================================================
# EDGE-CASE EXAMPLES
# ============================================================


# ---- Critical .001 boundary ----

# format_p(.001)
# "p = .001"

# format_p(.000999)
# "p < .001"

# format_p(.0001)
# "p < .001"


# ---- Exact conventional significance boundaries ----

# format_p(.05, sig = TRUE)
# "p = .050 ."

# format_p(.0499, sig = TRUE)
# "p = .050 *"

# format_p(.01, sig = TRUE)
# "p = .010 *"

# format_p(.0099, sig = TRUE)
# "p = .010 **"

# format_p(.001, sig = TRUE)
# "p = .001 **"

# format_p(.0009, sig = TRUE)
# "p < .001 ***"


# ---- Zero ----

# format_p(0)
# "p < .001"


# ---- One ----

# format_p(1)
# "p = 1.000"


# ---- Missing values ----

# format_p(NA_real_)
# NA

# format_p(NaN)
# NA


# ---- Vectorized input ----

# format_p(
#   c(.05, .0499, .01, .0099, .001, .0009)
# )
#
# "p = .050"
# "p = .050"
# "p = .010"
# "p = .010"
# "p = .001"
# "p < .001"


# ---- Different precision ----

# format_p(.005, digits = 2)
# "p < .01"

# format_p(.01, digits = 2)
# "p = .01"

# format_p(.0005, digits = 4)
# "p = .0005"

# format_p(.00005, digits = 4)
# "p < .0001"


# ---- Explicit reporting threshold ----

# format_p(.004, threshold = .005)
# "p < .005"

# format_p(.005, threshold = .005)
# "p = .005"


# ---- Invalid threshold / precision combination ----

# format_p(.0005, digits = 3, threshold = .0001)
#
# Error:
# `threshold` cannot be smaller than 0.001 when `digits = 3`.
# Increase `digits` or use a larger threshold.


# ---- Invalid p-values ----

# format_p(-.01)
# Error: All p-values must be between 0 and 1.

# format_p(1.01)
# Error: All p-values must be between 0 and 1.

# format_p(Inf)
# Error: `pval` cannot contain infinite values.
