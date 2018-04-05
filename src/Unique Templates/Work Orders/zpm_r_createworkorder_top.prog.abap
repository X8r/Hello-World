*&---------------------------------------------------------------------*
*&  Include           ZPM_R_CREATEWORKORDER_TOP
*&---------------------------------------------------------------------*


***********************************************************************
"START OF DATA DECLARATIONS
***********************************************************************


* Structures declarations * -------------------------------------------



* Internal Tables & Workareas declarations * --------------------------

DATA : lit_method_table TYPE STANDARD TABLE OF bapi_alm_order_method,     " table & work area to hold methods
       lwa_method_table LIKE LINE OF lit_method_table,
       lit_header       TYPE STANDARD TABLE OF bapi_alm_order_headers_i,  " table & work area to hold bapi header information
       lwa_header       LIKE LINE OF lit_header,
       lit_operation    TYPE STANDARD TABLE OF bapi_alm_order_operation,  " table & work area to hold operation inofrmation
       lwa_operation    LIKE LINE OF lit_operation,
       lit_textlines type STANDARD TABLE OF BAPI_ALM_TEXT_LINES,
       lit_output       TYPE STANDARD TABLE OF bapi_alm_numbers.          " table to hold created work order number

DATA : lit_return       TYPE STANDARD TABLE OF bapiret2,                  " table & work area to hold erros if any
       lwa_return       LIKE LINE OF lit_return.

data : lit_fcat         TYPE slis_t_fieldcat_alv,                         " table & work area to hold field catalog details
       lwa_fcat         LIKE LINE OF lit_fcat,
       lit_events       TYPE slis_t_event,                                " table & work area to hold details of events used in alv
       lwa_events       LIKE LINE OF lit_events,
       lit_title        TYPE slis_t_listheader,                           " table & work area to hold details of title
       lwa_title        LIKE LINE OF lit_title,
       lwa_layout       TYPE slis_layout_alv.                             " work area to hold layout details

DATA : lwa_qmel         TYPE  qmel,                                       " work area to hold notification details
       lwa_crhd         TYPE crhd.                                        " work area to hold work center & planning plant details


* Variables & Constants declarations * --------------------------------

DATA : c_x              TYPE c VALUE 'X',                                 " variable to hold value 'X'.
       c_one            TYPE c VALUE '1'.                                 " variable to hold value '1'.

DATA : lv_tplnr         TYPE iloa-tplnr,                                  " variable to hold value of TPLNR.
       lv_iloan         TYPE qmih-iloan.                                  " variable to hold value of ILOAN.
