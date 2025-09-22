class HakkindaModel {
  // ---- Required ----
  final String sirketAdi;
  final String sahibiAdi;
  final String adres;
  final String telefon;
  final String eposta;

  // ---- Opsiyonel ----
  final String? yetkiliKisi;
  final String? vergiNo;
  final String? vergiDairesi;
  final String? ticaretSicilNo;
  final String? turizmBakanlikBelgeNo;
  final String? tursabBelgeNo;
  final String? webSite;
  final List<BankaBilgisi> bankaBilgileri;
  final String? aciklama;

  HakkindaModel({
    required this.sirketAdi,
    required this.sahibiAdi,
    required this.adres,
    required this.telefon,
    required this.eposta,
    this.yetkiliKisi,
    this.vergiNo,
    this.vergiDairesi,
    this.ticaretSicilNo,
    this.turizmBakanlikBelgeNo,
    this.tursabBelgeNo,
    this.webSite,
    this.bankaBilgileri = const [],
    this.aciklama,
  });

  Map<String, dynamic> toJson() => {
        "sirketAdi": sirketAdi,
        "sahibiAdi": sahibiAdi,
        "adres": adres,
        "telefon": telefon,
        "eposta": eposta,
        "yetkiliKisi": yetkiliKisi,
        "vergiNo": vergiNo,
        "vergiDairesi": vergiDairesi,
        "ticaretSicilNo": ticaretSicilNo,
        "turizmBakanlikBelgeNo": turizmBakanlikBelgeNo,
        "tursabBelgeNo": tursabBelgeNo,
        "webSite": webSite,
        "bankaBilgileri": bankaBilgileri.map((e) => e.toJson()).toList(),
        "aciklama": aciklama,
      };

  factory HakkindaModel.fromJson(Map<String, dynamic> json) => HakkindaModel(
        sirketAdi: json["sirketAdi"],
        sahibiAdi: json["sahibiAdi"],
        adres: json["adres"],
        telefon: json["telefon"],
        eposta: json["eposta"],
        yetkiliKisi: json["yetkiliKisi"],
        vergiNo: json["vergiNo"],
        vergiDairesi: json["vergiDairesi"],
        ticaretSicilNo: json["ticaretSicilNo"],
        turizmBakanlikBelgeNo: json["turizmBakanlikBelgeNo"],
        tursabBelgeNo: json["tursabBelgeNo"],
        webSite: json["webSite"],
        bankaBilgileri: (json["bankaBilgileri"] as List<dynamic>? ?? [])
            .map((e) => BankaBilgisi.fromJson(e))
            .toList(),
        aciklama: json["aciklama"],
      );
}

class BankaBilgisi {
  final String bankaAdi;
  final String iban;
  final String hesapTuru; // Örn: "TL", "USD", "EUR"
  final String hesapAdi;

  BankaBilgisi({
    required this.bankaAdi,
    required this.iban,
    required this.hesapTuru,
    required this.hesapAdi,
  });

  Map<String, dynamic> toJson() => {
        "bankaAdi": bankaAdi,
        "hesapAdi": hesapAdi,
        "iban": iban,
        "hesapTuru": hesapTuru,
      };

  factory BankaBilgisi.fromJson(Map<String, dynamic> json) => BankaBilgisi(
        bankaAdi: json["bankaAdi"] ?? "",
        iban: json["iban"] ?? "",
        hesapTuru: json["hesapTuru"] ?? "",
        hesapAdi: json["hesapAdi"] ?? "",
      );
}
