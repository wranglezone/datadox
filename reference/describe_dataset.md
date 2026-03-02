# Generate a `@format` roxygen2 block for a dataset

Builds a complete `@format` block describing a dataset's columns,
suitable for use with `@eval` in roxygen2 documentation. The header line
reflects the actual dimensions of `dataset`; each column gets one
`\item` entry combining the class label and description from
`dictionary`.

## Usage

``` r
describe_dataset(dataset, dictionary = create_dataset_dictionary(dataset))
```

## Arguments

- dataset:

  (`data.frame`) The dataset to document.

- dictionary:

  (`data.frame`) A dictionary with columns `column_name`, `class`, and
  `description`, one row per column of `dataset`. Defaults to
  `create_dataset_dictionary(dataset)`.

## Value

(`character`) A character vector of roxygen2 lines forming a `@format`
block, suitable for returning from `@eval`.

## See also

[`create_dataset_dictionary()`](https://wranglezone.github.io/datawrap/reference/create_dataset_dictionary.md)

## Examples

``` r
describe_dataset(mtcars)
#>  [1] "@format A tibble with 32 rows and 11 variables:"
#>  [2] "\\describe{"                                    
#>  [3] "  \\item{mpg}{(`double`) Mpg.}"                 
#>  [4] "  \\item{cyl}{(`double`) Cyl.}"                 
#>  [5] "  \\item{disp}{(`double`) Disp.}"               
#>  [6] "  \\item{hp}{(`double`) Hp.}"                   
#>  [7] "  \\item{drat}{(`double`) Drat.}"               
#>  [8] "  \\item{wt}{(`double`) Wt.}"                   
#>  [9] "  \\item{qsec}{(`double`) Qsec.}"               
#> [10] "  \\item{vs}{(`double`) Vs.}"                   
#> [11] "  \\item{am}{(`double`) Am.}"                   
#> [12] "  \\item{gear}{(`double`) Gear.}"               
#> [13] "  \\item{carb}{(`double`) Carb.}"               
#> [14] "}"                                              
```
