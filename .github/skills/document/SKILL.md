---
name: document
description: Document package functions. Use when asked to document functions.
---

# Document functions

*All* R functions in `R/` should be documented in {roxygen2} `#'` style, including internal/unexported functions.

- Run `air format .` then `devtools::document()` after changing any roxygen2 docs.
- Use sentence case for all headings.
- Files matching `R/import-standalone-*.R` are imported from other packages and have their own conventions. Do not modify their documentation.

## Shared parameters

**Parameters used in more than one function** go in `R/aaa-shared_params.R` under `@name .shared-params`. Functions inherit them with `@inheritParams .shared-params`. See @R/aaa-shared_params.R for current definitions (if it exists).

Shared params blocks: alphabetize parameters, use `@name .shared-params` (with leading dot), include `@keywords internal`, end with `NULL`.

## Parameter documentation format

```r
#' @param .param_name (`TYPE`) One sentence description. Can include [cross_references()].
#'   Additional details on continuation lines if needed.
```

Function-specific `@param` definitions always appear *before* any `@inheritParams` lines. If all parameters are defined locally, omit `@inheritParams` entirely.

### Type notation

- "(`character`)" - Character vector
- "(`character(1)`)" - Single string
- "(`logical(1)`)" - Single logical
- "(`integer`)" - Integer vector
- "(`vector(0)`)" - A prototype (zero-length vector)
- "(`vector`)" - A vector of unspecified type
- "(`list`)" - List
- "(`function` or `NULL`)" - A function or NULL
- "(`any`)" - Any type

### Enumerated values

When a parameter takes one of a fixed set of values, document them with a bullet list:

```r
#' @param .input_form (`character(1)`) The structure of the input field. Can be
#'   one of:
#'   * `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.
#'   * `"scalar_list"`: The field is a list of scalars, e.g. `list(1, 2, 3)`.
```

## Returns

Use `@returns` (not `@return`). Include a type when it's informative:

```r
#' @returns A data dictionary object.
#' @returns (`logical(1)`) `TRUE` if `x` is a valid dictionary column.
#' @returns Either a data frame or a list, depending on the input.
#' @returns `NULL` (invisibly).
```

## Exported functions

```r
#' Title in sentence case
#'
#' Description paragraph providing context and details.
#'
#' @param .param (`TYPE`) Description.
#' @inheritParams .shared-params
#'
#' @returns Description of return value.
#' @seealso [related_function()]
#' @export
#'
#' @examples
#' example_code()
```

- Blank `#'` lines separate: title/description, description/params, and `@export`/`@examples`.
- `@seealso` (optional) goes between `@returns` and `@export`.
- `@details` can supplement the description when needed.

## Internal (unexported) functions

Internal functions (starting with `.`) use abbreviated documentation:

```r
#' Title in sentence case
#'
#' @param .one_off_param (`TYPE`) Description.
#' @inheritParams .shared-params
#' @returns (`TYPE`) What it returns.
#' @keywords internal
```

No description paragraph, fewer blank `#'` lines, no `@examples`, `@keywords internal` instead of `@export`.

## S3 methods and `@rdname` grouping

Use `@rdname` to group related functions under one help page. This applies to:
- **S3 methods we own** (generic defined in this package): generic gets full docs, methods get `@rdname` + `@export`.
- **Related exported functions** (e.g., multiple variants of the same operation): primary function gets full docs, variants get `@rdname` + `@export`.

```r
#' Format a data dictionary
#'
#' @param x (`any`) The object to format.
#' @inheritParams .shared-params
#' @keywords internal
.format_dict <- function(x, ...) {
  UseMethod(".format_dict")
}

#' @rdname .format_dict
#' @export
.format_dict.data_dict <- function(x, ...) {
  # method implementation
}
```

**S3 methods we don't own** (generic from another package) need standalone documentation:

```r
#' Title describing the method
#'
#' @param x (`TYPE`) Description.
#' @param ... Additional arguments (ignored).
#' @returns Description.
#' @exportS3Method pkg::generic
method.class <- function(x, ...) { ... }
```

## Style notes

**Cross-references:** Use square brackets — `[create_dataset_dictionary()]` (internal), `[base::data.frame()]` (external), `[data_dict]` (topics).

**Section comment headers** organize code within a file, lowercase with dashes to column 80:

```r
# helpers ----------------------------------------------------------------------
```

**Examples:** Exported functions include `@examples`. Use `@examplesIf interactive()` for network-dependent functions. Use section-style comments (`# Section ---`) to organize longer example blocks. Internal functions do not get examples.
