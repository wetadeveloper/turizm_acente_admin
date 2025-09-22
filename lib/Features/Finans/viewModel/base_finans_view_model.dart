import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';

abstract class BaseFinansViewModel with ChangeNotifier {
  final List<FinansalModel> _finansListesi = [];
  final List<Map<String, dynamic>> _dokumanlarListesi = [];

  bool _isLoading = false;
  String? _hataMesaji;

  // Getterlar
  List<FinansalModel> get finansListesi => _finansListesi;
  List<Map<String, dynamic>> get dokumanlarListesi => _dokumanlarListesi;
  bool get isLoading => _isLoading;
  String? get hataMesaji => _hataMesaji;

  // Firestore referansı
  static final CollectionReference financialRef =
      FirebaseFirestore.instance.collection("financial");

  // State değişimleri
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setHataMesaji(String? mesaj) {
    _hataMesaji = mesaj;
    notifyListeners();
  }

  void setFinansal(List<FinansalModel> yeniListe) {
    _finansListesi
      ..clear()
      ..addAll(yeniListe);
    notifyListeners();
  }

  void setFinansalDokumanListesi(List<Map<String, dynamic>> yeniListe) {
    _dokumanlarListesi
      ..clear()
      ..addAll(yeniListe);
    notifyListeners();
  }

  void addFinansalDokuman(Map<String, dynamic> dokuman) {
    _dokumanlarListesi.add(dokuman);
    notifyListeners();
  }

  void silFinansalDokuman(String dokumanId) {
    _dokumanlarListesi.removeWhere((d) => d['id'] == dokumanId);
    notifyListeners();
  }

  // --- Firestore CRUD ---

  static Stream<List<FinansalModel>> financialStream() {
    return financialRef.orderBy("createdAt", descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => FinansalModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addFinancial(FinansalModel model) async {
    try {
      setLoading(true);
      await financialRef.add({
        ...model.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      setHataMesaji(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateFinancial(String id, Map<String, dynamic> data) async {
    try {
      setLoading(true);
      await financialRef.doc(id).update({
        ...data,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      setHataMesaji(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteFinancial(String id) async {
    try {
      setLoading(true);
      await financialRef.doc(id).delete();
    } catch (e) {
      setHataMesaji(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<FinansalModel?> getFinancialById(String id) async {
    try {
      final doc = await financialRef.doc(id).get();
      if (doc.exists) {
        return FinansalModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      setHataMesaji(e.toString());
    }
    return null;
  }
}
