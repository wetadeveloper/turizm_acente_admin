import 'package:cloud_firestore/cloud_firestore.dart';

class KampanyaModel {
  final String kampanyaId;
  final String aciklama;
  final String baslik;
  final String detaylar;
  final bool kampanyaDurumu;
  final DateTime baslangicTarih;
  final DateTime bitisTarih;
  final DateTime? olusturmaTarihi;
  final DateTime? guncellemeTarihi;

  KampanyaModel(
      {required this.kampanyaId,
      required this.baslik,
      required this.detaylar,
      required this.baslangicTarih,
      required this.bitisTarih,
      this.olusturmaTarihi,
      this.guncellemeTarihi,
      required this.kampanyaDurumu,
      required this.aciklama});

  factory KampanyaModel.fromMap(Map<String, dynamic> data) {
    return KampanyaModel(
      kampanyaId: data['kampanyaId'] ?? ' Hata: Kampanya ID bulunamadı',
      baslik: data['title'] ?? ' Hata: Başlık bulunamadı',
      detaylar: data['details'] ?? ' Hata: Detaylar bulunamadı',
      baslangicTarih: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bitisTarih: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      kampanyaDurumu: data['isActive'] ?? false,
      aciklama: data['description'] ?? ' Hata: Açıklama bulunamadı',
      olusturmaTarihi: (data['createdAt'] as Timestamp?)?.toDate(),
      guncellemeTarihi: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kampanyaId': kampanyaId,
      'title': baslik,
      'details': detaylar,
      'startDate': Timestamp.fromDate(baslangicTarih),
      'endDate': Timestamp.fromDate(bitisTarih),
      'isActive': kampanyaDurumu,
      'description': aciklama,
      'createdAt': olusturmaTarihi,
      'updatedAt': guncellemeTarihi,
    };
  }
}
