*&---------------------------------------------------------------------*
*&  Include           ZYT_SFLZ_EVENTS_FRM
*&---------------------------------------------------------------------*

FORM get_data_p_sip.

  SELECT a~vbeln
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
   INTO CORRESPONDING FIELDS OF TABLE gt_vbap
   WHERE a~vbeln IN s_vbelns
   AND   a~erdat IN s_erdat.

ENDFORM.

FORM get_data_p_tes.

  SELECT a~vbeln
         a~erdat
         a~vkorg
         b~posnr
         b~matnr
         b~lfimg
    FROM likp AS a
    INNER JOIN lips AS b ON a~vbeln = b~vbeln
    INTO CORRESPONDING FIELDS OF TABLE gt_lips
    WHERE a~vbeln IN s_vbelnt
    AND   a~erdat IN s_erdat.
  LOOP AT gt_lips INTO gs_lips.
    IF p_refval IS INITIAL OR p_refval < gs_lips-lfimg.
      gs_lips-traffic =  '@09@'. "Sarı ışık
    ELSEIF p_refval IS NOT INITIAL AND p_refval > gs_lips-lfimg.
      gs_lips-traffic = '@08@'. "yeşil ışık
    ENDIF.
    MODIFY gt_lips FROM gs_lips.
  ENDLOOP.

ENDFORM.

FORM get_data_p_tes_chx.

  SELECT a~vbeln
         a~erdat
         a~spe_loekz
         a~vkorg
         b~posnr
         b~matnr
         b~lfimg
    FROM likp AS a
    INNER JOIN lips AS b ON a~vbeln = b~vbeln
    INTO CORRESPONDING FIELDS OF TABLE gt_lips_chx
    WHERE a~vbeln IN s_vbelnt
    AND   a~erdat IN s_erdat.
  LOOP AT gt_lips_chx INTO gs_lips_chx.
    IF p_refval IS INITIAL OR p_refval < gs_lips_chx-lfimg.
      gs_lips_chx-traffic =  '@09@'. "Sarı ışık
    ELSEIF p_refval IS NOT INITIAL AND p_refval > gs_lips_chx-lfimg.
      gs_lips_chx-traffic = '@08@'. "yeşil ışık
    ENDIF.
    MODIFY gt_lips_chx FROM gs_lips_chx.
  ENDLOOP.


ENDFORM.

FORM get_data_p_fat.

  SELECT a~vbeln
         a~erdat
         a~fkart
         b~fkimg
   FROM vbrk AS a
    INNER JOIN vbrp AS b ON a~vbeln = b~vbeln
   INTO CORRESPONDING FIELDS OF TABLE gt_vbrp
    WHERE a~vbeln IN s_vbelnf
    AND   a~erdat IN s_erdat.

ENDFORM.

FORM at_sel_screen_output_frm.

  LOOP AT SCREEN.

    IF screen-name = 'P_DATUM'.
      screen-input = sy-datum.
      MODIFY SCREEN.
    ENDIF.

    IF screen-name = 'P_LOEKZ'.
      IF p_tes EQ ' '.
        screen-active = 1.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.


    ELSEIF p_sip EQ 'X' AND screen-group1 = 'ABC'.
      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF p_tes EQ 'X' AND screen-group1 = '123'.
      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.
    ELSEIF p_fat EQ 'X' AND screen-group1 = 'XYZ'.
      screen-active = 1.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF p_sip EQ ' ' AND screen-group1 = 'ABC'.
      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF p_tes EQ ' ' AND screen-group1 = '123'.
      screen-active = 0.
      screen-input = 0.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF p_fat EQ ' ' AND screen-group1 = 'XYZ'.
      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.

    ENDIF.

  ENDLOOP.

ENDFORM.

FORM set_specific_field_attributes . "for editable 'NETWR'
  DATA ls_stylerow TYPE lvc_s_styl .
  DATA lt_styletab TYPE lvc_t_styl .


  LOOP AT gt_vbap INTO gs_vbap.
    IF gs_vbap-netwr >= p_refval.
      ls_stylerow-fieldname = 'NETWR' .
      ls_stylerow-style = cl_gui_alv_grid=>mc_style_disabled.
      "set field to disabled
      APPEND ls_stylerow  TO gs_vbap-field_style.
      MODIFY gt_vbap FROM gs_vbap.
    ENDIF.
  ENDLOOP.

ENDFORM.

****************************  ALV  ***************************

FORM: pf_status_set USING extab TYPE slis_t_extab.

  SET PF-STATUS 'STANDARD'.

  IF p_fat = 'X'.

    SET PF-STATUS 'STANDARD_VBRP'.

  ENDIF.

ENDFORM.

FORM set_layout.

  ls_layout-zebra             = abap_true.
  ls_layout-colwidth_optimize = abap_true.

ENDFORM.

FORM set_layout_lvc.

  ls_layout_lvc-stylefname = 'FIELD_STYLE'.
  ls_layout_lvc-zebra      = abap_true.
  ls_layout_lvc-cwidth_opt = abap_true.

ENDFORM.


FORM set_layout_with_color. " renksiz alvde hata alır.

  ls_layout-zebra    = abap_true.
  ls_layout-colwidth_optimize = abap_true.
  ls_layout-info_fieldname    = 'LINE_COLOR'.
  ls_layout-coltab_fieldname  = 'CELL_COLOR'.

ENDFORM.

FORM calculate_sub_total .
  IF p_sip = 'X'.
    gs_sort_lvc-fieldname = 'MATNR'.
    gs_sort_lvc-up = 'X'.
    gs_sort_lvc-group = 'X'.
    gs_sort_lvc-subtot = 'X'.
    APPEND gs_sort_lvc TO gt_sort_lvc.
  ENDIF.
  IF p_tes = 'X'.
    gs_sort-fieldname = 'VKORG'.
    gs_sort-up = 'X'.
    gs_sort_lvc-group = 'X'.
    gs_sort-subtot = 'X'.
    APPEND gs_sort TO gt_sort.
  ENDIF.
  IF p_fat = 'X'.
    gs_sort-fieldname = 'FKART'.
    gs_sort-up = 'X'.
    gs_sort_lvc-group = 'X'.
    gs_sort-subtot = 'X'.
    APPEND gs_sort TO gt_sort.
  ENDIF.
ENDFORM.


**************************************************** VBAK - VBAP - REUSE_ALV_GRID_DISPLAY_LVC


*FORM call_merge_vbak.
*  DATA: ls_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
*
*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_program_name         = sy-cprog
*      i_structure_name       = 'ZYT_EVENTS_STRUC_VBAP'
*    CHANGING
*      ct_fieldcat            = gt_fieldcat
*    EXCEPTIONS
*      inconsistent_interface = 1
*      program_error          = 2
*      OTHERS                 = 3.
*  DATA: lv_col_pos TYPE i.
*  lv_col_pos = lv_col_pos + 1.
*  LOOP AT gt_fieldcat INTO ls_fieldcat .
*    CASE ls_fieldcat-fieldname .
*      WHEN 'VBELN'.
*        ls_fieldcat-seltext_l    = 'Satış belgesi'.
*        ls_fieldcat-outputlen    = 20.
*        ls_fieldcat-col_pos      = lv_col_pos.
**      WHEN 'ERDAT'.
**        ls_fieldcat-seltext_l    = 'Kaydın yaratıldığı tarih'.
**        ls_fieldcat-outputlen    = 10.
**        ls_fieldcat-col_pos      = lv_col_pos.
*      WHEN 'POSNR'.
*        ls_fieldcat-outputlen    = 10.
*        ls_fieldcat-col_pos      = lv_col_pos.
*      WHEN 'MATNR'.
*        ls_fieldcat-outputlen    = 10.
*        ls_fieldcat-col_pos      = lv_col_pos.
*      WHEN 'MATKL'.
*        ls_fieldcat-outputlen    = 10.
*        ls_fieldcat-col_pos      = lv_col_pos.
*      WHEN 'WGBEZ'.
*        gs_fieldcat_lvc-outputlen    = 40.
*        gs_fieldcat_lvc-col_pos      = lv_col_pos.
*      WHEN 'NETWR'.
*        ls_fieldcat-outputlen    = 10.
*        ls_fieldcat-col_pos      = lv_col_pos.
*        ls_fieldcat-do_sum      = 'X'.
*        IF p_refval IS NOT INITIAL. " Giriş ekranındaki P_REFVAL değeri girilmişse ve bundan küçük olanların NETWR alanları editable gelecek
*          ls_fieldcat-edit = 'X'.
*        ENDIF.
*      WHEN OTHERS.
*        ls_fieldcat-no_out       = 'X'.
*    ENDCASE.
*    CLEAR ls_fieldcat-key.
*    ls_fieldcat-seltext_m    = ls_fieldcat-seltext_l.
*    ls_fieldcat-seltext_s    = ls_fieldcat-seltext_l.
*    ls_fieldcat-reptext_ddic = ls_fieldcat-seltext_l.
*    MODIFY gt_fieldcat FROM ls_fieldcat .
*  ENDLOOP.
*
*ENDFORM.
*
*FORM call_alv_grid_vbak.
*
*  DATA: lv_lines      TYPE i,
*        lv_slines(10) TYPE c,
*        lv_title      TYPE lvc_title.
**** Total records
*  DESCRIBE TABLE gt_vbap LINES lv_lines.
*  lv_slines = lv_lines.
*  CONDENSE lv_slines.
*  CONCATENATE 'Toplam' lv_slines 'kayıt mevcut'
*         INTO lv_title SEPARATED BY space.
*
*  IF lv_slines = 0.
*    lv_title = 'Uygun veri bulunamadı'.
*  ENDIF.
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program       = sy-repid
*      i_callback_pf_status_set = 'PF_STATUS_SET'
*      i_callback_user_command  = 'USER_COMMAND'
*      i_grid_title             = lv_title
*      is_layout                = ls_layout
*      it_fieldcat              = gt_fieldcat[]
*      i_default                = 'X'
*    TABLES
*      t_outtab                 = gt_vbap[]
*    EXCEPTIONS
*      program_error            = 1
*      OTHERS                   = 2.
*  IF sy-subrc = 0.
*    "do nothing
*  ENDIF.
*
*ENDFORM.

****************************************************************** LVC ALV GRID

FORM call_merge_vbak.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZYT_EVENTS_STRUC_VBAP'
    CHANGING
      ct_fieldcat            = gt_fieldcat_lvc
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  DATA: lv_col_pos TYPE i.
  lv_col_pos = lv_col_pos + 1.
  LOOP AT  gt_fieldcat_lvc INTO gs_fieldcat_lvc.
    CASE gs_fieldcat_lvc-fieldname.
      WHEN 'VBELN'.
        gs_fieldcat_lvc-scrtext_l    = 'Satış belgesi'.
        gs_fieldcat_lvc-outputlen    = 10.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
        gs_fieldcat_lvc-hotspot      = 'X'.
        gs_fieldcat_lvc-emphasize    = 'X'.
        gs_fieldcat_lvc-key          = 'X'.
      WHEN 'ERDAT'.
        gs_fieldcat_lvc-scrtext_l    = 'Kaydın yaratıldığı tarih'.
        gs_fieldcat_lvc-outputlen    = 40.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
      WHEN 'POSNR'.
        gs_fieldcat_lvc-outputlen    = 10.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
      WHEN 'MATNR'.
        gs_fieldcat_lvc-outputlen    = 10.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
      WHEN 'MATKL'.
        gs_fieldcat_lvc-outputlen    = 10.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
      WHEN 'WGBEZ'.
        gs_fieldcat_lvc-outputlen    = 40.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
      WHEN 'NETWR'.
        gs_fieldcat_lvc-outputlen    = 40.
        gs_fieldcat_lvc-col_pos      = lv_col_pos.
        gs_fieldcat_lvc-edit = 'X'.
        gs_fieldcat_lvc-do_sum       = 'X'.
        IF p_refval IS NOT INITIAL. " Giriş ekranındaki P_REFVAL değeri girilmişse ve bundan küçük olanların NETWR alanları editable gelecek
          gs_fieldcat_lvc-edit = 'X'.
        ENDIF.
      WHEN OTHERS.
        gs_fieldcat_lvc-no_out       = 'X'.
    ENDCASE.
    CLEAR gs_fieldcat_lvc-key.
    gs_fieldcat_lvc-scrtext_m    = gs_fieldcat_lvc-scrtext_l.
    gs_fieldcat_lvc-scrtext_s    = gs_fieldcat_lvc-scrtext_l.
    gs_fieldcat_lvc-reptext      = gs_fieldcat_lvc-scrtext_l.
    MODIFY gt_fieldcat_lvc FROM gs_fieldcat_lvc.

  ENDLOOP.
ENDFORM.



*FORM call_merge_vbak. " MERGE OLMADAN MANUEL FİELDCATALOG - message type x dumpı sonucu değişmedi!
*
*  gs_fieldcat_lvc-fieldname   = 'VBELN'.
*  gs_fieldcat_lvc-scrtext_m   = 'SATIŞ BELGESİ'.
*  gs_fieldcat_lvc-col_pos     = 0.
*  gs_fieldcat_lvc-outputlen   = 10.
* " gs_fieldcat_lvc-emphasize   = 'X'.
*  "gs_fieldcat_lvc-key         = 'X'.
* " gs_fieldcat_lvc-hotspot   = 'X'.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*  gs_fieldcat_lvc-fieldname   = 'ERDAT'.
*  gs_fieldcat_lvc-scrtext_l    = 'Kaydın yaratıldığı tarih'.
*  gs_fieldcat_lvc-outputlen    = 10.
*  gs_fieldcat_lvc-col_pos      = 1.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*  gs_fieldcat_lvc-fieldname   = 'POSNR'.
*  gs_fieldcat_lvc-scrtext_m   = 'KALEM'.
*  gs_fieldcat_lvc-col_pos     = 2.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*  gs_fieldcat_lvc-fieldname   = 'MATNR'.
*  gs_fieldcat_lvc-scrtext_m   = 'MALZEME'.
*  gs_fieldcat_lvc-col_pos     = 3.
*  gs_fieldcat_lvc-outputlen = 20.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*  gs_fieldcat_lvc-fieldname   = 'MATKL'.
*  gs_fieldcat_lvc-scrtext_m   = 'MAL GRUBU'.
*  gs_fieldcat_lvc-col_pos     = 4.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*  gs_fieldcat_lvc-fieldname   = 'WGBEZ'.
*  gs_fieldcat_lvc-scrtext_m   = 'MAL GRP. TANIMI'.
*  gs_fieldcat_lvc-col_pos     = 5.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*  gs_fieldcat_lvc-fieldname   = 'NETWR'.
*  gs_fieldcat_lvc-scrtext_m   = 'NET TUTAR'.
*  gs_fieldcat_lvc-col_pos     = 6.
*  gs_fieldcat_lvc-outputlen = 15.
*  "gs_fieldcat_lvc-do_sum = 'X'.
*  IF p_refval IS NOT INITIAL.
*    gs_fieldcat_lvc-edit = 'X'.  " NETWR alanını düzenlenebilir yap
*  ENDIF.
*  APPEND gs_fieldcat_lvc TO gt_fieldcat_lvc.
*  CLEAR  gs_fieldcat_lvc.
*
*ENDFORM.

FORM call_alv_grid_vbak.

  DATA: lv_lines      TYPE i,
        lv_slines(10) TYPE c,
        lv_title      TYPE lvc_title.
*** Total records
  DESCRIBE TABLE gt_vbap LINES lv_lines.
  lv_slines = lv_lines.
  CONDENSE lv_slines.
  CONCATENATE 'Toplam' lv_slines 'kayıt mevcut'
         INTO lv_title SEPARATED BY space.

  IF lv_slines = 0.
    lv_title = 'Uygun veri bulunamadı'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = lv_title
      is_layout_lvc            = ls_layout_lvc
      it_fieldcat_lvc          = gt_fieldcat_lvc
      it_sort_lvc              = gt_sort_lvc
      i_save                   = 'X'
    TABLES
      t_outtab                 = gt_vbap[]
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.





**************************************************** LIKP - LIPS
***Line renklendirme alanı.

FORM set_line_color.
  IF p_refval IS NOT INITIAL.
    LOOP AT gt_lips INTO gs_lips.
      IF gs_lips-lfimg < p_refval.
        gs_lips-line_color = 'C510'.
      ENDIF.
      IF gs_lips-lfimg > p_refval.
        gs_lips-line_color = 'C310'.
      ENDIF.
      MODIFY gt_lips FROM gs_lips.
    ENDLOOP.
  ENDIF.

  IF p_refval IS INITIAL.
    LOOP AT gt_lips INTO gs_lips.
      gs_lips-line_color = 'C310'.
      MODIFY gt_lips FROM gs_lips.
    ENDLOOP.
  ENDIF.

ENDFORM.



FORM call_merge_likp.
  DATA: ls_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-cprog
      i_structure_name       = 'ZYT_EVENTS_STRUC_LIPS_CHX'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  DATA: lv_col_pos TYPE i.
  lv_col_pos = lv_col_pos + 1.
  LOOP AT gt_fieldcat INTO ls_fieldcat .
    CASE ls_fieldcat-fieldname .
      WHEN 'VBELN'.
        ls_fieldcat-seltext_l    = 'Teslimat'.
        ls_fieldcat-outputlen    = 20.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-hotspot      = 'X'.
        ls_fieldcat-emphasize    = 'X'.
      WHEN 'ERDAT'.
        ls_fieldcat-seltext_l    = 'Kaydın yaratıldığı tarih'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-hotspot         = 'X'.
      WHEN 'VKORG'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'POSNR'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'MATNR'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-emphasize    = 'X'.
        ls_fieldcat-hotspot      = 'X'. "hotspotlu olacak ve tıklanınca MM03 ekranı gelecek
      WHEN 'LFIMG'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-do_sum       = 'X'.
      WHEN 'TRAFFIC'.
        ls_fieldcat-seltext_l    = 'Statü'.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN OTHERS.
        ls_fieldcat-no_out       = 'X'.
    ENDCASE.
    CLEAR ls_fieldcat-key.
    ls_fieldcat-seltext_m    = ls_fieldcat-seltext_l.
    ls_fieldcat-seltext_s    = ls_fieldcat-seltext_l.
    ls_fieldcat-reptext_ddic = ls_fieldcat-seltext_l.
    MODIFY gt_fieldcat FROM ls_fieldcat .
  ENDLOOP.

ENDFORM.

FORM call_alv_grid_likp.

  DATA: lv_lines      TYPE i,
        lv_slines(10) TYPE c,
        lv_title      TYPE lvc_title.
*** Total records
  DESCRIBE TABLE gt_lips LINES lv_lines.
  lv_slines = lv_lines.
  CONDENSE lv_slines.
  CONCATENATE 'Toplam' lv_slines 'kayıt mevcut'
         INTO lv_title SEPARATED BY space.

  IF lv_slines = 0.
    lv_title = 'Uygun veri bulunamadı'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = lv_title
      is_layout                = ls_layout
      it_fieldcat              = gt_fieldcat[]
      it_sort                  = gt_sort
      i_default                = 'X'
    TABLES
      t_outtab                 = gt_lips[]
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc = 0.
    "do nothing
  ENDIF.

ENDFORM.
************************************************************* likp with checkbox parameter

FORM call_merge_likp_chx.
  DATA: ls_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-cprog
      i_structure_name       = 'ZYT_EVENTS_STRUC_LIPS_CHX'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  DATA: lv_col_pos TYPE i.
  lv_col_pos = lv_col_pos + 1.
  LOOP AT gt_fieldcat INTO ls_fieldcat .
    CASE ls_fieldcat-fieldname .
      WHEN 'VBELN'.
        ls_fieldcat-seltext_l    = 'Teslimat'.
        ls_fieldcat-outputlen    = 20.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'ERDAT'.
        ls_fieldcat-seltext_l    = 'Kaydın yaratıldığı tarih'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-edit         = 'X'.
      WHEN 'SPE_LOEKZ'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'VKORG'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'POSNR'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'MATNR'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-emphasize    = 'X'.
        ls_fieldcat-hotspot      = 'X'. "hotspotlu olacak ve tıklanınca MM03 ekranı gelecek
      WHEN 'LFIMG'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-do_sum       = 'X'.
      WHEN 'TRAFFIC'.
        ls_fieldcat-seltext_l    = 'Statü'.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN OTHERS.
        ls_fieldcat-no_out       = 'X'.
    ENDCASE.
    CLEAR ls_fieldcat-key.
    ls_fieldcat-seltext_m    = ls_fieldcat-seltext_l.
    ls_fieldcat-seltext_s    = ls_fieldcat-seltext_l.
    ls_fieldcat-reptext_ddic = ls_fieldcat-seltext_l.
    MODIFY gt_fieldcat FROM ls_fieldcat .
  ENDLOOP.
ENDFORM.

FORM call_alv_grid_likp_chx.

  DATA: lv_lines      TYPE i,
        lv_slines(10) TYPE c,
        lv_title      TYPE lvc_title.
*** Total records
  DESCRIBE TABLE gt_lips_chx LINES lv_lines.
  lv_slines = lv_lines.
  CONDENSE lv_slines.
  CONCATENATE 'Toplam' lv_slines 'kayıt mevcut'
         INTO lv_title SEPARATED BY space.

  IF lv_slines = 0.
    lv_title = 'Uygun veri bulunamadı'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = lv_title
      is_layout                = ls_layout
      it_fieldcat              = gt_fieldcat[]
      it_sort                  = gt_sort
      i_default                = 'X'
    TABLES
      t_outtab                 = gt_lips_chx[]
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc = 0.
    "do nothing
  ENDIF.

ENDFORM.

**************************************************** VBRK - VBRP

FORM call_merge_vbrp.
  DATA: ls_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-cprog
      i_structure_name       = 'ZYT_EVENTS_STRUC_VBRP'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  DATA: lv_col_pos TYPE i.
  lv_col_pos = lv_col_pos + 1.
  LOOP AT gt_fieldcat INTO ls_fieldcat .
    CASE ls_fieldcat-fieldname .
      WHEN 'VBELN'.
        ls_fieldcat-seltext_l    = 'Teslimat'.
        ls_fieldcat-outputlen    = 20.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'ERDAT'.
        ls_fieldcat-seltext_l    = 'Kaydın yaratıldığı tarih'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'FKART'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'FKIMG'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-do_sum       = 'X'.
      WHEN 'TRAFFIC'.
        ls_fieldcat-seltext_l    = 'Statü'.
        ls_fieldcat-col_pos      = lv_col_pos.

      WHEN OTHERS.
        ls_fieldcat-no_out       = 'X'.
    ENDCASE.
    CLEAR ls_fieldcat-key.
    ls_fieldcat-seltext_m    = ls_fieldcat-seltext_l.
    ls_fieldcat-seltext_s    = ls_fieldcat-seltext_l.
    ls_fieldcat-reptext_ddic = ls_fieldcat-seltext_l.
    MODIFY gt_fieldcat FROM ls_fieldcat .
  ENDLOOP.

ENDFORM.


FORM call_alv_grid_vbrp.

  DATA: lv_lines      TYPE i,
        lv_slines(10) TYPE c,
        lv_title      TYPE lvc_title.
*** Total records
  DESCRIBE TABLE gt_vbrp LINES lv_lines.
  lv_slines = lv_lines.
  CONDENSE lv_slines.
  CONCATENATE 'Toplam' lv_slines 'kayıt mevcut'
         INTO lv_title SEPARATED BY space.

  IF lv_slines = 0.
    lv_title = 'Uygun veri bulunamadı'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = lv_title
      is_layout                = ls_layout
      it_fieldcat              = gt_fieldcat[]
      it_sort                  = gt_sort
      i_default                = 'X'
    TABLES
      t_outtab                 = gt_vbrp[]
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc = 0.
    "do nothing
  ENDIF.

ENDFORM.
