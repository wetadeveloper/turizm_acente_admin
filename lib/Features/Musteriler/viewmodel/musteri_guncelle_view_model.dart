import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/base_musteri_form_view_model.dart';

class MusteriGuncelleViewModel extends BaseMusteriFormViewModel {
  final String musteriId;
  final DateTime _orijinalKayitTarihi;

  bool isLoading = false;
  String? hataMesaji;

  MusteriGuncelleViewModel({required MusteriModel musteri})
      : musteriId = musteri.musteriId,
        _orijinalKayitTarihi = musteri.kayitTarihi {
    adController.text = musteri.ad;
    soyadController.text = musteri.soyad;
    telefonController.text = musteri.telefon.toString();
    kimlikNoController?.text = musteri.kimlikNumarasi.toString();
    cinsiyet = musteri.cinsiyet;
    medeniDurum = musteri.medeniDurum;
    dogumTarihi = musteri.dogumTarihi;
  }

  Future<bool> musteriGuncelle(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final guncellenmisMusteri = MusteriModel(
        musteriId: musteriId,
        ad: adController.text.trim(),
        soyad: soyadController.text.trim(),
        telefon: int.parse(telefonController.text.trim()),
        kimlikNumarasi: int.parse(kimlikNoController?.text.trim() ?? ''),
        cinsiyet: cinsiyet ?? "Erkek",
        medeniDurum: medeniDurum ?? "Bekar",
        dogumTarihi: dogumTarihi ?? DateTime.now(),
        kayitTarihi: _orijinalKayitTarihi,
      );

      await FirebaseFirestore.instance
          .collection('musteriler')
          .doc(musteriId)
          .update(guncellenmisMusteri.toMap());

      if (context.mounted) {
        Navigator.pop(context, true); // başarıyla döner
      }

      return true;
    } catch (e) {
      hataMesaji = 'Güncelleme hatası: $e';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void disposeControllers() {
    adController.dispose();
    soyadController.dispose();
    telefonController.dispose();
    kimlikNoController?.dispose();
  }
}
