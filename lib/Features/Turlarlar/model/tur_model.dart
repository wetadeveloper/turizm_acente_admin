import 'package:cloud_firestore/cloud_firestore.dart';

class TurModelAdmin {
  String? turID;
  String? turAdi;
  String? acentaAdi;
  DateTime? tarih;
  String? yolculukTuru;
  String? havaYolu;
  String? turSuresi;
  int? kapasite;

  // 🔥 Bunlar default boş liste olacak
  List<String> turDetaylari;
  List<String> fiyataDahilHizmetler;
  List<String> imageUrls;
  List<Map<String, dynamic>> otelSecenekleri;

  bool? turYayinda;
  bool? turOnayi;
  String? turKoleksiyonIsimleri;
  String? mevcutSehir;
  String? gidecekSehir;
  String? acenteIpAdresi;
  DateTime? turunOlusturulmaTarihi;

  String currency;
  Map<String, int>? odaFiyatlari;

  TurModelAdmin({
    this.turID,
    this.turAdi,
    this.acentaAdi,
    this.tarih,
    this.yolculukTuru,
    this.havaYolu,
    this.turSuresi,
    this.kapasite,
    this.turYayinda = true,
    this.turOnayi = false,
    this.turKoleksiyonIsimleri,
    this.mevcutSehir,
    this.gidecekSehir,
    this.acenteIpAdresi,
    this.turunOlusturulmaTarihi,
    this.odaFiyatlari,
    this.currency = "Dolar",

    // 👇 Varsayılan boş listeler
    this.turDetaylari = const [],
    this.fiyataDahilHizmetler = const [],
    this.imageUrls = const [],
    this.otelSecenekleri = const [],
  });

  factory TurModelAdmin.fromMap(Map<String, dynamic> map) {
    return TurModelAdmin(
      turAdi: map['tur_adi'],
      acentaAdi: map['acenta_adi'],
      tarih: map['tarih'] is Timestamp
          ? (map['tarih'] as Timestamp).toDate()
          : null,
      yolculukTuru: map['yolculuk_turu'],
      havaYolu: map['hava_yolu'],
      turSuresi: map['tur_suresi'],
      kapasite: map['kapasite'],
      mevcutSehir: map['turunkalkacagiSehir'],
      gidecekSehir: map['turungidecegiSehir'],
      turYayinda: map['tur_yayinda'],
      turOnayi: map['tur_onayi'],

      // 🔥 Firestore'dan okurken null ise boş liste döndür
      turDetaylari:
          (map['turDetaylari'] as List?)?.map((e) => e.toString()).toList() ??
              [],
      fiyataDahilHizmetler: (map['fiyataDahilHizmetler'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrls:
          (map['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      otelSecenekleri: (map['otelSecenekleri'] as List?)
              ?.map((otel) => Map<String, dynamic>.from(otel))
              .toList() ??
          [],

      turID: map['turID'],
      turKoleksiyonIsimleri: map['turKoleksiyonIsimleri'],
      acenteIpAdresi: map['Acente_ipAdresi'],
      turunOlusturulmaTarihi: map['turunOlusturulmaTarihi'] is Timestamp
          ? (map['turunOlusturulmaTarihi'] as Timestamp).toDate()
          : null,
      odaFiyatlari: map['odaFiyatlari'] != null
          ? Map<String, int>.from(map['odaFiyatlari'])
          : null,
      currency: map['currency'] ?? "Dolar",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'turID': turID,
      'tur_adi': turAdi,
      'acenta_adi': acentaAdi,
      'tarih': tarih,
      'yolculuk_turu': yolculukTuru,
      'hava_yolu': havaYolu,
      'tur_suresi': turSuresi,
      'kapasite': kapasite,
      'turDetaylari': turDetaylari,
      'fiyataDahilHizmetler': fiyataDahilHizmetler,
      'imageUrls': imageUrls,
      'otelSecenekleri': otelSecenekleri,
      'tur_yayinda': turYayinda,
      'tur_onayi': turOnayi,
      'turKoleksiyonIsimleri': turKoleksiyonIsimleri,
      'turunkalkacagiSehir': mevcutSehir,
      'turungidecegiSehir': gidecekSehir,
      'Acente_ipAdresi': acenteIpAdresi,
      'turunOlusturulmaTarihi': turunOlusturulmaTarihi,
      'odaFiyatlari': odaFiyatlari,
      'currency': currency,
    };
  }

  TurModelAdmin copyWith({
    String? turID,
    String? turAdi,
    String? acentaAdi,
    Map<String, int>? odaFiyatlari,
    DateTime? tarih,
    bool? turYayinda,
    String? yolculukTuru,
    String? havaYolu,
    String? turSuresi,
    int? kapasite,
    List<String>? turDetaylari,
    List<String>? fiyataDahilHizmetler,
    List<String>? imageUrls,
    List<Map<String, dynamic>>? otelSecenekleri,
    bool? turOnayi,
    String? turKoleksiyonIsimleri,
    String? mevcutSehir,
    String? gidecekSehir,
    String? acenteIpAdresi,
    DateTime? turunOlusturulmaTarihi,
    String? currency,
  }) {
    return TurModelAdmin(
      turID: turID ?? this.turID,
      turAdi: turAdi ?? this.turAdi,
      acentaAdi: acentaAdi ?? this.acentaAdi,
      odaFiyatlari: odaFiyatlari ?? this.odaFiyatlari,
      tarih: tarih ?? this.tarih,
      turYayinda: turYayinda ?? this.turYayinda,
      yolculukTuru: yolculukTuru ?? this.yolculukTuru,
      havaYolu: havaYolu ?? this.havaYolu,
      turSuresi: turSuresi ?? this.turSuresi,
      kapasite: kapasite ?? this.kapasite,
      turDetaylari: turDetaylari ?? this.turDetaylari,
      fiyataDahilHizmetler: fiyataDahilHizmetler ?? this.fiyataDahilHizmetler,
      imageUrls: imageUrls ?? this.imageUrls,
      otelSecenekleri: otelSecenekleri ?? this.otelSecenekleri,
      turOnayi: turOnayi ?? this.turOnayi,
      currency: currency ?? this.currency,
      turKoleksiyonIsimleri:
          turKoleksiyonIsimleri ?? this.turKoleksiyonIsimleri,
      mevcutSehir: mevcutSehir ?? this.mevcutSehir,
      gidecekSehir: gidecekSehir ?? this.gidecekSehir,
      acenteIpAdresi: acenteIpAdresi ?? this.acenteIpAdresi,
      turunOlusturulmaTarihi:
          turunOlusturulmaTarihi ?? this.turunOlusturulmaTarihi,
    );
  }
}
