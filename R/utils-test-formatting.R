.format_test_number <- function(x, digits) {
  out <- formatC(
    x,
    format = "f",
    digits = digits
  )

  # Prevent output such as "-0.00"
  zero <- !is.na(x) & round(x, digits) == 0
  out[zero] <- formatC(
    0,
    format = "f",
    digits = digits
  )

  out
}


.format_test_df <- function(x, digits) {
  out <- rep(NA_character_, length(x))
  ok <- !is.na(x)

  if (!any(ok)) {
    return(out)
  }

  whole <- ok &
    abs(x - round(x)) < sqrt(.Machine$double.eps)

  out[whole] <- as.character(
    round(x[whole])
  )

  nonwhole <- ok & !whole

  if (any(nonwhole)) {
    tmp <- formatC(
      x[nonwhole],
      format = "f",
      digits = digits
    )

    # Remove unnecessary trailing zeros
    tmp <- sub("\\.?0+$", "", tmp)

    out[nonwhole] <- tmp
  }

  out
}


.style_stat_symbol <- function(symbol, style) {
  switch(
    style,
    plain = symbol,
    markdown = paste0("*", symbol, "*"),
    html = paste0("<i>", symbol, "</i>"),
    latex = paste0(
      "\\textit{",
      symbol,
      "}"
    )
  )
}


.style_p_value <- function(x, style) {
  if (style == "plain") {
    return(x)
  }

  symbol <- .style_stat_symbol(
    "p",
    style
  )

  out <- x
  ok <- !is.na(x)

  out[ok] <- paste0(
    symbol,
    substring(x[ok], 2L)
  )

  out
}


.validate_test_digits <- function(x, name) {
  if (
    !is.numeric(x) ||
    length(x) != 1L ||
    is.na(x) ||
    !is.finite(x) ||
    x < 0 ||
    x != floor(x)
  ) {
    stop(
      "`",
      name,
      "` must be a single non-negative integer.",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

