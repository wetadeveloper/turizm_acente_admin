class OtelModel {
  final String odaId; // firestore document id
  final String odaTipi; // "2li", "3lu", "4lu" gibi
  final String odaNumarasi; // örn: "Oda 1"
  final List<String>? musteriIdListesi; // sadece ID’ler
  final List<String> musteriIsmiListesi; // müşteri isimleri, opsiyonel
  final String? notlar;

  OtelModel({
    required this.odaId,
    required this.odaTipi,
    required this.odaNumarasi,
    required this.musteriIdListesi,
    required this.musteriIsmiListesi,
    this.notlar,
  });

  factory OtelModel.fromMap(Map<String, dynamic> map, String docId) {
    return OtelModel(
      odaId: docId,
      odaTipi: map['odaTipi'] ?? '',
      odaNumarasi: map['odaNumarasi'] ?? '',
      musteriIdListesi: List<String>.from(map['musteriIdListesi'] ?? []),
      musteriIsmiListesi: List<String>.from(map['musteriIsmiListesi'] ?? []),
      notlar: map['notlar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'odaTipi': odaTipi,
      'odaNumarasi': odaNumarasi,
      'musteriIdListesi': musteriIdListesi,
      'musteriIsmiListesi': musteriIsmiListesi,
      'notlar': notlar,
    };
  }

  OtelModel copyWith({
    String? odaId,
    String? odaTipi,
    String? odaNumarasi,
    List<String>? musteriIdListesi,
    List<String>? musteriIsmiListesi,
    String? notlar,
  }) {
    return OtelModel(
      odaId: odaId ?? this.odaId,
      odaTipi: odaTipi ?? this.odaTipi,
      odaNumarasi: odaNumarasi ?? this.odaNumarasi,
      musteriIdListesi: musteriIdListesi ?? this.musteriIdListesi,
      musteriIsmiListesi: musteriIsmiListesi ?? this.musteriIsmiListesi,
      notlar: notlar ?? this.notlar,
    );
  }
}
