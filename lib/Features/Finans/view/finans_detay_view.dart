import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/viewModel/finans_viewmodel.dart';

class FinansDetayView extends StatefulWidget {
  final FinansalModel finans;

  const FinansDetayView({super.key, required this.finans});

  @override
  State<FinansDetayView> createState() => _FinansDetayViewState();
}

class _FinansDetayViewState extends State<FinansDetayView> {
  late Future<FinansalModel?> _future;

  @override
  void initState() {
    super.initState();
    final vm = FinansDetayViewModel();
    _future = vm.getirFinansalDetay(widget.finans.finansId);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> currencySymbols = {
      "Dolar": "\$",
      "Türk Lirası": "₺",
      "Euro": "€",
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          AppStrings.finansDetayTitle,
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.icon),
        centerTitle: true,
      ),
      body: FutureBuilder<FinansalModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Veri bulunamadı"));
          }

          final finans = snapshot.data!;

          // Gösterilecek alanlar
          final Map<String, dynamic> bilgiler = {
            "Tur Adı": finans.turAdi,
            "Tur Tipi": finans.turTipi,
            "Mekke Otel": finans.mekkeOtelMaliyet,
            "Medine Otel": finans.medineOtelMaliyet,
            "Diğer Şehir Otel": finans.digerSehirOtelMaliyet,
            "Uçuş": finans.ucusMaliyet,
            "Kara Yolu": finans.karayoluMaliyet,
            "Yemek": finans.yemekMaliyet,
            "Vize": finans.vizeMaliyet,
            "Rehber": finans.rehberMaliyet,
            "Sigorta": finans.sigortaMaliyet,
            "Personel": finans.personelMaliyet,
            "Promosyon": finans.promosyonMaliyet,
            "Sura": finans.suraMaliyet,
            "Kurban": finans.kurbanMaliyet,
            "Müze Giriş": finans.muzeGirisMaliyet,
            "Ekstra Aktivite": finans.ekstraAktiviteMaliyet,
            "Diyanet Kartı": finans.diyanetKarti,
            "Diğer": finans.digerMaliyet,
            "Para Birimi": currencySymbols[finans.currency] ?? finans.currency,
            for (final entry in finans.toplamMaliyetByOda.entries)
              "Toplam (${entry.key})":
                  "${entry.value} ${currencySymbols[finans.currency] ?? finans.currency}",
          };

          // Null veya 0 olanları filtrele
          final goruntulenecek = bilgiler.entries.where((e) {
            final value = e.value;
            if (value == null) return false;
            if (value is num && value == 0) return false;
            if (value is String &&
                (value.trim().isEmpty || value.contains("0 "))) {
              return false;
            }
            return true;
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: goruntulenecek.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 12, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final item = goruntulenecek[index];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        item.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        "${item.value}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- ODA TOPLAMLARI CARD ---
              if (finans.toplamMaliyetByOda.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Oda Tipine Göre Toplam Maliyet",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          for (final entry in finans.toplamMaliyetByOda.entries)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key),
                                Text(
                                  "${entry.value.toStringAsFixed(2)} ${currencySymbols[finans.currency] ?? finans.currency}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
