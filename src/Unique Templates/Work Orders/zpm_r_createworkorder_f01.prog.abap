*&---------------------------------------------------------------------*
*&  Include           ZPM_R_CREATEWORKORDER_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .


  " Fetching relevant details for the notification for work order creation
  " QMEL : QMNUM (Notification Number) , QMART (Notification Type) , ARBPL (Object ID of Work Center)
  " QMIL : ILOAN (Used for fetching TPLNR)
  " ILOA : TPLNR (Functional Location)
  " CRHD : ARBPL  (Work Center) , WERKS (Planning Plant)

  SELECT SINGLE qmnum qmart arbpl  FROM qmel INTO CORRESPONDING FIELDS OF lwa_qmel WHERE qmnum = p_notif.
  IF sy-subrc NE 0.                   " if notification number does not exist
    MESSAGE E000.                     " no entries in QMEL
  ELSE.
    SELECT SINGLE arbpl  werks FROM crhd INTO CORRESPONDING FIELDS OF lwa_crhd WHERE objid = lwa_qmel-arbpl.
    IF sy-subrc NE 0.                 " if object id for the notification number does not match
      MESSAGE E001.                   " no entries in QMEL
    ELSE.
      SELECT SINGLE iloan FROM qmih INTO lv_iloan WHERE qmnum = lwa_qmel-qmnum.
      IF sy-subrc NE 0.               " if there is not Iloan field for the given notification number
        MESSAGE E002.                 " no entries in QMEL
      ELSE.
        SELECT SINGLE tplnr FROM iloa INTO lv_tplnr WHERE iloan = lv_iloan.
        IF sy-subrc NE 0.             " If there is no functional location for the given iloan number
          MESSAGE E003.               " no entries in QMEL
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.










ENDFORM.                    " FETCH_DATA
*&---------------------------------------------------------------------*
*&      Form  CREATE_WKORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_wkorder .


* Filling the method table of BAPI_ALM_ORDER_MAINTAIN
*000001
" CREATE Method in HEADER implying creation of a new work order with relevant ref number & temp object key
  lwa_method_table-refnumber = '1'.
  lwa_method_table-method = 'CREATE'.
  lwa_method_table-objecttype = 'HEADER'.
  lwa_method_table-objectkey = '%00000000001'.
  APPEND lwa_method_table TO lit_method_table.
  CLEAR lwa_method_table.
*
" CREATE method in OPERATION implying creation of a new operation with relevant ref number & temp object key
  lwa_method_table-refnumber = '1'.
  lwa_method_table-method = 'CREATE'.
  lwa_method_table-objecttype = 'OPERATION'.
  lwa_method_table-objectkey = '%00000000001'.
  APPEND lwa_method_table TO lit_method_table.
  CLEAR lwa_method_table.

" SAVE method with relevant ref number & temp object key signifying saving the changes
  lwa_method_table-method = 'SAVE'.
*  lwa_method_table-objectkey = '10'.
  lwa_method_table-refnumber = '1'.
  APPEND lwa_method_table TO lit_method_table.
  CLEAR lwa_method_table.

* Filling the Header table with relevant details

  lwa_header-notif_no = p_notif.                      " notification number
  lwa_header-orderid  = '%00000000001'.
  lwa_header-notif_type = lwa_qmel-qmart.             " notification type
  lwa_header-planplant = lwa_crhd-werks.              " Planning plant
  lwa_header-funct_loc = lv_tplnr.                    " functional location
  lwa_header-short_text = 'work order 1'.             " text for the work order
  lwa_header-order_type = p_odrtyp.                   " work order type
  lwa_header-mn_wk_ctr = lwa_crhd-arbpl. .            " work center number
*  lwa_header-c = lwa_crhd-arbpl. .            " work center number
  lwa_header-start_date = sy-datum.
  lwa_header-finish_date = sy-datum + 2.
    lwa_header-basicstart = sy-dayst.
  lwa_header-basic_fin = sy-dayst.
  APPEND lwa_header TO lit_header.                    " appending the changes to relevant table

* Filling the operation table with relevant details

  lwa_operation-work_cntr = lwa_crhd-arbpl.           " work center
  lwa_operation-plant =  lwa_crhd-werks.              " planning plant
  lwa_operation-activity = '10'.                      " activity number
  lwa_operation-control_key = 'PM01'."abap_true.
  APPEND lwa_operation TO lit_operation.              " appending the changes to relevant table

*  DATA :lwA_longtext like line of lit_textlines.
*  lwa_longtext = 'Longtext Teja 10'.
*  APPEND lwa_longtext   to lit_textlines.

* Function module for creating / changing a work order

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
*   EXPORTING
*     IV_MMSRV_EXTERNAL_MAINTENACE       =
    TABLES
      it_methods                         =  lit_method_table      " methods table filled with steps to carry out
      it_header                          =  lit_header            " header table containing relevant data
*     IT_HEADER_UP                       =
*     IT_HEADER_SRV                      =
*     IT_HEADER_SRV_UP                   =
*     IT_USERSTATUS                      =
*     IT_PARTNER                         =
*     IT_PARTNER_UP                      =
      it_operation                       = lit_operation          " operation table containing relevant data regarding
*     IT_OPERATION_UP                    =
*     IT_RELATION                        =
*     IT_RELATION_UP                     =
*     IT_COMPONENT                       =
*     IT_COMPONENT_UP                    =
*     IT_OBJECTLIST                      =
*     IT_OBJECTLIST_UP                   =
*     IT_OLIST_RELATION                  =
*     IT_TEXT                            =
*     IT_TEXT_LINES                      =  lit_textlines
*     IT_SRULE                           =
*     IT_SRULE_UP                        =
*     IT_TASKLISTS                       =
*     EXTENSION_IN                       =
      return                             = lit_return              " return table containing errors if any
      ET_NUMBERS                         = lit_output              " output table containing work order number
*     IT_REFORDER_ITEM                   =
*     IT_REFORDER_ITEM_UP                =
*     IT_REFORDER_SERNO_OLIST_INS        =
*     IT_REFORDER_SERNO_OLIST_DEL        =
*     IT_PRT                             =
*     IT_PRT_UP                          =
*     IT_REFORDER_OPERATION              =
*     IT_SERVICEOUTLINE                  =
*     IT_SERVICEOUTLINE_UP               =
*     IT_SERVICELINES                    =
*     IT_SERVICELINES_UP                 =
*     IT_SERVICELIMIT                    =
*     IT_SERVICELIMIT_UP                 =
*     IT_SERVICECONTRACTLIMITS           =
*     IT_SERVICECONTRACTLIMITS_UP        =
*     ET_NOTIFICATION_NUMBERS            =
*     IT_PERMIT                          =
*     IT_PERMIT_UP                       =
*     IT_PERMIT_ISSUE                    =
*     IT_ESTIMATED_COSTS                 =
            .

  READ TABLE lit_return INTO lwa_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.                                       " commit only if work order is created successfully

* Function module for commiting the changes

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
       EXPORTING
         wait          =  c_x
*     IMPORTING
*       RETURN        =
              .




  ENDIF.

* clearing relevant tables and work areas

  CLEAR : lwa_header , lwa_operation.
  REFRESH : lit_header,lit_operation,lit_return.

ENDFORM.                    " CREATE_WKORDER
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_WKORDER_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_wkorder_list.

* Function module for displaying oputput as an ALV list

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK              = ' '
*     I_BYPASSING_BUFFER             =
*     I_BUFFER_ACTIVE                = ' '
     i_callback_program              = sy-repid                     " calling program name
*     I_CALLBACK_PF_STATUS_SET       = ' '
     i_callback_user_command         = 'INTERACT_ALV'               " form handling interactive events
*     I_STRUCTURE_NAME               =
     is_layout                       = lwa_layout                   " work area containing layout changes
     it_fieldcat                     = lit_fcat                     " field catalog containing table details
*     IT_EXCLUDING                   =
*     IT_SPECIAL_GROUPS              =
*     IT_SORT                        =
*     IT_FILTER                      =
*     IS_SEL_HIDE                    =
*     I_DEFAULT                      = 'X'
*     I_SAVE                         = ' '
*     IS_VARIANT                     =
     it_events                       = lit_events                   " table containing list of events in alv
*     IT_EVENT_EXIT                  =
*     IS_PRINT                       =
*     IS_REPREP_ID                   =
*     I_SCREEN_START_COLUMN          = 0
*     I_SCREEN_START_LINE            = 0
*     I_SCREEN_END_COLUMN            = 0
*     I_SCREEN_END_LINE              = 0
*     IR_SALV_LIST_ADAPTER           =
*     IT_EXCEPT_QINFO                =
*     I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER        =
*     ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab                       =  lit_output                 " output table containing data
   EXCEPTIONS
     PROGRAM_ERROR                  = 1
     OTHERS                         = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.                    " DISPLAY_WKORDER_LIST
*&---------------------------------------------------------------------*
*&      Form  POPULATE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM populate_alv .

* Populating relevant columns for display in table

  lwa_fcat-col_pos = '1'.                         " colomn position
  lwa_fcat-fieldname = 'AUFNR_NEW'.               " field name
  lwa_fcat-tabname = 'lit_output'.                " table name
  lwa_fcat-outputlen = '60'.                      " length of the field


  APPEND lwa_fcat TO lit_fcat.                    " appending the changes to field catalog table


ENDFORM.                    " POPULATE_ALV
*&---------------------------------------------------------------------*
*&      Form  ALV_FORMAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_format .


* Formatting layout
  lwa_layout-zebra = 'X'.

* Function module for events

  IF r_list = c_x.                            "use the module only if alv dispaly as list is selected

    CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
*   EXPORTING
*     I_LIST_TYPE           = 0
     IMPORTING
       et_events             = lit_events     " table containing list of events
     EXCEPTIONS
       list_type_wrong       = 1
       OTHERS                = 2
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

* making changes to the events table by storing the form name containing the TITLE writing procedure
    READ TABLE lit_events INTO lwa_events WITH KEY name = 'TOP_OF_PAGE'.

    lwa_events-form = 'TITLE'.                            " form containing title writing code

    APPEND lwa_events TO lit_events.                " appending changes to events table

  ENDIF.


ENDFORM.                    " ALV_FORMAT
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_WKORDER_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_wkorder_grid .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     i_callback_program                 = sy-repid                      " calling program name
*     I_CALLBACK_PF_STATUS_SET          = ' '
     I_CALLBACK_USER_COMMAND           = 'INTERACT_ALV'                 " form handling interactive events
     i_callback_top_of_page            = 'TITLE'                        " form containing title writing code
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
     is_layout                          =  lwa_layout                   " work area containing layout changes
     it_fieldcat                        =  lit_fcat                     " field catalog containing table details
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =  lit_events
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = lit_output                       " output table containing data
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.                    " DISPLAY_WKORDER_GRID
*&---------------------------------------------------------------------*
*&      Form  TITLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM title .

* Writing title in alv

  lwa_title-typ = 'H'.
  lwa_title-info = 'WORK ORDER CREATION'.

  APPEND lwa_title TO lit_title.

  lwa_title-typ = 'S'.
  lwa_title-key = 'DATE : '.
  lwa_title-info = sy-datum.
  APPEND lwa_title TO lit_title.

* Function module to write title in alv

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lit_title
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .


ENDFORM.                    " TITLE
*&---------------------------------------------------------------------*
*&      Form  INTERACT_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM interact_alv USING r_syucomm LIKE sy-ucomm rs_selfield TYPE slis_selfield .

  " r_syucomm : contains value of the OK_CODE
  " rs_selfield : contains value of the field selected

  IF r_syucomm EQ '&IC1'.                                             " if there is a double click
    IF rs_selfield-fieldname = 'AUFNR_NEW'.                           " if AUFNR_NEW field is selected

      SET PARAMETER ID 'ANR' FIELD rs_selfield-value.                 " set the value of work order number parameter in trascation IW33
      CALL TRANSACTION 'IW33'.                                        " call transaction iw33.

      ENDIF.


  ENDIF.




ENDFORM.                    " INTERACT_ALV
