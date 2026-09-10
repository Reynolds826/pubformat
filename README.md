
# pubformat

<!-- badges: start -->
<!-- badges: end -->

The goal of pubformat is to provide an R package for converting statistical results into consistent, publication-ready output.
The package is being developed around a simple principle: formatting should improve how statistical results are reported without changing the underlying statistical decision.
The first function, format_p(), provides publication-friendly formatting for p-values, including fixed decimal places, small-value reporting thresholds, optional significance codes, and careful handling of important statistical boundaries.

## Installation

pubformat is currently under development and **is not** yet available from CRAN.

If you have a local copy of the package source, you can install it with:

devtools::install()

Development installation instructions will be updated when the package is made publicly available.
## Example
Load the package:

library(pubformat)

Format a standard p-value:

format_p(0.048)
#> "p = .048"

Very small p-values are reported using a threshold rather than as zero:

format_p(0.0002)
#> "p < .001"

The reporting boundary is treated strictly. A p-value equal to .001 remains .001:

format_p(0.001)
#> "p = .001"

format_p(0.0009)
#> "p < .001"

This distinction can be important when .001 is used as a statistical criterion, such as after a multiple-comparison correction.

Significance codes

Significance codes are optional and are turned off by default:

format_p(0.048, sig = TRUE)
#> "p = .048 *"

format_p(0.006, sig = TRUE)
#> "p = .006 **"

format_p(0.0002, sig = TRUE)
#> "p < .001 ***"

Significance codes are calculated from the original numeric p-value rather than the rounded value.

For example:

format_p(0.0499, sig = TRUE)
#> "p = .050 *"

Although the displayed value rounds to .050, the significance classification correctly reflects the underlying value of .0499.

Vectorized formatting

format_p() accepts vectors:

format_p(c(0.048, 0.006, 0.0002, 0.213))
#> "p = .048"
#> "p = .006"
#> "p < .001"
#> "p = .213"

Missing values are preserved:

format_p(c(0.048, NA, 0.213))
#> "p = .048"
#> NA
#> "p = .213"
Controlling precision

The number of displayed decimal places can be changed with digits:

format_p(0.0483, digits = 2)
#> "p = .05"

format_p(0.0483, digits = 4)
#> "p = .0483"

By default, the reporting threshold follows the selected precision:

format_p(0.005, digits = 2)
#> "p < .01"

format_p(0.00005, digits = 4)
#> "p < .0001"

This prevents positive p-values from being reported as values such as p = .000.

#Development status

pubformat is in early development.

The current focus is to make format_p() reliable, well-tested, and useful before expanding the package to other statistical results.

Potential future formatting functions may include confidence intervals, effect sizes, estimates, percentages, and other commonly reported statistics.

## Research workflow examples

`format_p()` is designed to work with p-values produced during ordinary statistical analysis in R.

For example, a linear model might produce:

model <- lm(mpg ~ wt + am, data = mtcars)

summary(model)$coefficients[, "Pr(>|t|)"]

The resulting p-values can be passed directly to `format_p()`:

p_values <- summary(model)$coefficients[, "Pr(>|t|)"]

format_p(p_values)

Because `format_p()` is vectorized, each p-value is formatted consistently without requiring manual rounding or character manipulation.

Significance codes can also be added when preparing results for a table:

format_p(p_values, sig = TRUE)

For multiple-comparison procedures, adjusted p-values can be formatted in the same way:

raw_p <- c(.012, .031, .0004, .18)

adjusted_p <- p.adjust(
  raw_p,
  method = "bonferroni"
)

format_p(adjusted_p)

format_p()` does not perform the statistical correction itself. It formats the numeric results produced by R while preserving important reporting boundaries.

For example:

format_p(.001)
#> "p = .001"

format_p(.0009)
#> "p < .001"

The distinction between `p = .001` and `p < .001` is retained rather than treating the reporting threshold as a significance decision rule.

library(pubformat)

