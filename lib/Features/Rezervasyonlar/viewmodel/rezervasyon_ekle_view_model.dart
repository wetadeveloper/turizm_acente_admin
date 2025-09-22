import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/base_rezervasyon_view_model.dart';

class RezervasyonEkleViewModel extends BaseRezervasyonViewModel {
  final TextEditingController kisiSayisiController = TextEditingController();
  final TextEditingController toplamUcretController = TextEditingController();
  final TextEditingController kalanUcretController = TextEditingController();
  final TextEditingController notlarController = TextEditingController();
  final TextEditingController refMusteriInputController =
      TextEditingController();

  DateTime rezervasyonTarihi = DateTime.now();
  String konaklamaTipi = "2'li Oda";
  bool cantaVerildiMi = false;

  String? secilenMusteriId;
  String? secilenTurId;
  String? secilenTurAdi;
  String musteriAdi = "";
  List<String> iliskiliMusteriler = [];

  void setCantaVerildi(bool value) {
    cantaVerildiMi = value;
    notifyListeners();
  }

  void setKonaklamaTipi(String value) {
    konaklamaTipi = value;
    notifyListeners();
  }

  void setRezervasyonTarihi(DateTime value) {
    rezervasyonTarihi = value;
    notifyListeners();
  }

  void setSecilenMusteri(String musteriId, String musteriAdSoyad) {
    secilenMusteriId = musteriId;
    musteriAdi = musteriAdSoyad;
    notifyListeners();
  }

  void setSecilenTur(String turId, String turAdi) {
    secilenTurId = turId;
    secilenTurAdi = turAdi;
    notifyListeners();
  }

  void addIliskiliMusteriler(String yeniRef) {
    if (yeniRef.trim().isNotEmpty && !iliskiliMusteriler.contains(yeniRef)) {
      iliskiliMusteriler.add(yeniRef.trim());
      notifyListeners();
    }
  }

  void removeRefMusteri(String ref) {
    iliskiliMusteriler.remove(ref);
    notifyListeners();
  }

  Future<bool> rezervasyonEkle() async {
    if (secilenMusteriId == null || secilenTurId == null) {
      setHataMesaji("Müşteri ve Tur seçilmelidir.");
      return false;
    }

    try {
      setLoading(true);

      final docRef =
          FirebaseFirestore.instance.collection("rezervasyonlar").doc();

      final yeniRezervasyon = RezervasyonModel(
        rezervasyonId: docRef.id,
        musteriId: secilenMusteriId!,
        musteriAdi: musteriAdi,
        turId: secilenTurId!,
        turAdi: secilenTurAdi ?? "Bilinmiyor",
        rezervasyonTarihi: rezervasyonTarihi,
        kisiSayisi: int.tryParse(kisiSayisiController.text.trim()) ?? 1,
        toplamUcret: double.tryParse(toplamUcretController.text.trim()) ?? 0,
        kalanUcret: kalanUcretController.text.trim().isNotEmpty
            ? double.tryParse(kalanUcretController.text.trim())
            : null,
        konaklamaTipi: konaklamaTipi,
        iliskiliMusteriler: iliskiliMusteriler, // ✅
        cantaVerildiMi: cantaVerildiMi,
        notlar: notlarController.text.trim().isEmpty
            ? null
            : notlarController.text.trim(),
      );

      await docRef.set(yeniRezervasyon.toMap());

      addRezervasyon(yeniRezervasyon); // Base ViewModel'den

      debugPrint("Rezervasyon eklendi: ${docRef.id}");
      return true;
    } catch (e) {
      setHataMesaji("Rezervasyon eklenemedi: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  void disposeControllers() {
    kisiSayisiController.dispose();
    toplamUcretController.dispose();
    kalanUcretController.dispose();
    refMusteriInputController.dispose();

    notlarController.dispose();
  }
}
