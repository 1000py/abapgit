# Code Summary

## Files
- AGENTS.md: abapGit file layout, naming, and report generation requirements.
- abapgit.xml: Package descriptor at the root of the abapGit folder structure; points to `/src/`.
- src/yyk02574_sflight_alv.prog.abap: Executable SFLIGHT report; optionally filters by airline and displays up to 100 rows using SALV.
- src/yyk02574_sflight_alv.prog.xml: abapGit PROG metadata, report title, and airline parameter text.
- yyk02574_sflight_alv_package.zip: Distributable archive with the package descriptor and src report pair.

## Main flow
- p_carrid is the optional airline filter.
- START-OF-SELECTION calls display_flights.
- display_flights selects up to 100 ordered SFLIGHT rows, shows a warning-like message when no rows match, and otherwise displays an optimized SALV table with standard functions enabled.
