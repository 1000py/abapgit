*&---------------------------------------------------------------------*
*& Report Z_SFLIGHT_ALV
*& Simple ALV report for flight data
*&---------------------------------------------------------------------*
REPORT z_sflight_alv.

TYPE-POOLS: slis.
TABLES: sflight.

SELECT-OPTIONS:
  so_carr FOR sflight-carrid,
  so_conn FOR sflight-connid.

DATA:
  gt_sflight  TYPE STANDARD TABLE OF sflight,
  gt_fieldcat TYPE slis_t_fieldcat_alv,
  gs_layout   TYPE slis_layout_alv.

START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO TABLE @gt_sflight
    WHERE carrid IN @so_carr
      AND connid IN @so_conn.

  IF gt_sflight IS INITIAL.
    MESSAGE '조건에 맞는 항공편이 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  PERFORM build_fieldcatalog.
  gs_layout-zebra = abap_true.
  gs_layout-colwidth_optimize = abap_true.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
      i_save             = 'A'
    TABLES
      t_outtab           = gt_sflight
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE 'ALV 표시 중 오류가 발생했습니다.' TYPE 'E'.
  ENDIF.

FORM build_fieldcatalog.
  DATA ls_fieldcat TYPE slis_fieldcat_alv.

  CLEAR gt_fieldcat.

  DEFINE add_field.
    CLEAR ls_fieldcat.
    ls_fieldcat-fieldname = &1.
    ls_fieldcat-seltext_m = &2.
    ls_fieldcat-key       = &3.
    APPEND ls_fieldcat TO gt_fieldcat.
  END-OF-DEFINITION.

  add_field 'CARRID'     '항공사'   abap_true.
  add_field 'CONNID'     '항공편'   abap_true.
  add_field 'FLDATE'     '운항일자' abap_true.
  add_field 'PRICE'      '항공요금' abap_false.
  add_field 'CURRENCY'   '통화'     abap_false.
  add_field 'PLANETYPE'  '기종'     abap_false.
  add_field 'SEATSMAX'   '최대좌석' abap_false.
  add_field 'SEATSOCC'   '예약좌석' abap_false.
  add_field 'PAYMENTSUM' '결제합계' abap_false.
ENDFORM.
