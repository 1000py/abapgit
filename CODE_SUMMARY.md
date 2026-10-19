# Code Summary

## Files
- `AGENTS.md`: abapGit naming, layout, and packaging rules.
- `.abapgit.xml`: package descriptor targeting `/src/`.
- `src/yyk02574_alv01.prog.abap`: Layered object-oriented SFLIGHT report. Local interfaces isolate repository and presenter; service validates the use case; application coordinates execution; factory assembles dependencies; SALV presenter renders output.
- `src/yyk02574_alv01.prog.xml`: PROG metadata and report title.
- `REPORT.md`: usage and package layout.
- `yyk02574_sflight_alv_package.zip`: distributable package archive.

## Main flow
- `s_carrid`, `s_connid`, and `s_fldate` optionally filter the result; `p_max` limits results to 1–5000 (default 500).
- `AT SELECTION-SCREEN` gives immediate row-limit feedback; `lcl_flight_service` repeats the invariant at the use-case boundary.
- `START-OF-SELECTION` composes the application through `lcl_flight_factory`; `lcl_flight_application` coordinates repository-backed retrieval and presentation.
- `lif_flight_repository` and `lif_flight_presenter` are dependency boundaries; the concrete repository reads ordered SFLIGHT data and the SALV presenter handles display and UI exceptions.
- Empty results are handled by the presenter; application errors are converted to user-facing messages at the report boundary.
