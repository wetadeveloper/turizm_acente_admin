import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/base_rezervasyon_view_model.dart';

class RezervasyonGuncelleViewModel extends BaseRezervasyonViewModel {
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

  late String rezervasyonId;

  void initFromModel(RezervasyonModel model) {
    rezervasyonId = model.rezervasyonId;
    secilenMusteriId = model.musteriId;
    musteriAdi = model.musteriAdi;
    secilenTurId = model.turId;
    secilenTurAdi = model.turAdi;
    rezervasyonTarihi = model.rezervasyonTarihi ?? DateTime.now();
    konaklamaTipi = model.konaklamaTipi;
    cantaVerildiMi = model.cantaVerildiMi;
    iliskiliMusteriler = List.from(model.iliskiliMusteriler ?? []);

    kisiSayisiController.text = model.kisiSayisi?.toString() ?? "";
    toplamUcretController.text = model.toplamUcret.toString();
    kalanUcretController.text = model.kalanUcret?.toString() ?? "";
    notlarController.text = model.notlar ?? "";

    notifyListeners();
  }

  void setRezervasyonTarihi(DateTime date) {
    rezervasyonTarihi = date;
    notifyListeners();
  }

  void setKonaklamaTipi(String value) {
    konaklamaTipi = value;
    notifyListeners();
  }

  void setCantaVerildi(bool value) {
    cantaVerildiMi = value;
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

  Future<bool> rezervasyonGuncelle() async {
    if (secilenMusteriId == null || secilenTurId == null) {
      setHataMesaji("Müşteri ve Tur seçilmelidir.");
      return false;
    }

    try {
      setLoading(true);

      final guncellenmisRezervasyon = RezervasyonModel(
        rezervasyonId: rezervasyonId,
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
        iliskiliMusteriler: iliskiliMusteriler,
        cantaVerildiMi: cantaVerildiMi,
        notlar: notlarController.text.trim().isEmpty
            ? null
            : notlarController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("rezervasyonlar")
          .doc(rezervasyonId)
          .update(guncellenmisRezervasyon.toMap());

      silRezervasyon(rezervasyonId);
      addRezervasyon(guncellenmisRezervasyon);

      return true;
    } catch (e) {
      setHataMesaji("Rezervasyon güncellenemedi: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  void disposeControllers() {
    kisiSayisiController.dispose();
    toplamUcretController.dispose();
    kalanUcretController.dispose();
    notlarController.dispose();
    refMusteriInputController.dispose();
  }
}
