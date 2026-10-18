REPORT yyk02574_sflight_alv.

TABLES sflight.

SELECT-OPTIONS s_carrid FOR sflight-carrid.

START-OF-SELECTION.
  DATA lt_flights TYPE STANDARD TABLE OF sflight.

  SELECT *
    FROM sflight
    WHERE carrid IN @s_carrid
    ORDER BY carrid, connid, fldate
    INTO TABLE @lt_flights
    UP TO 100 ROWS.

  IF lt_flights IS INITIAL.
    MESSAGE 'No flights found for the selected carrier.' TYPE 'S' DISPLAY LIKE 'W'.
    RETURN.
  ENDIF.

  TRY.
      DATA lo_alv TYPE REF TO cl_salv_table.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = lt_flights ).

      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->display( ).
    CATCH cx_salv_msg INTO DATA(lx_salv).
      MESSAGE lx_salv->get_text( ) TYPE 'E'.
  ENDTRY.


