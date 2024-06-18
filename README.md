# ReuseALV
Reuse ALV Example with excel export


Select-Loop-ALV 


![image](https://github.com/yunus42tez/ReuseALV/assets/119634510/488e05c9-5db1-4ace-81cb-dfdc9427328a)

 
 
Koşullar
1.	Ekran yürütüldüğünde vbeln boş ise, yeni ekran gelmeden altta mesaj sınıfında tanımlı olan "(Sipariş/Teslimat/Fatura) Numarası Boş  Geçilemez!" hatasını verecek.
2.	Hata mesajında bunlardan (Sipariş/Teslimat/Fatura) 1 tanesi verilecek.
3.	Tüm koşullar sağlandığında da ilgili Belge'nin selecti çalışacak. Ve her belgenin performu ayrı olacak. 
4.	Selectlerden veri gelmezse, "Uygun veri bulunamadı" uyarısı verecek. Bu mesajda text (program içinde) olarak verilecek.
5.	Veri geldiğinde ALV ekranında gösterilecek. Her radio buton için farklı ALV yapısı olacak.
6.	ALV ler excele export edilecek. (&XXL)
 
 
Selectler
1.	Radio-1 Seçilmişse, VBAK tablosuna VBELN ve ERDAT verilecek. VBAP tablosu ile join yapılacak. 2 tablodan VBELN, POSNR, MATNR,MATKL,NETWR alanları alınacak. Giriş ekranındaki P_REFVAL değeri girilmişse ve bundan küçük olanların NETWR alanları editable gelecek. P_REFVAL boş durumunda veya büyük olanlar kapalı olarak gelecek. ALV ekranında MATKL alanının tanımı da getirilecek. VBELN alanı hotspotlu olacak ve tıklanında VA03 ekranı gelecek(set parameter id). Malzemeye göre NETWR alanı ara toplamlı olarak gelecek.
 
2.	Radio-2 Seçilmişse, LIKP tablosuna VBELN, ERDAT ve SPE_LOEKZ verilecek. LIPS tablosu ile join yapılacak. 2 tablodan VBELN, ERDAT,VKORG, POSNR,MATNR ve LFIMG alanları alınacak. Bu alv ekranın üzerinde top-of-page gelecek ve burada kayıt sayısı yazacak. ALV de trafik ışığı alanı olacak. P_REFVAL alanı dolu ve LFIMG alanından büyük olanlarda yeşil trafik ışığı, küçük veya P_REFVAL boş olduğunda sarı trafik ışığı gelecek. MATNR alanı hotspotlu olacak ve tıklanında MM03 ekranı gelecek(set parameter id). VKORG'a göre LFIMG alanı ara toplamlı olarak gelecek.
 
3.	Radio-3 Seçilmişse, VBRK tablosuna VBELN ve ERDAT verilecek. VBRP tablosu ile join yapılacak. 2 tablodan sadece VBELN,ERDAT,FKART, FKIMG alanları alınacak.  VBELN alanı hotspotlu olacak ve tıklanında VF03 ekranı gelecek(set parameter id). Bu radio buton için status da "Popup getir" diye bir buton olacak ve ALV den satır seçilip butona basınca "Evet-Hayır-İptal" seçenekleri olan (iconları ile birlikte) gelecek. Popup mesajında ise, seçili satırın VBELN ve POSNR'si olacak. ALV'de durum kolonu olacak ve bu kolona popupdan hangi butona basarsa da "Evet ise yeşil, Hayır ise kırmızı, İptal ise sarı trafik ışığı yanacak şekilde ALV modify edilecek. Statusdaki POPUP getir butonu radio1-2 de görünmeyecek.
