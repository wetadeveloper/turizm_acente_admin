import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/model/kampanya_model.dart';

abstract class BaseKampanyaViewModel with ChangeNotifier {
  final List<KampanyaModel> _kampanyalar = [];
  final List<Map<String, dynamic>> _dokumanlarListesi = [];
  bool _isLoading = false;
  String? _hataMesaji;
  List<KampanyaModel> get kampanyalar => _kampanyalar;
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

  void setKampanyaDokumanListesi(List<Map<String, dynamic>> yeniListe) {
    _dokumanlarListesi.clear();
    _dokumanlarListesi.addAll(yeniListe);
    notifyListeners();
  }

  void addKampanya(KampanyaModel kampanya) {
    _kampanyalar.add(kampanya);
    notifyListeners();
  }

  void silKampanya(String kampanyaId) {
    _kampanyalar.removeWhere((k) => k.kampanyaId == kampanyaId);
    notifyListeners();
  }

  static Stream<List<KampanyaModel>> kampanyalarStream() {
    return FirebaseFirestore.instance
        .collection("TumKampanyalar")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => KampanyaModel.fromMap(doc.data()))
            .toList());
  }
}
