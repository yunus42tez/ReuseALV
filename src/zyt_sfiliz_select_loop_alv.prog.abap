*&---------------------------------------------------------------------*
*& Report ZYT_SFILIZ_EVENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zyt_sfiliz_select_loop_alv MESSAGE-ID zyt_sfiliz.

INITIALIZATION.

  INCLUDE zyt_sfiliz_se_loop_alv_top.


START-OF-SELECTION.

  DATA: gv_num1 TYPE c LENGTH 1.

  SELECTION-SCREEN BEGIN OF BLOCK blockid1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_sip RADIOBUTTON GROUP rad1 USER-COMMAND radbtn DEFAULT 'X',
              p_tes RADIOBUTTON GROUP rad1,
              p_fat RADIOBUTTON GROUP rad1.
  SELECTION-SCREEN END OF BLOCK blockid1.

  SELECTION-SCREEN BEGIN OF BLOCK blockid2 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_datum  LIKE sy-datum DEFAULT sy-datum.

  SELECT-OPTIONS: s_vbelns FOR vbak-vbeln MODIF ID abc,
                  s_vbelnt FOR likp-vbeln MODIF ID 123,
                  s_vbelnf FOR vbrk-vbeln MODIF ID xyz,
                  s_erdat  FOR vbak-erdat.

  PARAMETERS: p_loekz AS CHECKBOX.

  SELECTION-SCREEN END OF BLOCK blockid2.

  SELECTION-SCREEN BEGIN OF BLOCK blockid3 WITH FRAME.
  PARAMETERS: p_refval TYPE int4.
  SELECTION-SCREEN END OF BLOCK blockid3.

  PARAMETERS: p_path TYPE string NO-DISPLAY.

  INCLUDE zyt_sfiliz_se_loop_alv_pai.
  INCLUDE zyt_sfiliz_se_loop_alv_frm.

AT SELECTION-SCREEN OUTPUT.

  PERFORM at_sel_screen_output_frm.

END-OF-SELECTION.


  IF p_sip = 'X'. "1. radio button

    PERFORM get_data_p_sip.

    IF s_vbelns IS INITIAL.
      MESSAGE s000 DISPLAY LIKE 'E'.
      EXIT.
    ELSEIF sy-subrc EQ 0.

      PERFORM calculate_sub_total.

      PERFORM set_specific_field_attributes.

      PERFORM set_layout_lvc.

      PERFORM call_merge_vbak.

      PERFORM call_alv_grid_vbak.
    ENDIF.
  ELSEIF p_tes = 'X'. "2. radio button

    IF p_loekz = 'X'.
      PERFORM get_data_p_tes_chx.

      IF s_vbelnt IS INITIAL.
        MESSAGE s001 DISPLAY LIKE 'E'.
        EXIT.
      ELSEIF sy-subrc EQ 0.
        PERFORM calculate_sub_total.

        PERFORM set_layout_with_color.

        PERFORM set_line_color.

        PERFORM call_merge_likp_chx.

        PERFORM call_alv_grid_likp_chx.
      ENDIF.
    ELSEIF p_loekz NE 'X'.

      PERFORM get_data_p_tes.

      IF s_vbelnt IS INITIAL.
        MESSAGE s001 DISPLAY LIKE 'E'.
        EXIT.
      ELSEIF sy-subrc EQ 0.
        PERFORM calculate_sub_total.

        PERFORM set_layout_with_color.

        PERFORM set_line_color.

        PERFORM call_merge_likp.

        PERFORM call_alv_grid_likp.
      ENDIF.
    ENDIF.

  ELSEIF p_fat = 'X'. "3. radio button

    PERFORM get_data_p_fat.

    IF s_vbelnf IS INITIAL.
      MESSAGE s002 DISPLAY LIKE 'E'.
      EXIT.
    ELSEIF sy-subrc EQ 0.

      PERFORM calculate_sub_total.

      PERFORM set_layout_with_color.

      PERFORM call_merge_vbrp.

      PERFORM call_alv_grid_vbrp.
    ENDIF.
  ENDIF.
