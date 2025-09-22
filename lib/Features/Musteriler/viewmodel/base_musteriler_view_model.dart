import 'package:flutter/foundation.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/musteriler_view_model.dart';

abstract class BaseMusterilerViewModel with ChangeNotifier {
  final List<MusteriModel> _musteriler = [];
  final List<Map<String, dynamic>> _dokumanlarListesi = [];
  bool _isLoading = false;
  String? _hataMesaji;

  Stream<List<MusteriModel>> get musterilerStream =>
      MusterilerViewModel.musterileriDinle();

  List<MusteriModel> get musteriler => _musteriler;
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

  void setMusteriler(List<MusteriModel> yeniListe) {
    _musteriler.clear();
    _musteriler.addAll(yeniListe);
    notifyListeners();
  }

  void setMusteriDokumanListesi(List<Map<String, dynamic>> yeniListe) {
    _dokumanlarListesi.clear();
    _dokumanlarListesi.addAll(yeniListe);
    notifyListeners();
  }

  void addMusteri(MusteriModel musteri) {
    _musteriler.add(musteri);
    notifyListeners();
  }

  void silMusteri(String musteriId) {
    _musteriler.removeWhere((m) => m.musteriId == musteriId);
    notifyListeners();
  }
}
