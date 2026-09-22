# pubformat

<!-- badges: start -->

<!-- badges: end -->

`pubformat` is an R package for converting statistical results into consistent, publication-ready output.

The package is built around a simple principle: **formatting should improve how statistical results are reported without changing the underlying statistical result or statistical decision**.

Current functions include:

* `format_p()` for p-values
* `format_ci()` for confidence intervals
* `format_r()` for Pearson correlation coefficients
* `format_cor()` for Pearson, Spearman, and Kendall correlations
* `format_percent()` for proportions and percentages

The package uses publication-friendly defaults while allowing common formatting choices to be customized.

The third and fourth functions 'format_r()' and 'format_cor()' converts raw correlation coefficients into publication ready formatting.

## Installation

`pubformat` is currently under development and is **not yet available from CRAN**.

The development version can be installed from GitHub with:

```r
# install.packages("remotes")
remotes::install_github("Reynolds826/pubformat")
```

If you are working from a local copy of the package source, you can also install it with:

```r
devtools::install()
```

Load the package with:

```r
library(pubformat)
```

## P-values

`format_p()` converts numeric p-values into publication-ready text.

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

Although the displayed value rounds to `.050`, the significance classification reflects the underlying value of `.0499`.

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

`format_ci()` converts numeric lower and upper confidence limits into publication-ready text.

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

`format_ci()` also accepts vectors:

```r
lower <- c(1.08, -0.42, 2.15)
upper <- c(1.87, 0.18, 3.02)

format_ci(lower, upper)
#> "95% CI [1.08, 1.87]"
#> "95% CI [-0.42, 0.18]"
#> "95% CI [2.15, 3.02]"
```

## Correlations

### Pearson correlations

`format_r()` provides a simple formatter for Pearson correlation coefficients.

```r
format_r(0.42)
#> "r = .42"
```

Negative correlations are handled consistently:

```r
format_r(-0.31)
#> "r = -.31"
```

Because correlation coefficients cannot exceed 1 in absolute value, leading zeros are omitted by default.

They can be retained when needed:

```r
format_r(0.42, leading_zero = TRUE)
#> "r = 0.42"
```

Decimal precision can also be controlled:

```r
format_r(0.4231, digits = 3)
#> "r = .423"
```

Like the other `pubformat` functions, `format_r()` accepts vectors:

```r
format_r(c(0.42, -0.31, 0, 0.78))
#> "r = .42"
#> "r = -.31"
#> "r = .00"
#> "r = .78"
```

### Pearson, Spearman, and Kendall correlations

`format_cor()` provides a general correlation formatter and automatically uses the symbol associated with the requested method.

Pearson:

```r
format_cor(0.42, method = "pearson")
#> "r = .42"
```

Spearman:

```r
format_cor(0.42, method = "spearman")
#> "ρ = .42"
```

Kendall:

```r
format_cor(0.42, method = "kendall")
#> "τ = .42"
```

Negative coefficients are formatted consistently:

```r
format_cor(-0.31, method = "spearman")
#> "ρ = -.31"

format_cor(-0.31, method = "kendall")
#> "τ = -.31"
```

The `method` argument controls the reporting symbol only. `format_cor()` does not calculate the correlation or determine statistical significance.

For example, a Spearman correlation can first be calculated in R and then formatted:

```r
result <- cor(
  mtcars$mpg,
  mtcars$wt,
  method = "spearman"
)

format_cor(result, method = "spearman")
```

Associated p-values can be formatted separately with `format_p()`.

## Percentages

`format_percent()` converts proportions or already-scaled percentages into publication-ready percentage text.

By default, values are interpreted as proportions:

```r
format_percent(0.423)
#> "42.3%"
```

Decimal precision can be controlled with `digits`:

```r
format_percent(0.423, digits = 2)
#> "42.30%"
```

If values are already expressed as percentages, use `input = "percent"`:

```r
format_percent(42.3, input = "percent")
#> "42.3%"
```

This distinction prevents accidental rescaling:

```r
format_percent(0.42)
#> "42.0%"

format_percent(42, input = "percent")
#> "42.0%"
```

`format_percent()` also accepts vectors:

```r
format_percent(c(0.25, 0.50, 0.75))
#> "25.0%"
#> "50.0%"
#> "75.0%"
```

When values are supplied as already-scaled percentages, negative values and values greater than 100 are allowed. This is useful for quantities such as percent change:

```r
format_percent(-12.5, input = "percent")
#> "-12.5%"

format_percent(150, input = "percent")
#> "150.0%"
```

## Research workflow example

`pubformat` is designed to handle the reporting step after statistical analysis rather than perform the analysis itself.

For example, a linear model can produce numeric p-values:

```r
model <- lm(mpg ~ wt + am, data = mtcars)

p_values <- summary(model)$coefficients[, "Pr(>|t|)"]
```

Those numeric results can then be formatted for reporting:

```r
format_p(p_values)
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

Similarly, statistics can be calculated first and formatted afterward:

```r
r_value <- cor(mtcars$mpg, mtcars$wt)

format_r(r_value)
```

The intended workflow is:

```text
statistical analysis
        ↓
numeric statistical results
        ↓
pubformat
        ↓
publication-ready output
```

## Development status

`pubformat` is in early development.

Current functionality includes publication-ready formatting for:

* p-values
* confidence intervals
* Pearson correlations
* Pearson, Spearman, and Kendall correlations
* proportions and percentages

Future development may include formatting for effect sizes, estimates, sample sizes, test statistics, and other commonly reported statistical results.
