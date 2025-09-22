import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class MusteriModel {
  final String musteriId;
  final String ad;
  final String soyad;
  final String cinsiyet;
  final String medeniDurum;
  final int telefon;
  final int kimlikNumarasi;
  final DateTime? dogumTarihi;
  final DateTime kayitTarihi;

  MusteriModel({
    required this.musteriId,
    required this.ad,
    required this.soyad,
    required this.telefon,
    required this.cinsiyet,
    required this.medeniDurum,
    required this.kimlikNumarasi,
    this.dogumTarihi,
    required this.kayitTarihi,
  });

  // fromMap
  factory MusteriModel.fromMap(Map<String, dynamic> data, String documentId) {
    try {
      return MusteriModel(
        musteriId: documentId,
        ad: data['ad'] ?? '',
        soyad: data['soyad'] ?? '',
        telefon: data['telefon'] is int ? data['telefon'] : int.tryParse(data['telefon'].toString()) ?? 0,
        kimlikNumarasi: data['kimlikNumarasi'] is int
            ? data['kimlikNumarasi']
            : int.tryParse(data['kimlikNumarasi'].toString()) ?? 0,
        cinsiyet: data['cinsiyet'] ?? '',
        medeniDurum: data['medeniDurum'] ?? 'Bilinmiyor',
        dogumTarihi: data['dogumTarihi'] != null ? (data['dogumTarihi'] as Timestamp).toDate() : null,
        kayitTarihi: (data['kayitTarihi'] as Timestamp).toDate(),
      );
    } catch (e, stack) {
      debugPrint('fromMap HATASI: $e\n$stack\nVeri: $data');
      rethrow;
    }
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'musteriId': musteriId,
      'ad': ad,
      'soyad': soyad,
      'telefon': telefon,
      'cinsiyet': cinsiyet,
      'medeniDurum': medeniDurum,
      'kimlikNumarasi': kimlikNumarasi,
      'dogumTarihi': dogumTarihi,
      'kayitTarihi': Timestamp.fromDate(kayitTarihi),
    };
  }
}
