# YYK02574_ALV01

SFLIGHT flight report using the SALV table display.

## Selection

- `S_CARRID`: optional airline ID range.
- `P_MAX`: result limit from 1 to 5000 (default 100).

The report displays carrier, connection, flight date, price, currency, aircraft type, maximum seats, and occupied seats. Results are ordered by carrier, connection, and date. Standard SALV functions, optimized column widths, and striped rows are enabled. Empty results display a warning-style message.

## Package layout

- `.abapgit.xml`: abapGit package descriptor, starting folder `/src/`.
- `src/yyK02574_alv01.prog.abap`: executable ABAP report.
- `src/yyK02574_alv01.prog.xml`: report metadata.
