# pubformat 0.2.0

## New features

### Test-statistic formatting

* Added `format_t()` for publication-ready formatting of t test statistics and degrees of freedom.

* Added `format_f()` for publication-ready formatting of F test statistics with numerator and denominator degrees of freedom.

* `format_t()` and `format_f()` can optionally include p-values, which are formatted using the existing `format_p()` behavior.

* Added support for fractional degrees of freedom, including values commonly produced by approximation methods such as Satterthwaite degrees of freedom.

* Added optional plain, Markdown, HTML, and LaTeX output for t, F, and p statistical symbols.

### Effect-size formatting

* Added `format_d()` for Cohen's d.

* Added `format_g()` for Hedges' g.

* Added `format_eta2()` for eta squared using direct Unicode notation (`η²`).

* Added `format_partial_eta2()` for partial eta squared using direct Unicode notation (`ηₚ²`).

* Added `format_omega2()` for omega squared using direct Unicode notation (`ω²`).

* Added optional confidence-interval formatting to all five effect-size formatters.

* Cohen's d and Hedges' g retain leading zeros and support plain, Markdown, HTML, and LaTeX styling of their statistical symbols.

* Eta squared and partial eta squared use bounded-statistic formatting and omit leading zeros.

* Omega-squared formatting preserves negative estimates and negative confidence-limit estimates rather than automatically truncating them to zero.

* Effect-size functions are vectorized, preserve names and missing values, and validate statistic-specific input ranges.

## Documentation

* Updated the README to document test-statistic formatting, effect-size formatting, confidence-interval pairing, statistical-symbol output, and development-version installation.

* Expanded the workflow vignette to include t and F statistics, Cohen's d, Hedges' g, eta squared, partial eta squared, omega squared, vectorized workflows, and confidence intervals.

* Clarified that `pubformat` formats already-computed statistical results rather than calculating or interpreting them.

* Clarified that effect-size functions do not automatically classify effects as small, medium, or large.

## Testing

* Added automated tests for `format_t()` and `format_f()`.

* Added automated tests for `format_d()`, `format_g()`, `format_eta2()`, `format_partial_eta2()`, and `format_omega2()`.

* The package test suite now includes 403 passing tests.
