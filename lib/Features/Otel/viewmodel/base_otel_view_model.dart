import 'package:flutter/widgets.dart';
import 'package:ozel_sirket_admin/Features/Otel/model/otel_model.dart';

abstract class BaseOtelViewModel with ChangeNotifier {
  final List<OtelModel> _odalar = [];
  bool _isLoading = false;
  String? _hataMesaji;
  List<OtelModel> get odalar => _odalar;
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

  void setOdalar(List<OtelModel> yeniListe) {
    _odalar.clear();
    _odalar.addAll(yeniListe);
    notifyListeners();
  }

  void addOda(OtelModel oda) {
    _odalar.add(oda);
    notifyListeners();
  }

  void silOda(String odaId) {
    _odalar.removeWhere((o) => o.odaId == odaId);
    notifyListeners();
  }

  void guncelleOda(OtelModel guncelOda) {
    final index = _odalar.indexWhere((o) => o.odaId == guncelOda.odaId);
    if (index != -1) {
      _odalar[index] = guncelOda;
      notifyListeners();
    }
  }
}
