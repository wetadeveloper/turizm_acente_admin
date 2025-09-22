import 'package:flutter/foundation.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/model/hakkinda_model.dart';

abstract class BaseHakkindaViewModel with ChangeNotifier {
  @protected
  final List<HakkindaModel> _hakkindaListesi = [];

  @protected
  final List<Map<String, dynamic>> _dokumanlarListesi = [];

  bool _isLoading = false;
  String? _hataMesaji;

  List<HakkindaModel> get hakkindaListesi =>
      List.unmodifiable(_hakkindaListesi);
  List<Map<String, dynamic>> get dokumanlarListesi =>
      List.unmodifiable(_dokumanlarListesi);

  bool get isLoading => _isLoading;
  String? get hataMesaji => _hataMesaji;

  // --- protected yardımcı metotlar ---
  @protected
  void setHakkindaListesi(List<HakkindaModel> yeniListe) {
    _hakkindaListesi
      ..clear()
      ..addAll(yeniListe);
    notifyListeners();
  }

  @protected
  void setDokumanlar(List<Map<String, dynamic>> yeniListe) {
    _dokumanlarListesi
      ..clear()
      ..addAll(yeniListe);
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setHataMesaji(String? mesaj) {
    _hataMesaji = mesaj;
    notifyListeners();
  }
}
