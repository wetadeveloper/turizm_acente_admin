import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/widgets/finans_otel_maliyet_field.dart';
import 'package:ozel_sirket_admin/Features/Finans/widgets/roomkeys.dart';

class FinansFormFields extends StatefulWidget {
  final FinansalModel? initialData;
  final void Function(FinansalModel) onSave;

  const FinansFormFields({super.key, this.initialData, required this.onSave});

  @override
  State<FinansFormFields> createState() => _FinansFormFieldsState();
}

class _FinansFormFieldsState extends State<FinansFormFields> {
  final _formKey = GlobalKey<FormState>();

  // --- State ---
  late TextEditingController turAdiCtrl;
  final Map<String, TextEditingController> maliyetCtrl = {};
  String secilenOdaKey = RoomKeys.k2;

  // Oda-tipine göre haritalar
  Map<String, double> mekkeOtelMaliyet = {};
  Map<String, double> medineOtelMaliyet = {};
  Map<String, double> digerSehirOtelMaliyet = {};

  String turTipi = "Umre";
  String selectedCurrency = "Dolar";

  final Map<String, String> currencySymbols = const {
    "Dolar": "\$",
    "Türk Lirası": "₺",
    "Euro": "€",
  };

  // Numerik alanlar için tek seferde liste:
  static const List<String> _numericKeys = [
    "ucusMaliyet",
    "karayoluMaliyet",
    "yemekMaliyet",
    "vizeMaliyet",
    "rehberMaliyet",
    "sigortaMaliyet",
    "personelMaliyet",
    "promosyonMaliyet",
    "digerMaliyet",
    "suraMaliyet",
    "kurbanMaliyet",
    "muzeGirisMaliyet",
    "ekstraAktiviteMaliyet",
    "diyanetKarti",
  ];

  @override
  void initState() {
    super.initState();
    turAdiCtrl = TextEditingController(text: widget.initialData?.turAdi ?? "");
    turTipi = widget.initialData?.turTipi ?? "Umre";
    selectedCurrency = widget.initialData?.currency ?? "Dolar";

    // Eski kayıtlar “2’li Oda” anahtarındaysa bunları içeri alırken dönüştürmek istersen:
    Map<String, double> fixKeys(Map<String, double> m) {
      // İstersen burada "2’li Oda" -> '2li' gibi dönüşüm yapabilirsin.
      return {
        RoomKeys.k2: m[RoomKeys.k2] ?? m["2’li Oda"] ?? 0,
        RoomKeys.k3: m[RoomKeys.k3] ?? m["3’lü Oda"] ?? 0,
        RoomKeys.k4: m[RoomKeys.k4] ?? m["4’lü Oda"] ?? 0,
      };
    }

    mekkeOtelMaliyet = fixKeys(widget.initialData?.mekkeOtelMaliyet ?? {});
    medineOtelMaliyet = fixKeys(widget.initialData?.medineOtelMaliyet ?? {});
    digerSehirOtelMaliyet =
        fixKeys(widget.initialData?.digerSehirOtelMaliyet ?? {});

    for (final key in _numericKeys) {
      final initial = _initialNumericValueForKey(key);
      final c = TextEditingController(text: initial == 0 ? "" : "$initial")
        ..addListener(() => setState(() {}));
      maliyetCtrl[key] = c;
    }
  }

  double _initialNumericValueForKey(String key) {
    final d = widget.initialData;
    if (d == null) return 0;
    switch (key) {
      case "ucusMaliyet":
        return d.ucusMaliyet;
      case "karayoluMaliyet":
        return d.karayoluMaliyet;
      case "yemekMaliyet":
        return d.yemekMaliyet;
      case "vizeMaliyet":
        return d.vizeMaliyet;
      case "rehberMaliyet":
        return d.rehberMaliyet;
      case "sigortaMaliyet":
        return d.sigortaMaliyet;
      case "personelMaliyet":
        return d.personelMaliyet;
      case "promosyonMaliyet":
        return d.promosyonMaliyet;
      case "digerMaliyet":
        return d.digerMaliyet;
      case "suraMaliyet":
        return d.suraMaliyet;
      case "kurbanMaliyet":
        return d.kurbanMaliyet;
      case "muzeGirisMaliyet":
        return d.muzeGirisMaliyet;
      case "ekstraAktiviteMaliyet":
        return d.ekstraAktiviteMaliyet;
      case "diyanetKarti":
        return d.diyanetKarti;
      default:
        return 0;
    }
  }

  @override
  void dispose() {
    turAdiCtrl.dispose();
    for (var c in maliyetCtrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  // Hangi numerik alanlar görünsün (otel map'leri burada YOK!)
  List<String> _getVisibleNumericFields() {
    if (turTipi == "Umre") {
      return [
        "ucusMaliyet",
        "karayoluMaliyet",
        "yemekMaliyet",
        "vizeMaliyet",
        "rehberMaliyet",
        "sigortaMaliyet",
        "personelMaliyet",
        "promosyonMaliyet",
        "diyanetKarti",
        "digerMaliyet",
      ];
    } else if (turTipi == "Hac") {
      return [
        "ucusMaliyet",
        "karayoluMaliyet",
        "yemekMaliyet",
        "vizeMaliyet",
        "rehberMaliyet",
        "sigortaMaliyet",
        "personelMaliyet",
        "promosyonMaliyet",
        "suraMaliyet",
        "kurbanMaliyet",
        "diyanetKarti",
        "digerMaliyet",
      ];
    } else if (turTipi == "Kültür") {
      return [
        "ucusMaliyet",
        "karayoluMaliyet",
        "yemekMaliyet",
        "vizeMaliyet",
        "rehberMaliyet",
        "sigortaMaliyet",
        "personelMaliyet",
        "promosyonMaliyet",
        "muzeGirisMaliyet",
        "ekstraAktiviteMaliyet",
        "digerMaliyet",
      ];
    }
    // Diğer: tüm numerik alanlar
    return List<String>.from(_numericKeys);
  }

  String _getLabel(String key) {
    switch (key) {
      case "ucusMaliyet":
        return "Uçuş Maliyeti";
      case "karayoluMaliyet":
        return "Kara Yolu / Transfer Maliyeti";
      case "yemekMaliyet":
        return "Yemek Maliyeti";
      case "vizeMaliyet":
        return "Vize İşlemleri";
      case "rehberMaliyet":
        return "Rehber Maliyeti";
      case "sigortaMaliyet":
        return "Seyahat Sigortası";
      case "personelMaliyet":
        return "Personel / Kafile Maliyeti";
      case "promosyonMaliyet":
        return "Promosyon / Broşür / Hediye";
      case "digerMaliyet":
        return "Diğer Giderler";
      case "suraMaliyet":
        return "Şura / Mina Çadırı Gideri";
      case "kurbanMaliyet":
        return "Kurban Gideri";
      case "muzeGirisMaliyet":
        return "Müze Giriş Ücretleri";
      case "ekstraAktiviteMaliyet":
        return "Ekstra Aktivite Giderleri";
      case "diyanetKarti":
        return "Diyanet Kartı";
      default:
        return key;
    }
  }

  // Oda bazlı toplamlar
  Map<String, double> get toplamMaliyetByOda {
    final Map<String, double> result = {};
    for (final room in RoomKeys.all) {
      double total = 0;
      total += (mekkeOtelMaliyet[room] ?? 0);
      total += (medineOtelMaliyet[room] ?? 0);
      total += (digerSehirOtelMaliyet[room] ?? 0);

      // sabit maliyetler
      for (var key in _numericKeys) {
        total += double.tryParse(maliyetCtrl[key]?.text ?? "") ?? 0;
      }
      result[room] = total;
    }
    return result;
  }

// Seçili oda için toplam
  double get toplamMaliyetSeciliOda => toplamMaliyetByOda[secilenOdaKey] ?? 0;

  @override
  Widget build(BuildContext context) {
    final visibleNumericFields = _getVisibleNumericFields();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // TUR TİPİ
              DropdownButtonFormField<String>(
                initialValue: turTipi,
                items: ["Umre", "Hac", "Kültür", "Diğer"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => turTipi = val!),
                decoration: const InputDecoration(
                  labelText: "Tur Tipi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // ODA TİPİ
              DropdownButtonFormField<String>(
                initialValue: secilenOdaKey,
                decoration: const InputDecoration(
                  labelText: "Önizleme: Oda Tipi",
                  border: OutlineInputBorder(),
                ),
                items: RoomKeys.all
                    .map((k) => DropdownMenuItem(
                        value: k, child: Text(RoomKeys.label(k))))
                    .toList(),
                onChanged: (val) => setState(() => secilenOdaKey = val!),
              ),
              const SizedBox(height: 12),

              // TUR ADI
              TextFormField(
                controller: turAdiCtrl,
                decoration: const InputDecoration(
                  labelText: "Tur Adı",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Boş bırakılamaz" : null,
              ),
              const SizedBox(height: 20),

              // PARA BİRİMİ
              DropdownButtonFormField<String>(
                initialValue: selectedCurrency,
                decoration: const InputDecoration(
                  labelText: "Para Birimi",
                  border: OutlineInputBorder(),
                ),
                items: ["Dolar", "Türk Lirası", "Euro"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCurrency = val!),
              ),

              const SizedBox(height: 20),

              const Text(
                "Maliyet Kalemleri",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),

              // --- Otel Maliyetleri (oda tipine göre) ---
              if (turTipi == "Umre" || turTipi == "Hac") ...[
                OtelMaliyetField(
                  label: "Mekke Otel Maliyetleri",
                  initialData: mekkeOtelMaliyet,
                  onChanged: (map) => setState(() {
                    mekkeOtelMaliyet = map;
                  }),
                ),
                OtelMaliyetField(
                  label: "Medine Otel Maliyetleri",
                  initialData: medineOtelMaliyet,
                  onChanged: (map) => setState(() {
                    medineOtelMaliyet = map;
                  }),
                ),
              ] else if (turTipi == "Kültür") ...[
                OtelMaliyetField(
                  label: "Diğer Şehir Otel Maliyetleri",
                  initialData: digerSehirOtelMaliyet,
                  onChanged: (map) => setState(() {
                    digerSehirOtelMaliyet = map;
                  }),
                ),
              ],

              // --- Diğer numerik alanlar ---
              ...visibleNumericFields.map((field) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    controller: maliyetCtrl[field],
                    decoration: InputDecoration(
                      labelText: _getLabel(field),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                );
              }),

              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Oda Tipine Göre Toplam Maliyet",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      for (final room in RoomKeys.all)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(RoomKeys.label(room)),
                            Text(
                              "${toplamMaliyetByOda[room]!.toStringAsFixed(2)} ${currencySymbols[selectedCurrency]}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

// Seçili oda için büyük yazı
              Text(
                "Seçili Oda Toplam: ${toplamMaliyetSeciliOda.toStringAsFixed(2)} ${currencySymbols[selectedCurrency]}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final model = FinansalModel(
                      finansId: widget.initialData?.finansId ?? "",
                      turId: widget.initialData?.turId ?? "",
                      turAdi: turAdiCtrl.text,
                      turTipi: turTipi,
                      currency: selectedCurrency,

                      mekkeOtelMaliyet: mekkeOtelMaliyet,
                      medineOtelMaliyet: medineOtelMaliyet,
                      digerSehirOtelMaliyet: digerSehirOtelMaliyet,

                      ucusMaliyet: _parse(maliyetCtrl["ucusMaliyet"]?.text),
                      karayoluMaliyet:
                          _parse(maliyetCtrl["karayoluMaliyet"]?.text),
                      yemekMaliyet: _parse(maliyetCtrl["yemekMaliyet"]?.text),
                      vizeMaliyet: _parse(maliyetCtrl["vizeMaliyet"]?.text),
                      rehberMaliyet: _parse(maliyetCtrl["rehberMaliyet"]?.text),
                      sigortaMaliyet:
                          _parse(maliyetCtrl["sigortaMaliyet"]?.text),
                      personelMaliyet:
                          _parse(maliyetCtrl["personelMaliyet"]?.text),
                      promosyonMaliyet:
                          _parse(maliyetCtrl["promosyonMaliyet"]?.text),
                      digerMaliyet: _parse(maliyetCtrl["digerMaliyet"]?.text),
                      suraMaliyet: _parse(maliyetCtrl["suraMaliyet"]?.text),
                      kurbanMaliyet: _parse(maliyetCtrl["kurbanMaliyet"]?.text),
                      muzeGirisMaliyet:
                          _parse(maliyetCtrl["muzeGirisMaliyet"]?.text),
                      ekstraAktiviteMaliyet:
                          _parse(maliyetCtrl["ekstraAktiviteMaliyet"]?.text),
                      diyanetKarti: _parse(maliyetCtrl["diyanetKarti"]?.text),

                      // Seçili oda için toplam (mevcut şemanı bozmadan)
                      toplamMaliyet: toplamMaliyetSeciliOda,
                      guncellemeTarihi: DateTime.now(),
                    );

                    widget.onSave(model);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _parse(String? v) => double.tryParse(v ?? "") ?? 0;
}
