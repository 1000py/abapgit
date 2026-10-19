# Code Summary

## Files
- `AGENTS.md`: abapGit naming, layout, and report-generation rules.
- `abapgit.xml`: Package descriptor; points to `/src/`.
- `src/yyk02574_alv01.prog.abap`: Executable SFLIGHT ALV report; optional airline filter, ordered output, maximum 100 rows, and SALV standard functions.
- `src/yyk02574_alv01.prog.xml`: PROG metadata and report title.
- `REPORT.md`: Usage and package contents for the generated report.
- `yyk02574_sflight_alv_package.zip`: Distributable abapGit package with descriptor and report pair.

## Main flow
- `s_carrid` is an optional airline selection range.
- `START-OF-SELECTION` selects up to 100 ordered SFLIGHT rows.
- SALV displays matching rows with standard functions and optimized columns; no matches produce an informational warning. SALV errors are shown as error messages.
