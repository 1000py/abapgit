# YYK02574_ALV01

Executable ABAP report that reads flight data from the SAP demo table `SFLIGHT` and displays it in a SALV ALV table.

## Selection

- `S_CARRID`: optional airline ID range.
- `S_CONNID`: optional connection ID range.
- `S_FLDATE`: optional flight date range.
- `P_MAX`: result limit from 1 to 5000 (default 100).

The report displays carrier, connection, flight date, price, currency, aircraft type, maximum seats, and occupied seats. Results are ordered by carrier, connection, and date. Standard SALV functions, optimized column widths, striped rows, and a result-count heading are enabled. Empty results display a warning-style message.

## Package layout

- `.abapgit.xml`: abapGit package descriptor, starting folder `/src/`.
- `src/yyk02574_alv01.prog.abap`: executable ABAP report.
- `src/yyk02574_alv01.prog.xml`: report metadata.
