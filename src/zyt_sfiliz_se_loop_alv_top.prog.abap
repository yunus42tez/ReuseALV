*&---------------------------------------------------------------------*
*&  Include           ZYT_SFLZ_EVENTS_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS : slis.

TABLES: vbak,
        likp,
        vbrk,
        vbap,
        lips,
        vbrp.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      ls_layout   TYPE slis_layout_alv.

DATA: gt_fieldcat_lvc TYPE lvc_t_fcat,
      gs_fieldcat_lvc TYPE lvc_s_fcat,
      ls_layout_lvc   TYPE lvc_s_layo. " stylefname için bunu bullan.

*** ara toplam almak için. LVC fieldcat
DATA: gt_sort_lvc TYPE lvc_t_sort,
      gs_sort_lvc LIKE LINE OF gt_sort_lvc.
***
*** ara toplam almak için.
DATA: gt_sort TYPE slis_t_sortinfo_alv,
      gs_sort LIKE LINE OF gt_sort.
***


TYPES: BEGIN OF gty_vbak,
         vbeln TYPE vbeln,
         erdat TYPE erdat,
       END OF gty_vbak.

DATA: gt_vbak TYPE TABLE OF gty_vbak,
      gs_vbak TYPE gty_vbak.
**************************************************

TYPES: BEGIN OF gty_likp_chx,
         vbeln     TYPE vbeln,
         erdat     TYPE erdat,
         spe_loekz TYPE loekz_bk,
       END OF gty_likp_chx.

DATA: gt_likp_chx TYPE TABLE OF gty_likp_chx,
      gs_likp_chx TYPE gty_likp_chx.
**************************************************

TYPES: BEGIN OF gty_likp,
         vbeln TYPE vbeln,
         erdat TYPE erdat,
       END OF gty_likp.

DATA: gt_likp TYPE TABLE OF gty_likp,
      gs_likp TYPE gty_likp.
**************************************************

TYPES: BEGIN OF gty_vbrk,
         vbeln TYPE vbeln,
         erdat TYPE erdat,
         " fkart TYPE fkart, " 3.  Radio-3 Seçilmişse, VBRK tablosuna VBELN ve ERDAT verilecek.
       END OF gty_vbrk.

DATA: gt_vbrk TYPE TABLE OF gty_vbrk,
      gs_vbrk TYPE gty_vbrk.
**************************************************
**************************************************          Joinli tablolar
**************************************************
TYPES: BEGIN OF gty_vbap, "VBELN, POSNR, MATNR,MATKL,NETWR
         vbeln       TYPE vbeln,
         erdat       TYPE erdat,
         posnr       TYPE posnr_va,
         matnr       TYPE matnr,
         matkl       TYPE matkl,
         netwr       TYPE netwr_ap,
         wgbez       TYPE t023t-wgbez,
         field_style TYPE lvc_t_styl,
       END OF gty_vbap.

DATA: gt_vbap TYPE TABLE OF gty_vbap,
      gs_vbap TYPE gty_vbap.
**************************************************
TYPES: BEGIN OF gty_lips,
         vbeln      TYPE vbeln,
         erdat      TYPE erdat,
         spe_loekz  TYPE loekz_bk,
         vkorg      TYPE vkorg,
         posnr      TYPE posnr,
         matnr      TYPE matnr,
         lfimg      TYPE lfimg,
         line_color TYPE char4,
         cell_color TYPE slis_t_specialcol_alv,
         traffic(4) TYPE c,
       END OF gty_lips.


DATA: gt_lips     TYPE TABLE OF gty_lips,
      gs_lips     TYPE gty_lips,
      gt_lips_chx TYPE TABLE OF gty_lips,
      gs_lips_chx TYPE gty_lips.
**************************************************
TYPES: BEGIN OF gty_vbrp,
         vbeln      TYPE vbeln,
         erdat      TYPE erdat,
         fkart      TYPE fkart,
         fkimg      TYPE fkimg,
         line_color TYPE  char4,
         cell_color TYPE slis_t_specialcol_alv,
         traffic(4) TYPE c,
       END OF gty_vbrp.


DATA: gt_vbrp TYPE TABLE OF gty_vbrp,
      gs_vbrp TYPE gty_vbrp.
**************************************************
************************************************** EXCEL EXPORT

TYPES: BEGIN OF gty_vbap_excel,
         vbeln TYPE vbeln,
         erdat TYPE erdat,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
         matkl TYPE matkl,
         netwr TYPE netwr_ap,
         wgbez TYPE t023t-wgbez,
       END OF gty_vbap_excel.

DATA: gt_vbap_excel TYPE TABLE OF gty_vbap_excel,
      gs_vbap_excel TYPE gty_vbap_excel.
**************************************************
TYPES: BEGIN OF gty_lips_CHX_excel,
         vbeln     TYPE vbeln,
         erdat     TYPE erdat,
         spe_loekz TYPE loekz_bk,
         vkorg     TYPE vkorg,
         posnr     TYPE posnr,
         matnr     TYPE matnr,
         lfimg     TYPE lfimg,
       END OF gty_lips_CHX_excel.

DATA: gt_lips_chx_excel TYPE TABLE OF gty_lips_CHX_excel,
      gs_lips_chx_excel TYPE gty_lips_CHX_excel.
**************************************************
TYPES: BEGIN OF gty_lips_excel,
         vbeln     TYPE vbeln,
         erdat     TYPE erdat,
         vkorg     TYPE vkorg,
         posnr     TYPE posnr,
         matnr     TYPE matnr,
         lfimg     TYPE lfimg,
       END OF gty_lips_excel.

DATA: gt_lips_excel          TYPE TABLE OF gty_lips_excel,
      gs_lips_excel          TYPE gty_lips_excel.

**************************************************
TYPES: BEGIN OF gty_vbrp_excel,
         vbeln TYPE vbeln,
         erdat TYPE erdat,
         fkart TYPE fkart,
         fkimg TYPE fkimg,
       END OF gty_vbrp_excel.


DATA: gt_vbrp_excel TYPE TABLE OF gty_vbrp_excel,
      gs_vbrp_excel TYPE gty_vbrp_excel.
