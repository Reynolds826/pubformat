# pubformat 0.1.0.9000

## New features

* Added `format_t()` for publication-ready formatting of t test statistics and degrees of freedom.

* Added `format_f()` for publication-ready formatting of F test statistics with numerator and denominator degrees of freedom.

* `format_t()` and `format_f()` can optionally include p-values, which are formatted using the existing `format_p()` behavior.

* Added support for fractional degrees of freedom, including values commonly produced by approximation methods such as Satterthwaite degrees of freedom.

* Added optional styled output for t, F, and p symbols using plain text, Markdown, HTML, or LaTeX.

* Added vectorized formatting, missing-value handling, input validation, and preservation of names for the new test-statistic formatters.

## Documentation

* Updated the README with examples for `format_t()` and `format_f()`.

* Expanded the workflow vignette to include test-statistic formatting and p-value pairing.

## Testing

* Added automated tests for `format_t()` and `format_f()`.

* The package test suite now includes 299 passing tests.
