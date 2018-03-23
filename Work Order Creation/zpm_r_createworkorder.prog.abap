*&--------------------------------------------------------------------*
*& Report  ZPM_R_CREATEWORKORDER
*&
*&--------------------------------------------------------------------*
*&--------------------------------------------------------------------*
* Author          : Tejas Deshpande/C836062
* Creation Date   : 04/08/2015
* Transaction     : N.A
* Transport number: N.A (Local Object)
* Description     : Creating work order when notification number & Type are specified
*---------------------------------------------------------------------*
*&
*&--------------------------------------------------------------------*

REPORT zpm_r_createworkorder MESSAGE-ID ZPM_CREATEWORKORDER.

***********************************************************************
"START OF INCLUDES
***********************************************************************

INCLUDE zpm_r_createworkorder_top.        " include containing data declarations
INCLUDE zpm_r_createworkorder_scr.        " include containing selection screen
INCLUDE zpm_r_createworkorder_f01.        " include containing code from performs

***********************************************************************
"START OF EVENTS
***********************************************************************

***********************************************************************
"INITIALIZATION EVENT
***********************************************************************

INITIALIZATION.
  CALL SELECTION-SCREEN 100.              " calling selection screen to start processing

***********************************************************************
"AT SELECTION SCREEN & ITS VARIANTS EVENTS
***********************************************************************

***********************************************************************
"START OF SELECTION EVENT
***********************************************************************

START-OF-SELECTION.
  PERFORM fetch_data.                     " fetching DDIC data based on screen input into DDIC tables
  PERFORM create_wkorder.                 " creating a work order based on screen input
  PERFORM populate_alv.                   " populating field catalog with relevant colomns
  PERFORM alv_format.                     " formatiing layout , events etc.

***********************************************************************
"END OF SELECTION EVENT
***********************************************************************

END-OF-SELECTION.
  IF r_list = c_x.                        " if user selects list
    PERFORM  display_wkorder_list.        " display alv as a list
  ELSEIF r_grid = c_x.                    " if user selects grid
    PERFORM display_wkorder_grid.         " display alv as a grid
  ENDIF.


************************************************************************
"END OF EVENTS
************************************************************************
