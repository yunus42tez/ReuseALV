*&---------------------------------------------------------------------*
*&  Include           ZYT_SFILIZ_SE_LOOP_ALV_PAI
*&---------------------------------------------------------------------*

FORM user_command USING p_ucomm    TYPE sy-ucomm
                        p_selfield TYPE slis_selfield.

  DATA: lv_vbeln TYPE vbrp-vbeln,
        lv_posnr TYPE vbrp-posnr.
  DATA: lv_answer TYPE c.
  DATA: lv_message TYPE string.

  CASE p_ucomm.
    WHEN '&IC1'.
      IF p_sip = 'X'.
        READ TABLE gt_lips INTO gs_lips WITH KEY p_selfield-fieldname.
        IF p_selfield-fieldname = 'VBELN'.
          SET PARAMETER ID 'AUN' FIELD p_selfield-value.
          CALL TRANSACTION 'VA03'.
        ENDIF.
      ENDIF.
      IF p_tes = 'X'.
        READ TABLE gt_lips INTO gs_lips WITH KEY p_selfield-fieldname.
        IF p_selfield-fieldname = 'MATNR'.
          SET PARAMETER ID 'MAT' FIELD p_selfield-value.
          CALL TRANSACTION 'MM03'.
        ENDIF.
      ENDIF.
      IF p_fat = 'X'.
        READ TABLE gt_lips INTO gs_lips WITH KEY p_selfield-fieldname.
        IF p_selfield-fieldname = 'VBELN'.
          SET PARAMETER ID 'VF' FIELD p_selfield-value.
          CALL TRANSACTION 'VF03'.
        ENDIF.
      ENDIF.
    WHEN '&EXCEL'.

      " gerekli olursa doldur - standard statustaki excel import iş görüyor.

      TYPES: BEGIN OF lty_header,
               line(30) TYPE c,
             END OF lty_header.

      DATA: lv_filename TYPE string.

      DATA: gt_header TYPE TABLE OF lty_header,
            gs_header TYPE lty_header.


      CALL METHOD cl_gui_frontend_services=>directory_browse
        CHANGING
          selected_folder      = p_path
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
        EXPORTING
          titel     = 'Excelin İndirileceği Dosya Yolu'
          textline1 = p_path.


      CONCATENATE p_path
                  '\'
                  sy-datum
                  '-'
                  sy-uzeit
                  '.xls'
      INTO lv_filename.

      IF p_sip = 'X'.

        SELECT
        a~vbeln
        a~erdat
        b~posnr
        b~matnr
        b~matkl
        b~netwr
        c~wgbez
  FROM vbak AS a
   INNER JOIN vbap AS b ON a~vbeln = b~vbeln
   INNER JOIN t023t AS c ON b~matkl = c~matkl
   AND c~spras EQ 'T'
  INTO CORRESPONDING FIELDS OF TABLE gt_vbap_excel
  WHERE a~vbeln IN s_vbelns
  AND   a~erdat IN s_erdat.

        gs_header-line = 'SATIŞ BELGESİ'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'KAYIT TARİHİ'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'KALEM'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'MALZEME'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'MAL GRUBU'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'NET DEĞER'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'MAL GRUBU TANIMI'.
        APPEND gs_header TO gt_header.
        CLEAR gs_header.

        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
            filename              = lv_filename
            filetype              = 'ASC'
            write_field_separator = 'X'
          TABLES
            data_tab              = gt_vbap_excel
            fieldnames            = gt_header.

      ELSEIF p_tes = 'X'.

        IF p_loekz = ' '.

          SELECT
          a~vbeln
          a~erdat
          a~vkorg
          b~posnr
          b~matnr
          b~lfimg
    FROM likp AS a
    INNER JOIN lips AS b ON a~vbeln = b~vbeln
    INTO CORRESPONDING FIELDS OF TABLE gt_lips_excel
    WHERE a~vbeln IN s_vbelnt
    AND   a~erdat IN s_erdat.


          gs_header-line = 'TESLİMAT'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'KAYIT TARİHİ'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'SATIŞ ORGANİZASYONU'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'KALEM'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'MALZEME'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'TESLİMAT MİKTARI'.
          APPEND gs_header TO gt_header.
          CLEAR gs_header.

          CALL FUNCTION 'GUI_DOWNLOAD'
            EXPORTING
              filename              = lv_filename
              filetype              = 'ASC'
              write_field_separator = 'X'
            TABLES
              data_tab              = gt_lips_excel
              fieldnames            = gt_header.


        ELSEIF p_loekz = 'X'.

          SELECT
           a~vbeln
           a~erdat
           a~spe_loekz
           a~vkorg
           b~posnr
           b~matnr
           b~lfimg
      FROM likp AS a
      INNER JOIN lips AS b ON a~vbeln = b~vbeln
      INTO CORRESPONDING FIELDS OF TABLE gt_lips_chx_excel
      WHERE a~vbeln IN s_vbelnt
      AND   a~erdat IN s_erdat.

          gs_header-line = 'TESLİMAT'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'KAYIT TARİHİ'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'BELGE SİLME GÖSTERGESİ'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'SATIŞ ORGANİZASYONU'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'KALEM'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'MALZEME'.
          APPEND gs_header TO gt_header.
          gs_header-line = 'TESLİMAT MİKTARI'.
          APPEND gs_header TO gt_header.
          CLEAR gs_header.

          CALL FUNCTION 'GUI_DOWNLOAD'
            EXPORTING
              filename              = lv_filename
              filetype              = 'ASC'
              write_field_separator = 'X'
            TABLES
              data_tab              = gt_lips_chx_excel
              fieldnames            = gt_header.

        ENDIF.

      ELSEIF p_fat = 'X'.

        SELECT
        a~vbeln
        a~erdat
        a~fkart
        b~fkimg
  FROM vbrk AS a
   INNER JOIN vbrp AS b ON a~vbeln = b~vbeln
  INTO CORRESPONDING FIELDS OF TABLE gt_vbrp_excel
   WHERE a~vbeln IN s_vbelnf
   AND   a~erdat IN s_erdat.


        gs_header-line = 'TESLİMAT'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'KAYIT TARİHİ'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'FATURALAMA'.
        APPEND gs_header TO gt_header.
        gs_header-line = 'FATURALANAN MİKTAR'.
        APPEND gs_header TO gt_header.
        CLEAR gs_header.

        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
            filename              = lv_filename
            filetype              = 'ASC'
            write_field_separator = 'X'
          TABLES
            data_tab              = gt_vbrp_excel
            fieldnames            = gt_header.

      ENDIF.

    WHEN '&POPUP'.

      DATA: lt_popup TYPE vbrp.

      READ TABLE gt_vbrp INTO gs_vbrp INDEX p_selfield-tabindex.
      IF sy-subrc = 0.
        lv_vbeln = gs_vbrp-vbeln.

        SELECT SINGLE vbeln posnr
        FROM vbrp
        INTO CORRESPONDING FIELDS OF lt_popup
        WHERE vbeln EQ lv_vbeln.

        lv_posnr = lt_popup-posnr.

        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'STATÜ DEĞİŞTİRMEK İÇİN SEÇİM YAPINIZ'
            text_question         = |VBELN: { lv_vbeln } , POSNR:  { lv_posnr }.|
            text_button_1         = 'Evet'
            text_button_2         = 'Hayır'
            display_cancel_button = 'X'
          IMPORTING
            answer                = lv_answer.

        CASE lv_answer.
          WHEN '1'.
            gs_vbrp-traffic = '@08@'. " Green
          WHEN '2'.
            gs_vbrp-traffic = '@0A@'. " Red
          WHEN 'A'.
            gs_vbrp-traffic = '@09@'. " Yellow
        ENDCASE.
        MODIFY gt_vbrp FROM gs_vbrp INDEX p_selfield-tabindex.
        PERFORM call_alv_grid_vbrp.
      ENDIF.
  ENDCASE.

ENDFORM.

* data: ls_row_id type lvc_s_row.
*  data: ls_col_id type lvc_s_col.
*  data: l_value type lvc_s_data-value.
*  data: ls_selfield type lvc_s_self.
*  data: ls_fieldcat type slis_fieldcat_alv.
*  data: ls_fieldcat_lvc type lvc_s_fcat.
*
*    call method gt_grid-grid->get_current_cell
*    importing
*      es_row_id = ls_row_id
*      es_col_id = ls_col_id
*      e_value   = l_value.
*  call method cl_gui_cfw=>flush.
*  ls_selfield-s_row_id = ls_row_id.
*  ls_selfield-s_col_id = ls_col_id.
*  ls_selfield-value    = l_value.
