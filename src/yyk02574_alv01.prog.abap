REPORT yyK02574_alv01.

TABLES sflight.

SELECT-OPTIONS s_carrid FOR sflight-carrid.
PARAMETERS p_max TYPE i DEFAULT 100.

TYPES ty_flight_tab TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.
DATA gt_flights TYPE ty_flight_tab.

AT SELECTION-SCREEN.
  IF p_max < 1 OR p_max > 5000.
    MESSAGE 'Enter a row limit between 1 and 5000.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  PERFORM select_flights.

  IF gt_flights IS INITIAL.
    MESSAGE 'No flight data matches the selection.' TYPE 'S' DISPLAY LIKE 'W'.
    RETURN.
  ENDIF.

  PERFORM display_flights.

FORM select_flights.
  SELECT carrid,
         connid,
         fldate,
         price,
         currency,
         planetype,
         seatsmax,
         seatsocc
    FROM sflight
    WHERE carrid IN @s_carrid
    ORDER BY carrid, connid, fldate
    INTO CORRESPONDING FIELDS OF TABLE @gt_flights
    UP TO @p_max ROWS.
ENDFORM.

FORM display_flights.
  DATA lo_alv TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_flights ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
      lo_alv->get_display_settings( )->set_list_header(
        'Simple ALV report for flight data' ).
      lo_alv->display( ).
    CATCH cx_salv_msg INTO DATA(lx_salv).
      MESSAGE lx_salv->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.
