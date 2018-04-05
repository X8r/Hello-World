*&---------------------------------------------------------------------*
*& Report Z_OOOPS_ALV_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_OOOPS_ALV_REPORT.


TABLES: MARA.

TYPE-POOLS: SLIS, ICON.

* Internal Tables
DATA: BEGIN OF IALV OCCURS 0,
      MATNR TYPE MARA-MATNR,
      MAKTX TYPE MAKT-MAKTX,
      END OF IALV .

DATA: ALV_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      ALV_GRID TYPE REF TO CL_GUI_ALV_GRID,
      OK_CODE LIKE SY-UCOMM,
      FIELDCAT TYPE LVC_T_FCAT.

SELECT-OPTIONS: S_MATNR FOR MARA-MATNR.

START-OF-SELECTION.

  SELECT MARA~MATNR MAKT~MAKTX
             INTO CORRESPONDING FIELDS OF TABLE IALV
                 FROM MARA
                      INNER JOIN MAKT
                         ON MARA~MATNR = MAKT~MATNR
                                WHERE MARA~MATNR IN S_MATNR
                                  AND MAKT~SPRAS = SY-LANGU.

  SORT IALV ASCENDING BY MATNR.

  IF IALV[] IS INITIAL.
    MESSAGE S429(MO).
    EXIT.
  ENDIF.

  CALL SCREEN 100.

************************************************************************
*      Module  status_0100  OUTPUT
************************************************************************
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.


* Create Controls
  CREATE OBJECT ALV_CONTAINER
         EXPORTING CONTAINER_NAME = 'ALV_CONTAINER'.

  CREATE OBJECT ALV_GRID
         EXPORTING  I_PARENT =  ALV_CONTAINER.

*  Populate Field Catalog
  PERFORM GET_FIELDCATALOG.


  CALL METHOD ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      CHANGING
           IT_OUTTAB       = IALV[]
           IT_FIELDCATALOG = FIELDCAT[].


ENDMODULE.

************************************************************************
*      Module  USER_COMMAND_0100  INPUT
************************************************************************
MODULE USER_COMMAND_0100 INPUT.

  CASE SY-UCOMM.

    WHEN 'BACK' OR 'CANC' or 'EXIT'.
        LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.


************************************************************************
*      Form  Get_Fieldcatalog - Set Up Columns/Headers
************************************************************************
FORM GET_FIELDCATALOG.

  DATA: LS_FCAT TYPE LVC_S_FCAT.

  REFRESH: FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Material Number'.
  LS_FCAT-FIELDNAME  = 'MATNR'.
  LS_FCAT-REF_TABLE  = 'IALV'.
  LS_FCAT-OUTPUTLEN  = '18'.
  APPEND LS_FCAT TO FIELDCAT.

  CLEAR: LS_FCAT.
  LS_FCAT-REPTEXT    = 'Material Description'.
  LS_FCAT-FIELDNAME  = 'MAKTX'.
  LS_FCAT-REF_TABLE  = 'IALV'.
  LS_FCAT-OUTPUTLEN  = '40'.
  APPEND LS_FCAT TO FIELDCAT.

ENDFORM.
