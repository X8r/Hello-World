*&--------------------------------------------------------------------*
*& Report  ZPM_R_CREATENOTIF
*&
*&--------------------------------------------------------------------*
*&--------------------------------------------------------------------*
* Author          : Tejas Deshpande/C836062
* Creation Date   : 03/22/2018
* Transaction     : N.A
* Transport number: N.A (Local Object)
* Description     : Creating notificatin when data is uploaded from a text file
*---------------------------------------------------------------------*
*&
*&--------------------------------------------------------------------*

REPORT zpm_r_createnotif MESSAGE-ID zpm_createnotif.


***********************************************************************
"START OF INCLUDES
***********************************************************************

INCLUDE zpm_r_createnotif_top.                     " include containing data declarations
INCLUDE zpm_r_createnotif_scr.                     " include containing selection screen
INCLUDE zpm_r_createnotif_f01.                     " include containing code from performs

***********************************************************************
"END OF DATA INCLUDES
***********************************************************************

***********************************************************************
"START OF EVENTS
***********************************************************************


***********************************************************************
"INITIALIZATION EVENT
***********************************************************************
INITIALIZATION.
  CALL SELECTION-SCREEN 100.                       " calling selection screen to start processing

***********************************************************************
"AT SELECTION SCREEN & ITS VARIANTS EVENTS
***********************************************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_upfile. " event when value request is called for the parameter p_upfile
  PERFORM fetch_fileadd.                           " perform for value help for pointing path of text file

AT SELECTION-SCREEN.
  PERFORM validate_file.                           " validation to check whether file name is entered or not


***********************************************************************
"START OF SELECTION EVENT
***********************************************************************

START-OF-SELECTION.
  PERFORM fetch_filedata.                          " fetching file data into internal table and formatting it according to requirements
  IF r_alm EQ c_x.
  PERFORM create_notif.                            " calling BAPI_ALM_NOTIF_CREATE , saving created notification & committing it
  ELSEIF r_iqs4 EQ c_x.
  PERFORM create_notif_different_bapi.             " calling bapi IQS4_CREATE_NOTIFICATION
  ENDIF.
  PERFORM populate_alvdata.                        " populate data in alv format
  PERFORM formatting_alv.                          " display alv in appropriate format.


***********************************************************************
"END OF SELECTION EVENT
***********************************************************************

END-OF-SELECTION.
  IF r_grid EQ c_x.
     PERFORM display_filedata_grid.                " display data using ALV grid display
  ELSEIF r_list EQ c_x.
     PERFORM display_filedata_list.                " display data using ALV list display
  ENDIF.



******************************************************************************
"END OF EVENTS
******************************************************************************
