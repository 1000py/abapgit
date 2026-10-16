*&---------------------------------------------------------------------*
*& Report Z_SFLIGHT_ALV
*& Simple ALV report for flight data
*&---------------------------------------------------------------------*
REPORT z_sflight_alv.

TABLES sflight.

SELECT-OPTIONS s_carrid FOR sflight-carrid.

DATA gt_sflight TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.

START-OF-SELECTION.
  SELECT *
    FROM sflight
    WHERE carrid IN @s_carrid
    ORDER BY carrid, connid, fldate
    INTO TABLE @gt_sflight
    UP TO 100 ROWS.

  TRY.
      DATA lo_alv TYPE REF TO cl_salv_table.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_sflight ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->display( ).
    CATCH cx_salv_msg INTO DATA(lx_salv).
      DATA lv_error_text TYPE string.
      lv_error_text = lx_salv->get_text( ).
      MESSAGE lv_error_text TYPE 'E'.
  ENDTRY.
