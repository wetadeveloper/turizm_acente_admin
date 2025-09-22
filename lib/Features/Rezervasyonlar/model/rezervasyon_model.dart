import 'package:cloud_firestore/cloud_firestore.dart';

class RezervasyonModel {
  final String rezervasyonId;
  final String musteriId;
  final String turId;
  final DateTime? rezervasyonTarihi;
  final String musteriAdi;
  final String turAdi;

  final int? kisiSayisi;
  final double toplamUcret;
  final double? kalanUcret;

  final String konaklamaTipi;
  final List<String>? iliskiliMusteriler;

  final bool cantaVerildiMi;
  final String? notlar;

  RezervasyonModel({
    required this.rezervasyonId,
    required this.musteriId,
    required this.musteriAdi,
    required this.turId,
    required this.turAdi,
    required this.rezervasyonTarihi,
    required this.kisiSayisi,
    required this.toplamUcret,
    this.kalanUcret,
    required this.konaklamaTipi,
    required this.iliskiliMusteriler, // ✅
    required this.cantaVerildiMi,
    this.notlar,
  });

  factory RezervasyonModel.fromMap(Map<String, dynamic> data, String docId) {
    return RezervasyonModel(
      rezervasyonId: docId,
      musteriId: data['musteriId'],
      turId: data['turId'],
      turAdi: data['turAdi'] ?? 'Bilinmiyor',
      musteriAdi: data['musteriAdi'] ?? 'Bilinmiyor',
      rezervasyonTarihi: (data['rezervasyonTarihi'] as Timestamp).toDate(),
      kisiSayisi: data['kisiSayisi'] ?? 1,
      toplamUcret: (data['toplamUcret'] as num).toDouble(),
      kalanUcret: data['kalanUcret'] != null
          ? (data['kalanUcret'] as num).toDouble()
          : null,
      konaklamaTipi: data['konaklamaTipi'] ?? 'Bilinmiyor',
      iliskiliMusteriler: List<String>.from(data['iliskiliMusteriler'] ?? []),
      cantaVerildiMi: data['cantaVerildiMi'] ?? false,
      notlar: data['notlar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'musteriId': musteriId,
      'rezervasyonId': rezervasyonId,
      'turId': turId,
      'turAdi': turAdi,
      'musteriAdi': musteriAdi,
      'rezervasyonTarihi': rezervasyonTarihi != null
          ? Timestamp.fromDate(rezervasyonTarihi!)
          : null,
      'kisiSayisi': kisiSayisi,
      'toplamUcret': toplamUcret,
      'kalanUcret': kalanUcret,
      'konaklamaTipi': konaklamaTipi,
      'iliskiliMusteriler': iliskiliMusteriler, // ✅
      'cantaVerildiMi': cantaVerildiMi,
      'notlar': notlar,
    };
  }
}
