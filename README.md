# pubformat

<!-- badges: start -->

<!-- badges: end -->

`pubformat` is an R package for converting statistical results into consistent, publication-ready output.

The package is built around a simple principle: **formatting should improve how statistical results are reported without changing the underlying statistical result or statistical decision**.

The current development version includes:

* `format_p()` for p-values
* `format_ci()` for confidence intervals
* `format_r()` for Pearson correlation coefficients
* `format_cor()` for Pearson, Spearman, and Kendall correlations
* `format_percent()` for proportions and percentages
* `format_t()` for t test statistics
* `format_f()` for F test statistics
* `format_d()` for Cohen's d
* `format_g()` for Hedges' g
* `format_eta2()` for eta squared
* `format_partial_eta2()` for partial eta squared
* `format_omega2()` for omega squared

The package uses publication-friendly defaults while allowing common formatting choices to be customized.

## Installation

The released version of `pubformat` is available from CRAN:

```r
install.packages("pubformat")
```

Load the package with:

```r
library(pubformat)
```

The development version can be installed from GitHub:

```r
# install.packages("remotes")
remotes::install_github("Reynolds826/pubformat")
```

The GitHub development version may contain functions and features that have not yet been included in the latest CRAN release.

If you are working from a local copy of the package source, you can also install it with:

```r
devtools::install()
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

Significance codes are calculated from the original numeric p-value rather than the rounded display value.

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

`format_ci()` combines numeric lower and upper confidence limits into publication-ready interval notation.

```r
format_ci(1.08, 1.87)
#> "95% CI [1.08, 1.87]"
```

The confidence level can be changed:

```r
format_ci(1.08, 1.87, level = 0.99)
#> "99% CI [1.08, 1.87]"
```

Leading zeros are retained by default because the appropriate convention depends on the statistic being reported:

```r
format_ci(0.21, 0.48)
#> "95% CI [0.21, 0.48]"
```

For statistics that cannot exceed 1 in absolute value, leading zeros can be omitted:

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

`format_r()` provides a concise formatter for Pearson correlation coefficients.

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

`format_cor()` provides a general correlation formatter and automatically uses the reporting symbol associated with the requested method.

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

`format_cor()` formats an existing coefficient. It does not calculate the correlation or determine statistical significance.

For example:

```r
rho <- cor(
  mtcars$mpg,
  mtcars$wt,
  method = "spearman"
)

format_cor(rho, method = "spearman")
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

## Test statistics

`format_t()` and `format_f()` convert already-computed test statistics and their degrees of freedom into publication-ready text.

These functions do not perform statistical tests. They format numeric results produced by R or another statistical procedure.

### t statistics

`format_t()` formats a t statistic together with its degrees of freedom:

```r
format_t(0.86, df = 20)
#> "t(20) = 0.86"
```

Negative statistics are preserved:

```r
format_t(-2.14, df = 48)
#> "t(48) = -2.14"
```

Fractional degrees of freedom are also supported:

```r
format_t(3.27, df = 105.5)
#> "t(105.5) = 3.27"
```

A p-value can be supplied directly:

```r
format_t(
  0.86,
  df = 20,
  p = 0.041
)
#> "t(20) = 0.86, p = .041"
```

The p-value is formatted through `format_p()`, so the same reporting rules are retained:

```r
format_t(
  statistic = c(3.10, 3.20),
  df = c(40, 40),
  p = c(0.001, 0.0009)
)

#> "t(40) = 3.10, p = .001"
#> "t(40) = 3.20, p < .001"
```

### F statistics

`format_f()` formats an F statistic with numerator and denominator degrees of freedom:

```r
format_f(
  2.50,
  df1 = 2,
  df2 = 30
)
#> "F(2, 30) = 2.50"
```

Fractional degrees of freedom are retained when present:

```r
format_f(
  4.4344,
  df1 = 1,
  df2 = 3262.9
)
#> "F(1, 3262.9) = 4.43"
```

A p-value can be included in the same result:

```r
format_f(
  4.4344,
  df1 = 1,
  df2 = 3262.9,
  p = 0.03530
)
#> "F(1, 3262.9) = 4.43, p = .035"
```

Very small p-values retain the behavior of `format_p()`:

```r
format_f(
  107.8924,
  df1 = 1,
  df2 = 86.7,
  p = 2e-16
)
#> "F(1, 86.7) = 107.89, p < .001"
```

This is useful for converting ANOVA or mixed-model output into manuscript-ready text.

### Styled statistical symbols

Plain output is the default because ordinary R console output does not render italics.

For output formats that support markup, `format_t()` and `format_f()` can return Markdown, HTML, or LaTeX formatting.

Markdown:

```r
format_f(
  4.4344,
  df1 = 1,
  df2 = 3262.9,
  p = 0.03530,
  style = "markdown"
)
#> "*F*(1, 3262.9) = 4.43, *p* = .035"
```

HTML:

```r
format_t(
  0.86,
  df = 20,
  p = 0.041,
  style = "html"
)
#> "<i>t</i>(20) = 0.86, <i>p</i> = .041"
```

LaTeX:

```r
format_t(
  0.86,
  df = 20,
  p = 0.041,
  style = "latex"
)
#> "\\textit{t}(20) = 0.86, \\textit{p} = .041"
```

## Effect sizes

The development version of `pubformat` includes formatters for several commonly reported effect sizes.

As with the rest of the package, these functions **do not calculate or interpret effect sizes**. They format values that have already been computed.

Optional confidence intervals can be supplied directly.

### Cohen's d

`format_d()` formats Cohen's d:

```r
format_d(0.52)
#> "d = 0.52"
```

Confidence intervals can be included:

```r
format_d(
  0.52,
  lower = 0.18,
  upper = 0.86
)
#> "d = 0.52, 95% CI [0.18, 0.86]"
```

Negative effects are preserved:

```r
format_d(
  -0.31,
  lower = -0.62,
  upper = 0.00
)
#> "d = -0.31, 95% CI [-0.62, 0.00]"
```

For rendered documents, the `d` symbol can be returned with Markdown, HTML, or LaTeX styling:

```r
format_d(
  0.52,
  lower = 0.18,
  upper = 0.86,
  style = "markdown"
)
#> "*d* = 0.52, 95% CI [0.18, 0.86]"
```

### Hedges' g

`format_g()` follows the same structure for Hedges' g:

```r
format_g(0.49)
#> "g = 0.49"
```

With a confidence interval:

```r
format_g(
  0.49,
  lower = 0.16,
  upper = 0.82
)
#> "g = 0.49, 95% CI [0.16, 0.82]"
```

Styled output is also supported:

```r
format_g(
  0.49,
  lower = 0.16,
  upper = 0.82,
  style = "markdown"
)
#> "*g* = 0.49, 95% CI [0.16, 0.82]"
```

### Eta squared

`format_eta2()` automatically supplies the eta-squared symbol:

```r
format_eta2(0.14)
#> "η² = .14"
```

Confidence intervals follow the same bounded-statistic formatting convention:

```r
format_eta2(
  0.14,
  lower = 0.08,
  upper = 0.21
)
#> "η² = .14, 95% CI [.08, .21]"
```

Because eta squared is bounded between 0 and 1, leading zeros are omitted.

### Partial eta squared

`format_partial_eta2()` automatically supplies the partial eta-squared symbol:

```r
format_partial_eta2(0.14)
#> "ηₚ² = .14"
```

With a confidence interval:

```r
format_partial_eta2(
  0.14,
  lower = 0.08,
  upper = 0.21
)
#> "ηₚ² = .14, 95% CI [.08, .21]"
```

The Unicode notation is included directly in the returned character output, avoiding the need to manually insert eta, a subscript p, and a superscript 2 in a word processor.

### Omega squared

`format_omega2()` automatically supplies the omega-squared symbol:

```r
format_omega2(0.08)
#> "ω² = .08"
```

Confidence intervals can be included:

```r
format_omega2(
  0.08,
  lower = 0.02,
  upper = 0.15
)
#> "ω² = .08, 95% CI [.02, .15]"
```

Negative omega-squared estimates are preserved rather than automatically truncated to zero:

```r
format_omega2(-0.02)
#> "ω² = -.02"
```

Negative confidence-limit estimates are also retained:

```r
format_omega2(
  0.01,
  lower = -0.03,
  upper = 0.05
)
#> "ω² = .01, 95% CI [-.03, .05]"
```

This reflects the package's general principle of formatting the supplied numeric result rather than changing the statistical estimate.

### Vectorized effect-size formatting

The effect-size functions accept vectors.

```r
format_d(
  d = c(0.52, -0.31, 1.14),
  lower = c(0.18, -0.62, 0.80),
  upper = c(0.86, 0.00, 1.48)
)

#> "d = 0.52, 95% CI [0.18, 0.86]"
#> "d = -0.31, 95% CI [-0.62, 0.00]"
#> "d = 1.14, 95% CI [0.80, 1.48]"
```

Likewise:

```r
format_eta2(
  eta2 = c(0.14, 0.00, 0.67),
  lower = c(0.08, 0.00, 0.55),
  upper = c(0.21, 0.04, 0.78)
)

#> "η² = .14, 95% CI [.08, .21]"
#> "η² = .00, 95% CI [.00, .04]"
#> "η² = .67, 95% CI [.55, .78]"
```

Missing values are preserved rather than silently converted into text.

## Research workflow example

`pubformat` is designed to handle the reporting step after statistical analysis rather than perform the analysis itself.

Consider a simple linear model using the built-in `mtcars` data:

```r
model <- lm(mpg ~ wt, data = mtcars)

summary(model)
```

The analysis produces numeric statistical results. Those values can then be extracted and formatted separately.

### P-value

```r
p_value <- summary(model)$coefficients["wt", "Pr(>|t|)"]

p_value
format_p(p_value)
```

### Confidence interval

```r
ci <- confint(model, "wt")

ci
format_ci(ci[1], ci[2])
```

### Correlation

```r
r_value <- cor(mtcars$mpg, mtcars$wt)

r_value
format_r(r_value)
```

### t statistic with p-value

```r
coef_table <- summary(model)$coefficients

t_value <- coef_table["wt", "t value"]
p_value <- coef_table["wt", "Pr(>|t|)"]
df_value <- df.residual(model)

format_t(
  statistic = t_value,
  df = df_value,
  p = p_value
)
```

The same principle applies to effect sizes: calculate or estimate the effect using an appropriate statistical procedure, then pass the resulting numeric estimate and optional confidence limits to the relevant `pubformat` function.

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

`pubformat` does not replace statistical analysis functions. Its purpose is to make the final reporting step more consistent, reproducible, and convenient.

## Design philosophy

The package separates three concepts that can otherwise become conflated:

1. **Statistical calculation** — performed by functions such as `lm()`, `cor()`, `confint()`, or functions from other statistical packages.
2. **Statistical decisions and interpretation** — made using the original numeric results, the research design, and the researcher's chosen inferential criteria.
3. **Publication formatting** — performed by `pubformat` after the analysis is complete.

This separation allows results to be formatted consistently without changing the values on which statistical conclusions are based.

For this reason, `pubformat` does not automatically label effect sizes as "small," "medium," or "large." Effect-size interpretation depends on context, discipline, design, and the measure being reported.

## Development status

`pubformat` is available on CRAN and remains under active development.

The current development version includes publication-ready formatting for:

* p-values
* confidence intervals
* Pearson correlations
* Pearson, Spearman, and Kendall correlations
* proportions and percentages
* t test statistics
* F test statistics
* paired test statistics and p-values
* Cohen's d
* Hedges' g
* eta squared
* partial eta squared
* omega squared
* optional confidence intervals for effect sizes
* plain, Markdown, HTML, and LaTeX output for supported Latin statistical symbols
* direct Unicode output for common Greek statistical symbols

Future development may include additional effect sizes, estimates, sample sizes, additional test statistics, and other commonly reported statistical results.
