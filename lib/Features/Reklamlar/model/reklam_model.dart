import 'package:cloud_firestore/cloud_firestore.dart';

class ReklamModel {
  final String reklamId;
  final String baslik;
  final String aciklama;
  final String acenteAdi;
  final String? gorselURL;
  final DateTime reklaminGecerliOlduguTarih;
  final Timestamp? olusturmaTarihi;
  final bool reklamDurumu;

  ReklamModel({
    required this.reklamId,
    required this.baslik,
    required this.aciklama,
    required this.acenteAdi,
    this.gorselURL,
    required this.reklaminGecerliOlduguTarih,
    this.olusturmaTarihi,
    required this.reklamDurumu,
  });

  factory ReklamModel.fromMap(Map<String, dynamic> data) {
    return ReklamModel(
      reklamId: data['reklamId'] ?? ' Hata: Reklam ID bulunamadı',
      baslik: data['baslik'] ?? ' Hata: Başlık bulunamadı',
      aciklama: data['aciklama'] ?? ' Hata: Açıklama bulunamadı',
      acenteAdi: data['acenteAdi'] ?? ' Hata: Acenta adı bulunamadı',
      gorselURL: data['gorselURL'] != null ? data['gorselURL'] as String : null,
      reklaminGecerliOlduguTarih: (data['reklaminGecerliOlduguTarih'] as Timestamp).toDate(),
      olusturmaTarihi: data['olusturma_tarihi'] ?? Timestamp.now(),
      reklamDurumu: data['reklamDurumu'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reklamId': reklamId,
      'baslik': baslik,
      'aciklama': aciklama,
      'acenteAdi': acenteAdi,
      'gorselURL': gorselURL,
      'reklaminGecerliOlduguTarih': reklaminGecerliOlduguTarih,
      'olusturma_tarihi': olusturmaTarihi,
      'reklamDurumu': reklamDurumu,
    };
  }
}
