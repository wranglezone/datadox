# Write lines to a file and optionally open it for editing

Write lines to a file and optionally open it for editing

## Usage

``` r
.write_file_lines(lines, file_path, open = rlang::is_interactive())
```

## Arguments

- lines:

  (`character`) The lines to write.

- file_path:

  (`character(1)`) Path to the output file.

- open:

  (`logical(1)`) Whether to open the file for editing after writing.
  Defaults to `TRUE` in interactive sessions.

## Value

(`character(1)`) The path to the written file, invisibly.
