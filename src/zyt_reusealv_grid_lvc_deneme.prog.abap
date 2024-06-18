*&---------------------------------------------------------------------*
*& Report ZYT_REUSEALV_GRID_LVC_DENEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zyt_reusealv_grid_lvc_deneme.



********************************************* excel

*FORM export_excel.
** Filemanager support to locate file in a direct
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      program_name  = syst-cprog
*      dynpro_number = syst-dynnr
*      field_name    = 'P_FNAME'
*    IMPORTING
*      file_name     = p_fname.
*
*
*
*  DATA: lt_bintab   TYPE STANDARD TABLE OF solix,
*        lv_size     TYPE i,
*        lv_filename TYPE string.
*
*  SELECT * FROM mara
*    INTO TABLE @DATA(lt_mara)
*    UP TO 5 ROWS.
*
*  IF sy-subrc EQ 0.
*
** Get New Instance for ALV Table Object
*    cl_salv_table=>factory(
*      IMPORTING
*        r_salv_table   = DATA(lo_alv)
*      CHANGING
*        t_table        = lt_mara ).
*
** Convert ALV Table Object to XML
*    DATA(lv_xml) = lo_alv->to_xml( xml_type = '02' ).
*
** Convert XTRING to Binary
*    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*      EXPORTING
*        buffer        = lv_xml
*      IMPORTING
*        output_length = lv_size
*      TABLES
*        binary_tab    = lt_bintab.
*
*    lv_filename = p_fname.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.
*
** Download File
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
*        bin_filesize            = lv_size
*        filename                = lv_filename
*        filetype                = 'ASC'
*      TABLES
*        data_tab                = lt_bintab
*      EXCEPTIONS
*        file_write_error        = 1
*        no_batch                = 2
*        gui_refuse_filetransfer = 3
*        invalid_type            = 4
*        no_authority            = 5
*        unknown_error           = 6
*        header_not_allowed      = 7
*        separator_not_allowed   = 8
*        filesize_not_allowed    = 9
*        header_too_long         = 10
*        dp_error_create         = 11
*        dp_error_send           = 12
*        dp_error_write          = 13
*        unknown_dp_error        = 14
*        access_denied           = 15
*        dp_out_of_memory        = 16
*        disk_full               = 17
*        dp_timeout              = 18
*        file_not_found          = 19
*        dataprovider_exception  = 20
*        control_flush_error     = 21
*        OTHERS                  = 22.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*  ENDIF.
*
*  endform.
