import 'package:flutter/widgets.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';

abstract class BaseRezervasyonViewModel with ChangeNotifier {
  final List<RezervasyonModel> _rezervasyonlar = [];
  bool _isLoading = false;
  String? _hataMesaji;

  List<RezervasyonModel> get rezervasyonlar => _rezervasyonlar;
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

  void setRezervasyonlar(List<RezervasyonModel> yeniListe) {
    _rezervasyonlar.clear();
    _rezervasyonlar.addAll(yeniListe);
    notifyListeners();
  }

  void addRezervasyon(RezervasyonModel rezervasyon) {
    _rezervasyonlar.add(rezervasyon);
    notifyListeners();
  }

  void silRezervasyon(String rezervasyonId) {
    _rezervasyonlar.removeWhere((r) => r.rezervasyonId == rezervasyonId);
    notifyListeners();
  }
}
