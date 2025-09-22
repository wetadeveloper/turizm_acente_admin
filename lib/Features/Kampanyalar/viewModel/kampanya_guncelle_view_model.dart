import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/model/kampanya_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/base_kampanya_form_view_model.dart';

class KampanyaGuncelleViewModel extends BaseKampanyaFormViewModel {
  String kampanyaId;

  late DateTime baslangicDate;
  late DateTime bitisDate;

  KampanyaGuncelleViewModel({
    required KampanyaModel kampanya,
  }) : kampanyaId = kampanya.kampanyaId {
    kampanyaIdController.text = kampanya.kampanyaId;
    baslikController.text = kampanya.baslik;
    aciklamaController.text = kampanya.aciklama;
    detaylarController.text = kampanya.detaylar;
    kampanyaDurumu = kampanya.kampanyaDurumu;
    baslangicDate = kampanya.baslangicTarih;
    bitisDate = kampanya.bitisTarih;

    baslangicDateController.text =
        DateFormat('dd/MM/yyyy').format(baslangicDate);
    bitisDateController.text = DateFormat('dd/MM/yyyy').format(bitisDate);
  }

  Future<bool> kampanyaGuncelle(BuildContext context) async {
    try {
      setLoading(true);

      final updateKampanya = KampanyaModel(
        kampanyaId: kampanyaId,
        baslik: baslikController.text,
        detaylar: detaylarController.text,
        baslangicTarih: baslangicDate,
        bitisTarih: bitisDate,
        kampanyaDurumu: kampanyaDurumu,
        aciklama: aciklamaController.text,
        guncellemeTarihi: DateTime.now(),
      );

      final docRef = FirebaseFirestore.instance
          .collection('TumKampanyalar')
          .doc(kampanyaId);
      await docRef.update({
        ...updateKampanya.toMap(),
      });
      setLoading(false);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Kampanya güncelleme hatası: $e");
      }
      setLoading(false);
      setHataMesaji("Kampanya güncelleme hatası: $e");
      return false;
    }
  }
}
