# SFLIGHT ALV Report

`YYK02574_ALV01` displays up to 100 flight records from `SFLIGHT` using the SALV table viewer.

## Usage

- Run the report and optionally enter one or more airline IDs in `S_CARRID`.
- The report sorts by airline, connection, and flight date.
- Standard ALV functions are enabled and column widths are optimized.
- If no rows match, the report displays a warning message.

## Package contents

- `abapgit.xml`: package descriptor for `/src/`.
- `src/yyk02574_alv01.prog.abap`: report source.
- `src/yyk02574_alv01.prog.xml`: executable program metadata.
