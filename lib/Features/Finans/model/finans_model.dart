import 'package:cloud_firestore/cloud_firestore.dart';

class FinansalModel {
  final String finansId; // Belge ID
  final String turId; // İlgili Tur
  final String turAdi; // İlgili Tur Adı

  // Otel maliyetleri (oda tipine göre)
  final Map<String, double> mekkeOtelMaliyet;
  final Map<String, double> medineOtelMaliyet;
  final Map<String, double> digerSehirOtelMaliyet;

  final double ucusMaliyet;
  final double karayoluMaliyet;
  final double yemekMaliyet;
  final double vizeMaliyet;
  final double rehberMaliyet;
  final double sigortaMaliyet;
  final double personelMaliyet;
  final double promosyonMaliyet;
  final double digerMaliyet;
  final double diyanetKarti;

  final String turTipi;

  // Hacca özgü
  final double suraMaliyet;
  final double kurbanMaliyet;

  // Kültür turuna özgü
  final double muzeGirisMaliyet;
  final double ekstraAktiviteMaliyet;

  final String currency; // "Dolar", "Türk Lirası", "Euro"

  final DateTime? olusturmaTarihi;
  final DateTime? guncellemeTarihi;

  final double toplamMaliyet;

  FinansalModel({
    required this.finansId,
    required this.turId,
    required this.turAdi,
    this.mekkeOtelMaliyet = const {},
    this.medineOtelMaliyet = const {},
    this.digerSehirOtelMaliyet = const {},
    this.ucusMaliyet = 0,
    this.karayoluMaliyet = 0,
    this.yemekMaliyet = 0,
    this.vizeMaliyet = 0,
    this.rehberMaliyet = 0,
    this.sigortaMaliyet = 0,
    this.personelMaliyet = 0,
    this.promosyonMaliyet = 0,
    this.digerMaliyet = 0,
    this.suraMaliyet = 0,
    this.kurbanMaliyet = 0,
    this.muzeGirisMaliyet = 0,
    this.ekstraAktiviteMaliyet = 0,
    this.diyanetKarti = 0,
    this.turTipi = "Umre",
    this.currency = "Türk Lirası",
    this.olusturmaTarihi,
    this.guncellemeTarihi,
    this.toplamMaliyet = 0,
  });

  /// Hesaplanan toplam maliyet
  double get toplamGider =>
      _sumMap(mekkeOtelMaliyet) +
      _sumMap(medineOtelMaliyet) +
      _sumMap(digerSehirOtelMaliyet) +
      ucusMaliyet +
      karayoluMaliyet +
      yemekMaliyet +
      vizeMaliyet +
      rehberMaliyet +
      sigortaMaliyet +
      personelMaliyet +
      promosyonMaliyet +
      suraMaliyet +
      kurbanMaliyet +
      diyanetKarti +
      muzeGirisMaliyet +
      ekstraAktiviteMaliyet +
      digerMaliyet;

  /// Firestore'dan model oluşturma
  factory FinansalModel.fromMap(Map<String, dynamic> data, String docId) {
    final mekkeOtelMaliyet =
        Map<String, double>.from(data['mekkeOtelMaliyet'] ?? {});
    final medineOtelMaliyet =
        Map<String, double>.from(data['medineOtelMaliyet'] ?? {});
    final digerSehirOtelMaliyet =
        Map<String, double>.from(data['digerSehirOtelMaliyet'] ?? {});

    final ucusMaliyet = (data['ucusMaliyet'] as num?)?.toDouble() ?? 0;
    final karayoluMaliyet = (data['karayoluMaliyet'] as num?)?.toDouble() ?? 0;
    final yemekMaliyet = (data['yemekMaliyet'] as num?)?.toDouble() ?? 0;
    final vizeMaliyet = (data['vizeMaliyet'] as num?)?.toDouble() ?? 0;
    final rehberMaliyet = (data['rehberMaliyet'] as num?)?.toDouble() ?? 0;
    final sigortaMaliyet = (data['sigortaMaliyet'] as num?)?.toDouble() ?? 0;
    final personelMaliyet = (data['personelMaliyet'] as num?)?.toDouble() ?? 0;
    final promosyonMaliyet =
        (data['promosyonMaliyet'] as num?)?.toDouble() ?? 0;
    final digerMaliyet = (data['digerMaliyet'] as num?)?.toDouble() ?? 0;
    final suraMaliyet = (data['suraMaliyet'] as num?)?.toDouble() ?? 0;
    final kurbanMaliyet = (data['kurbanMaliyet'] as num?)?.toDouble() ?? 0;
    final muzeGirisMaliyet =
        (data['muzeGirisMaliyet'] as num?)?.toDouble() ?? 0;
    final ekstraAktiviteMaliyet =
        (data['ekstraAktiviteMaliyet'] as num?)?.toDouble() ?? 0;
    final diyanetKarti = (data['diyanetKarti'] as num?)?.toDouble() ?? 0;

    final toplamMaliyet = _sumMap(mekkeOtelMaliyet) +
        _sumMap(medineOtelMaliyet) +
        _sumMap(digerSehirOtelMaliyet) +
        ucusMaliyet +
        karayoluMaliyet +
        yemekMaliyet +
        vizeMaliyet +
        rehberMaliyet +
        sigortaMaliyet +
        personelMaliyet +
        promosyonMaliyet +
        suraMaliyet +
        kurbanMaliyet +
        diyanetKarti +
        muzeGirisMaliyet +
        ekstraAktiviteMaliyet +
        digerMaliyet;

    return FinansalModel(
      finansId: docId,
      turId: data['turId'] ?? '',
      turAdi: data['turAdi'] ?? 'Bilinmiyor',
      mekkeOtelMaliyet: mekkeOtelMaliyet,
      medineOtelMaliyet: medineOtelMaliyet,
      digerSehirOtelMaliyet: digerSehirOtelMaliyet,
      ucusMaliyet: ucusMaliyet,
      karayoluMaliyet: karayoluMaliyet,
      yemekMaliyet: yemekMaliyet,
      vizeMaliyet: vizeMaliyet,
      rehberMaliyet: rehberMaliyet,
      sigortaMaliyet: sigortaMaliyet,
      personelMaliyet: personelMaliyet,
      promosyonMaliyet: promosyonMaliyet,
      digerMaliyet: digerMaliyet,
      suraMaliyet: suraMaliyet,
      kurbanMaliyet: kurbanMaliyet,
      muzeGirisMaliyet: muzeGirisMaliyet,
      ekstraAktiviteMaliyet: ekstraAktiviteMaliyet,
      diyanetKarti: diyanetKarti,
      turTipi: data['turTipi'] ?? "Umre",
      currency: data['currency'] ?? "Türk Lirası",
      olusturmaTarihi: (data['olusturmaTarihi'] as Timestamp?)?.toDate(),
      guncellemeTarihi: (data['guncellemeTarihi'] as Timestamp?)?.toDate(),
      toplamMaliyet: toplamMaliyet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'turId': turId,
      'turAdi': turAdi,
      'mekkeOtelMaliyet': mekkeOtelMaliyet,
      'medineOtelMaliyet': medineOtelMaliyet,
      'digerSehirOtelMaliyet': digerSehirOtelMaliyet,
      'ucusMaliyet': ucusMaliyet,
      'karayoluMaliyet': karayoluMaliyet,
      'yemekMaliyet': yemekMaliyet,
      'vizeMaliyet': vizeMaliyet,
      'rehberMaliyet': rehberMaliyet,
      'sigortaMaliyet': sigortaMaliyet,
      'personelMaliyet': personelMaliyet,
      'promosyonMaliyet': promosyonMaliyet,
      'digerMaliyet': digerMaliyet,
      'suraMaliyet': suraMaliyet,
      'kurbanMaliyet': kurbanMaliyet,
      'muzeGirisMaliyet': muzeGirisMaliyet,
      'ekstraAktiviteMaliyet': ekstraAktiviteMaliyet,
      'diyanetKarti': diyanetKarti,
      'turTipi': turTipi,
      'currency': currency,
      'olusturmaTarihi':
          olusturmaTarihi != null ? Timestamp.fromDate(olusturmaTarihi!) : null,
      'guncellemeTarihi': guncellemeTarihi != null
          ? Timestamp.fromDate(guncellemeTarihi!)
          : null,
      'toplamMaliyet': toplamMaliyet,
    };
  }

  /// Yardımcı fonksiyon: Map<double> toplamı
  static double _sumMap(Map<String, double> map) {
    return map.values.fold(0, (a, b) => a + b);
  }
}

extension FinansalModelExtensions on FinansalModel {
  /// Oda tipine göre toplam maliyet (otel + diğer tüm giderler)
  Map<String, double> get toplamMaliyetByOda {
    final odalar = <String, double>{};

    // tüm odaları topla (mekke, medine, diğer şehir otelleri)
    final tumOdaTipleri = {
      ...mekkeOtelMaliyet.keys,
      ...medineOtelMaliyet.keys,
      ...digerSehirOtelMaliyet.keys,
    };

    for (final oda in tumOdaTipleri) {
      final otelToplam = (mekkeOtelMaliyet[oda] ?? 0) +
          (medineOtelMaliyet[oda] ?? 0) +
          (digerSehirOtelMaliyet[oda] ?? 0);

      // diğer sabit giderleri ekle
      final digerGiderler = ucusMaliyet +
          karayoluMaliyet +
          yemekMaliyet +
          vizeMaliyet +
          rehberMaliyet +
          sigortaMaliyet +
          personelMaliyet +
          promosyonMaliyet +
          suraMaliyet +
          kurbanMaliyet +
          diyanetKarti +
          muzeGirisMaliyet +
          ekstraAktiviteMaliyet +
          digerMaliyet;

      odalar[oda] = otelToplam + digerGiderler;
    }

    return odalar;
  }
}
