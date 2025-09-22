import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/model/kampanya_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/base_kampanya_form_view_model.dart';

class KampanyaEkleViewModel extends BaseKampanyaFormViewModel {
  String generateRandomId(int length) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rand = Random();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<bool> kampanyaOlustur(BuildContext context) async {
    try {
      final kampanyaId = generateRandomId(10);
      final baslangicTarihiFormat =
          DateFormat('dd/MM/yyyy').parse(baslangicDateController.text);
      final bitisTarihiFormat =
          DateFormat('dd/MM/yyyy').parse(bitisDateController.text);

      // Validasyon
      if (!_validateSingleCustomer()) {
        return false;
      }
      final kampanya = KampanyaModel(
        kampanyaId: kampanyaId,
        baslik: baslikController.text,
        aciklama: aciklamaController.text,
        detaylar: detaylarController.text,
        baslangicTarih: baslangicTarihiFormat,
        bitisTarih: bitisTarihiFormat,
        olusturmaTarihi: DateTime.now(),
        guncellemeTarihi: null,
        kampanyaDurumu: kampanyaDurumu,
      );
      final docRef = FirebaseFirestore.instance
          .collection('TumKampanyalar')
          .doc(kampanyaId);
      await docRef.set({
        ...kampanya.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print("Kampanya Firestore'a yazıldı: ${kampanya.toMap()}");
      }
      notifyListeners();
      if (context.mounted) {
        Navigator.pop(context);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Kampanya oluşturulurken hata: $e");
      }
      setHataMesaji("Kampanya oluşturulurken hata: $e");
      return false;
    }
  }

  bool _validateSingleCustomer() {
    if (baslikController.text.trim().isEmpty) {
      setHataMesaji("Başlık alanı boş olamaz");
      notifyListeners();
      return false;
    }
    if (aciklamaController.text.trim().isEmpty) {
      setHataMesaji("Açıklama alanı boş olamaz");
      notifyListeners();
      return false;
    }
    if (detaylarController.text.trim().isEmpty) {
      setHataMesaji("Detaylar alanı boş olamaz");
      notifyListeners();
      return false;
    }
    if (baslangicDateController.text.trim().isEmpty) {
      setHataMesaji("Başlangıç tarihi boş olamaz");
      notifyListeners();
      return false;
    }
    if (bitisDateController.text.trim().isEmpty) {
      setHataMesaji("Bitiş tarihi boş olamaz");
      notifyListeners();
      return false;
    }
    return true;
  }
}
