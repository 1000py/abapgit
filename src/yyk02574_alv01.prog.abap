REPORT yyk02574_alv01.

" Flight operations overview: a small layered design in one transportable report.
" Repository owns persistence, service owns use-case policy, presenter owns SALV UI.

TABLES: sflight.

SELECT-OPTIONS:
  s_carrid FOR sflight-carrid,
  s_connid FOR sflight-connid,
  s_fldate FOR sflight-fldate.

PARAMETERS:
  p_max TYPE i DEFAULT 500 OBLIGATORY.

TYPES:
  BEGIN OF ty_flight,
    carrid    TYPE sflight-carrid,
    connid    TYPE sflight-connid,
    fldate    TYPE sflight-fldate,
    price     TYPE sflight-price,
    currency  TYPE sflight-currency,
    planetype TYPE sflight-planetype,
    seatsmax  TYPE sflight-seatsmax,
    seatsocc  TYPE sflight-seatsocc,
    payments  TYPE sflight-paymentsum,
  END OF ty_flight,
  ty_flights TYPE STANDARD TABLE OF ty_flight WITH EMPTY KEY.

CLASS lcx_flight_app DEFINITION INHERITING FROM cx_static_check FINAL.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_text TYPE string.
    METHODS get_text REDEFINITION.
  PRIVATE SECTION.
    DATA mv_text TYPE string.
ENDCLASS.

CLASS lcx_flight_app IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mv_text = iv_text.
  ENDMETHOD.
  METHOD get_text.
    result = mv_text.
  ENDMETHOD.
ENDCLASS.

INTERFACE lif_flight_repository.
  METHODS find
    IMPORTING it_carrid TYPE RANGE OF sflight-carrid
              it_connid TYPE RANGE OF sflight-connid
              it_fldate TYPE RANGE OF sflight-fldate
              iv_limit  TYPE i
    RETURNING VALUE(rt_flights) TYPE ty_flights
    RAISING lcx_flight_app.
ENDINTERFACE.

INTERFACE lif_flight_presenter.
  METHODS show IMPORTING it_flights TYPE ty_flights RAISING lcx_flight_app.
  METHODS show_empty.
ENDINTERFACE.

CLASS lcl_flight_repository DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_flight_repository.
ENDCLASS.

CLASS lcl_flight_repository IMPLEMENTATION.
  METHOD lif_flight_repository~find.
    SELECT carrid, connid, fldate, price, currency, planetype,
           seatsmax, seatsocc, paymentsum AS payments
      FROM sflight
      WHERE carrid IN @it_carrid
        AND connid IN @it_connid
        AND fldate IN @it_fldate
      ORDER BY carrid, connid, fldate
      INTO CORRESPONDING FIELDS OF TABLE @rt_flights
      UP TO @iv_limit ROWS.
    IF sy-subrc <> 0.
      CLEAR rt_flights.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_flight_service DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS constructor IMPORTING io_repository TYPE REF TO lif_flight_repository.
    METHODS execute
      IMPORTING it_carrid TYPE RANGE OF sflight-carrid
                it_connid TYPE RANGE OF sflight-connid
                it_fldate TYPE RANGE OF sflight-fldate
                iv_limit  TYPE i
      RETURNING VALUE(rt_flights) TYPE ty_flights
      RAISING lcx_flight_app.
  PRIVATE SECTION.
    DATA mo_repository TYPE REF TO lif_flight_repository.
ENDCLASS.

CLASS lcl_flight_service IMPLEMENTATION.
  METHOD constructor.
    mo_repository = io_repository.
  ENDMETHOD.
  METHOD execute.
    IF iv_limit < 1 OR iv_limit > 5000.
      RAISE EXCEPTION TYPE lcx_flight_app
        EXPORTING iv_text = 'Maximum rows must be between 1 and 5000.'.
    ENDIF.
    rt_flights = mo_repository->find(
      it_carrid = it_carrid
      it_connid = it_connid
      it_fldate = it_fldate
      iv_limit = iv_limit ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_salv_presenter DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_flight_presenter.
ENDCLASS.

CLASS lcl_salv_presenter IMPLEMENTATION.
  METHOD lif_flight_presenter~show.
    DATA lo_alv TYPE REF TO cl_salv_table.
    DATA lo_columns TYPE REF TO cl_salv_columns_table.
    DATA lo_functions TYPE REF TO cl_salv_functions_list.
    DATA lo_display TYPE REF TO cl_salv_display_settings.
    DATA lv_title TYPE lvc_title.

    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = lo_alv
          CHANGING  t_table      = it_flights ).
        lo_functions = lo_alv->get_functions( ).
        lo_functions->set_all( abap_true ).
        lo_columns = lo_alv->get_columns( ).
        lo_columns->set_optimize( abap_true ).
        lo_display = lo_alv->get_display_settings( ).
        lo_display->set_striped_pattern( abap_true ).
        lv_title = |Flight operations overview ({ lines( it_flights ) } rows)|.
        lo_display->set_list_header( lv_title ).
        lo_alv->display( ).
      CATCH cx_salv_msg INTO DATA(lx_salv).
        RAISE EXCEPTION TYPE lcx_flight_app
          EXPORTING iv_text = lx_salv->get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD lif_flight_presenter~show_empty.
    MESSAGE 'No flights match the selected criteria.' TYPE 'S' DISPLAY LIKE 'I'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_flight_application DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS run RAISING lcx_flight_app.
  PRIVATE SECTION.
    FRIENDS lcl_flight_factory.
    DATA mo_service TYPE REF TO lcl_flight_service.
    DATA mo_presenter TYPE REF TO lif_flight_presenter.
ENDCLASS.

CLASS lcl_flight_application IMPLEMENTATION.
  METHOD run.
    DATA(lt_flights) = mo_service->execute(
      it_carrid = s_carrid[]
      it_connid = s_connid[]
      it_fldate = s_fldate[]
      iv_limit = p_max ).
    IF lt_flights IS INITIAL.
      mo_presenter->show_empty( ).
      RETURN.
    ENDIF.
    mo_presenter->show( lt_flights ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_flight_factory DEFINITION FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS create_application
      RETURNING VALUE(ro_application) TYPE REF TO lcl_flight_application.
ENDCLASS.

CLASS lcl_flight_factory IMPLEMENTATION.
  METHOD create_application.
    DATA(lo_repository) = NEW lcl_flight_repository( ).
    DATA(lo_service) = NEW lcl_flight_service( lo_repository ).
    DATA(lo_presenter) = NEW lcl_salv_presenter( ).
    ro_application = NEW lcl_flight_application( ).
    ro_application->mo_service = lo_service.
    ro_application->mo_presenter = lo_presenter.
  ENDMETHOD.
ENDCLASS.

AT SELECTION-SCREEN ON p_max.
  IF p_max < 1 OR p_max > 5000.
    MESSAGE 'Maximum rows must be between 1 and 5000.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  TRY.
      DATA(lo_application) = lcl_flight_factory=>create_application( ).
      lo_application->run( ).
    CATCH lcx_flight_app INTO DATA(lx_app).
      MESSAGE lx_app->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.
