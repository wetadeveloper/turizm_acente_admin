import 'package:ozel_sirket_admin/Features/Hakkinda/model/hakkinda_model.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/viewmodel/base_hakkinda_view_model.dart';

class HakkindaViewModel extends BaseHakkindaViewModel {
  Future<void> getirHakkindaBilgileri() async {
    try {
      setLoading(true);
      final info = HakkindaModel(
        sirketAdi:
            "Selamet Turizm Seyehat Otomotiv İnşaat Dış Ticaret Limited Şirketi",
        sahibiAdi: "Ali Pala",
        adres: "Aziziye Mah. Aziziye Cad. No:11/205, Konya / Türkiye",
        telefon: "+90 332 351 61 21",
        eposta: "info@selametturizm.com",
        //yetkiliKisi: "Ali Pala",
        //vergiNo: "1234567890",
        vergiDairesi: "Konya Vergi Dairesi",
        ticaretSicilNo: "46835",
        tursabBelgeNo: "8864",
        webSite: "www.selametturizm.com",
        bankaBilgileri: [
          BankaBilgisi(
            bankaAdi: "KUVEYT TÜRK",
            iban: "TR31 0020 5000 0101 0668 5001 03",
            hesapAdi:
                "SELAMET TURİZM OTOMOTİV İNŞAAT DIŞ TİCARET LİMİTED ŞİRKETİ",
            hesapTuru: "USD",
          ),
          BankaBilgisi(
            bankaAdi: "KUVEYT TÜRK",
            iban: "TR42 0020 5000 0101 0668 5000 02",
            hesapAdi:
                "SELAMET TURİZM OTOMOTİV İNŞAAT DIŞ TİCARET LİMİTED ŞİRKETİ",
            hesapTuru: "TL",
          ),
        ],
        aciklama: "1978’den beri güvenle hizmet veren umre ve hac acentesi.",
      );

      setHakkindaListesi([info]);

      /*setDokumanlar([
        {"ad": "Turizm Bakanlığı Belgesi", "dosya": "belge_tb.pdf"},
        {"ad": "TÜRSAB Belgesi", "dosya": "tursab.pdf"},
      ]);*/

      setHataMesaji(null);
    } catch (e) {
      setHataMesaji("Hakkında bilgileri alınırken hata oluştu: $e");
    } finally {
      setLoading(false);
    }
  }
}
