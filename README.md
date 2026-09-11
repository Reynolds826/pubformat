# pubformat

<!-- badges: start -->

<!-- badges: end -->

The goal of `pubformat` is to provide an R package for converting statistical results into consistent, publication-ready output.

The package is being developed around a simple principle: **formatting should improve how statistical results are reported without changing the underlying statistical decision**.

The first function, `format_p()`, provides publication-friendly formatting for p-values, including fixed decimal places, small-value reporting thresholds, optional significance codes, and careful handling of important statistical boundaries.

The second function, `format_ci()`, converts numeric confidence interval limits into publication-ready formatting.

## Installation

`pubformat` is currently under development and is **not yet** available from CRAN.

If you have a local copy of the package source, you can install it with:

```r
devtools::install()
```

Development installation instructions will be updated when the package is made publicly available.

## P-values

Load the package:

```r
library(pubformat)
```

Format a standard p-value:

```r
format_p(0.048)
#> "p = .048"
```

Very small p-values are reported using a threshold rather than as zero:

```r
format_p(0.0002)
#> "p < .001"
```

The reporting boundary is treated strictly. A p-value equal to `.001` remains `.001`:

```r
format_p(0.001)
#> "p = .001"

format_p(0.0009)
#> "p < .001"
```

This distinction can be important when `.001` is used as a statistical criterion, such as after a multiple-comparison correction.

### Significance codes

Significance codes are optional and are turned off by default:

```r
format_p(0.048, sig = TRUE)
#> "p = .048 *"

format_p(0.006, sig = TRUE)
#> "p = .006 **"

format_p(0.0002, sig = TRUE)
#> "p < .001 ***"
```

Significance codes are calculated from the original numeric p-value rather than the rounded value.

For example:

```r
format_p(0.0499, sig = TRUE)
#> "p = .050 *"
```

Although the displayed value rounds to `.050`, the significance classification correctly reflects the underlying value of `.0499`.

### Vectorized formatting

`format_p()` accepts vectors:

```r
format_p(c(0.048, 0.006, 0.0002, 0.213))
#> "p = .048"
#> "p = .006"
#> "p < .001"
#> "p = .213"
```

Missing values are preserved:

```r
format_p(c(0.048, NA, 0.213))
#> "p = .048"
#> NA
#> "p = .213"
```

### Controlling precision

The number of displayed decimal places can be changed with `digits`:

```r
format_p(0.0483, digits = 2)
#> "p = .05"

format_p(0.0483, digits = 4)
#> "p = .0483"
```

By default, the reporting threshold follows the selected precision:

```r
format_p(0.005, digits = 2)
#> "p < .01"

format_p(0.00005, digits = 4)
#> "p < .0001"
```

This prevents positive p-values from being reported as values such as `p = .000`.

## Confidence intervals

`format_ci()` converts numeric confidence interval limits into publication-ready text.

```r
format_ci(1.08, 1.87)
#> "95% CI [1.08, 1.87]"
```

The confidence level can be changed:

```r
format_ci(1.08, 1.87, level = 0.99)
#> "99% CI [1.08, 1.87]"
```

By default, leading zeros are retained because the appropriate convention depends on the statistic being reported:

```r
format_ci(0.21, 0.48)
#> "95% CI [0.21, 0.48]"
```

For statistics that cannot exceed 1 in absolute value, such as correlations, leading zeros can be removed:

```r
format_ci(0.21, 0.48, leading_zero = FALSE)
#> "95% CI [.21, .48]"
```

The function also works with vectors of confidence limits:

```r
lower <- c(1.08, -0.42, 2.15)
upper <- c(1.87, 0.18, 3.02)

format_ci(lower, upper)
#> "95% CI [1.08, 1.87]"
#> "95% CI [-0.42, 0.18]"
#> "95% CI [2.15, 3.02]"
```

## Research workflow examples

`format_p()` is designed to work with p-values produced during ordinary statistical analysis in R.

For example, a linear model might produce:

```r
model <- lm(mpg ~ wt + am, data = mtcars)

summary(model)$coefficients[, "Pr(>|t|)"]
```

The resulting p-values can be passed directly to `format_p()`:

```r
p_values <- summary(model)$coefficients[, "Pr(>|t|)"]

format_p(p_values)
```

Because `format_p()` is vectorized, each p-value is formatted consistently without requiring manual rounding or character manipulation.

Significance codes can also be added when preparing results for a table:

```r
format_p(p_values, sig = TRUE)
```

For multiple-comparison procedures, adjusted p-values can be formatted in the same way:

```r
raw_p <- c(.012, .031, .0004, .18)

adjusted_p <- p.adjust(
  raw_p,
  method = "bonferroni"
)

format_p(adjusted_p)
```

`format_p()` does not perform the statistical correction itself. It formats the numeric results produced by R while preserving important reporting boundaries.

For example:

```r
format_p(.001)
#> "p = .001"

format_p(.0009)
#> "p < .001"
```

The distinction between `p = .001` and `p < .001` is retained rather than treating the reporting threshold as a significance decision rule.

## Development status

`pubformat` is in early development.

Current functionality includes publication-ready formatting for p-values and confidence intervals.

Future formatting functions may include effect sizes, estimates, percentages, and other commonly reported statistics.
