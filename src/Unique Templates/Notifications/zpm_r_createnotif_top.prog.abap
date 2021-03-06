*&--------------------------------------------------------------------*
*&  Include           ZPM_R_CREATENOTIF_TOP
*&--------------------------------------------------------------------*

***********************************************************************
 "START OF DATA DECLARATIONS
***********************************************************************


* Structures declarations * -------------------------------------------

 " structure for creating template for a table to to hold data from text file
 TYPES : BEGIN OF t_uptab,
        l_notif_typ(17)  TYPE c,
        l_notif_desc(24) TYPE c,
        l_priority(8)    TYPE c,
        l_text(15)       TYPE c,
        END OF t_uptab.

 " structure to hold all the notification types extracted from text file
 TYPES : BEGIN OF t_notif_type,
         l_notif_type    TYPE bapi2080-notif_type,
         END OF t_notif_type.

 " structure to hold final output data to be dispalyed via alv
 TYPES  : BEGIN OF t_alv_output,
           notif_no      TYPE bapi2080_nothdre-notif_no,
           notif_date    TYPE bapi2080_nothdre-notif_date,
           comments(50)  TYPE c,
           END OF t_alv_output.



* Internal Tables & Workareas declarations * --------------------------

 " table & work areato hold unformatted data from text file
 DATA : lit_uptab                 TYPE STANDARD TABLE OF t_uptab,
        lwa_uptab                 LIKE LINE OF lit_uptab.

 " tables and work areas to hold import , export , return data which is input & output to/from
 "  1.BAPI_ALM_NOTIF_CREATE
 "  2.BAPI_ALM_NOTIF_SAVE
 "  3.BAPI_TRANSACTION_COMMIT
 DATA : lit_notif_header_in       TYPE STANDARD TABLE OF bapi2080_nothdri,     " input table and work area to alm_notif_create bapi
        lwa_notif_header_in       TYPE bapi2080_nothdri,
        lit_notif_longtxt         TYPE STANDARD TABLE OF bapi2080_notfulltxti, " input tables and work area to hold long text to supply for notification creation
        lwa_notif_longtxt         TYPE bapi2080_notfulltxti,
        lit_notif_longtext2       TYPE STANDARD TABLE OF bapi2080_notfulltxti,
        lwa_notif_header_out_temp TYPE bapi2080_nothdre,                       " work area from storing temporary notification details
        lwa_notif_header_out      TYPE bapi2080_nothdre.                       " work area to hold information of notification created

 DATA : lit_notif_type            TYPE STANDARD TABLE OF t_notif_type,         " table & work area to hold notification type to be suppleid as input for creating notification
        lwa_notif_type            TYPE t_notif_type.


 DATA : lit_create_return         TYPE STANDARD TABLE OF bapiret2,             " table & work area to hold error information
        lwa_create_return         TYPE bapiret2,
        lit_save_return           TYPE STANDARD TABLE OF bapiret2,             " table & work area to hold error information
        lwa_save_return           TYPE bapiret2,
        lit_commit_return         TYPE STANDARD TABLE OF bapiret2,             " table & work area to hold error information
        lwa_commit_return         TYPE bapiret2.

 DATA : lit_iqs4notif_header_in   TYPE STANDARD TABLE OF riqs5,                " table & work area for iqs4 bapi input
        lwa_iqs4notif_header_in   LIKE LINE OF lit_iqs4notif_header_in,
        lit_iqs4notif_header_out  TYPE STANDARD TABLE OF VIQMEL,               " table & work area for iqs4 bapi output
        lwa_iqs4notif_header_out  LIKE LINE OF lit_iqs4notif_header_out.

 DATA : lit_fcat                  TYPE slis_t_fieldcat_alv,                    " table & work area to hold field catalog values
        lwa_fcat                  LIKE LINE OF lit_fcat,
        lit_events                TYPE slis_t_event,                           " table & work area to hold list of events and their relevant forms
        lwa_events                LIKE LINE OF lit_events,
        lit_header                TYPE slis_t_listheader,                      " table & work area to hold header values to be displayedi n top of page
        lwa_header                LIKE LINE OF lit_header,
        lwa_layout                TYPE slis_layout_alv.                        " work area to hold layour configuration values

 DATA : lit_alv_output            TYPE STANDARD TABLE OF t_alv_output,         " table & work area to hold data to be displayed via alv
        lwa_alv_output            LIKE LINE OF lit_alv_output.


* Variables & Constants declarations * --------------------------------

 DATA : lv_upfile       TYPE string.                                           " variable to hold path of text file

 DATA : lv_comments(50) TYPE c.                                                " variable to hold success message to be displayed when notification is successfully created
 lv_comments = text-001.
 DATA : lv_firstrow     TYPE i VALUE 1.                                        " variable to hold first row value i.e 1

 CONSTANTS  : c_x       TYPE c VALUE 'X'.                                      " contstant to hold value of 'X'.



***********************************************************************
 "END OF DATA DECLARATIONS
***********************************************************************
