import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/view/finans_ekle_view.dart';
import 'package:ozel_sirket_admin/Features/Finans/view/finans_detay_view.dart';
import 'package:ozel_sirket_admin/Features/Finans/view/finans_guncelle_view.dart';
import 'package:ozel_sirket_admin/Features/Finans/viewModel/finans_viewmodel.dart';
import 'package:provider/provider.dart';

class FinansAnasayfaView extends StatelessWidget {
  const FinansAnasayfaView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> currencySymbols = {
      "Dolar": "\$",
      "Türk Lirası": "₺",
      "Euro": "€",
    };

    return ChangeNotifierProvider(
      create: (_) => FinansListeViewModel()..fetchFinansal(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            AppStrings.finansalTitle,
            style: TextStyle(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.icon),
          centerTitle: true,
        ),
        body: Consumer<FinansListeViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (model.hataMesaji != null) {
              return Center(child: Text("Hata: ${model.hataMesaji}"));
            }
            if (model.finansListesi.isEmpty) {
              return const Center(
                child: Text("Henüz maliyet kaydı bulunmamaktadır."),
              );
            }

            return ListView.builder(
              itemCount: model.finansListesi.length,
              itemBuilder: (context, index) {
                final finansData = model.finansListesi[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      finansData.turAdi,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Tur Tipi: ${finansData.turTipi}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Fazla yer kaplamasın
                      children: [
                        if (finansData.toplamMaliyetByOda.isNotEmpty)
                          Text(
                            "${finansData.toplamMaliyetByOda.entries.first.key}: "
                            "${finansData.toplamMaliyetByOda.entries.first.value} "
                            "${currencySymbols[finansData.currency] ?? finansData.currency}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "detay") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FinansDetayView(finans: finansData),
                                ),
                              );
                            } else if (value == "guncelle") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FinansGuncelleView(finans: finansData),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: "detay", child: Text("Detay")),
                            PopupMenuItem(
                                value: "guncelle", child: Text("Güncelle")),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FinansEkleView()),
            );
          },
          tooltip: "Yeni Maliyet Ekle",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
