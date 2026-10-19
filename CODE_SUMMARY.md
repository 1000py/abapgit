# Code Summary

## Files
- `AGENTS.md`: abapGit naming, layout, and packaging rules.
- `.abapgit.xml`: package descriptor targeting `/src/`.
- `src/yyK02574_alv01.prog.abap`: SFLIGHT ALV report with airline filtering, row-limit validation, ordered selection, and SALV output.
- `src/yyK02574_alv01.prog.xml`: PROG metadata and report title.
- `REPORT.md`: usage and package layout.
- `yyk02574_sflight_alv_package.zip`: distributable package archive.

## Main flow
- `s_carrid` optionally filters airlines; `p_max` limits results to 1–5000 (default 100).
- `AT SELECTION-SCREEN` validates the row limit.
- `START-OF-SELECTION` selects flight data, handles empty results, and invokes the ALV display.
- `select_flights` reads selected SFLIGHT columns ordered by carrier, connection, and date.
- `display_flights` creates the SALV grid with standard functions, optimized widths, striped rows, a heading, and exception handling.
