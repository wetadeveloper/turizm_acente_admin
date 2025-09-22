import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/viewModel/reklamlar_view_model.dart';
import '../model/reklam_model.dart';

abstract class BaseReklamViewModel with ChangeNotifier {
  final List<ReklamModel> _reklamlar = [];
  final List<Map<String, dynamic>> _dokumanlarListesi = [];
  bool _isLoading = false;
  String? _hataMesaji;

  Stream<Map<String, List<ReklamModel>>> get reklamlarStream =>
      ReklamlarViewModel.reklamKategorileriniDinle();

  List<ReklamModel> get reklamlar => _reklamlar;
  List<Map<String, dynamic>> get dokumanlarListesi => _dokumanlarListesi;
  bool get isLoading => _isLoading;
  String? get hataMesaji => _hataMesaji;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setHataMesaji(String? mesaj) {
    _hataMesaji = mesaj;
    notifyListeners();
  }

  void setReklamlar(List<ReklamModel> yeniListe) {
    _reklamlar.clear();
    _reklamlar.addAll(yeniListe);
    notifyListeners();
  }

  void setReklamDokumanListesi(List<Map<String, dynamic>> yeniListe) {
    _dokumanlarListesi.clear();
    _dokumanlarListesi.addAll(yeniListe);
    notifyListeners();
  }

  void addReklam(ReklamModel reklam) {
    _reklamlar.add(reklam);
    notifyListeners();
  }

  void silReklam(String reklamId) {
    _reklamlar.removeWhere((r) => r.reklamId == reklamId);
    notifyListeners();
  }

  Future<void> reklamlariGetir(String dokumanAdi) async {
    try {
      setLoading(true);
      final querySnapshot = await FirebaseFirestore.instance
          .collection("TumReklamlar")
          .doc(dokumanAdi)
          .collection("rek")
          .orderBy("olusturma_tarihi", descending: true)
          .get();

      final reklamlarList = querySnapshot.docs.map((doc) {
        return ReklamModel.fromMap(doc.data());
      }).toList();

      setReklamlar(reklamlarList);
    } catch (e) {
      setHataMesaji("Reklamlar yuklenemedi: $e");
    } finally {
      setLoading(false);
    }
  }
}
