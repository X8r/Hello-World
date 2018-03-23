*&---------------------------------------------------------------------*
*&  Include           ZPM_R_CREATEWORKORDER_SCR
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF SCREEN 100.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-000.

     PARAMETERS : p_notif TYPE QMEL-QMNUM ,       " parameter containing notification number
                  p_odrtyp TYPE AUFK-AUART OBLIGATORY.      " parameter containing order type

  SELECTION-SCREEN END OF BLOCK b1.

  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-001.

      PARAMETERS : r_grid RADIOBUTTON GROUP g1,             " show output as a list
                   r_list RADIOBUTTON GROUP g1.             " show output as a grid

  SELECTION-SCREEN END OF BLOCK b2.

  SELECTION-SCREEN END OF SCREEN 100.
