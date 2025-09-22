import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/view/borcu_olanlar_view.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/view/rezervasyon_ekle_view.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/view/rezervasyon_guncelle_view.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/rezervasyonlar_view_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/rezervasyon_ekle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/rezervasyon_guncelle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/widgets/rezervasyon_card.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';
import 'package:provider/provider.dart';

class RezervasyonlarView extends StatelessWidget {
  const RezervasyonlarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RezervasyonlarViewModel(),
      child: Consumer<RezervasyonlarViewModel>(builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.rezervasyonTitle,
                style: TextStyle(
                    color: AppColors.title, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: AppColors.icon),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BorcluMusterilerView(),
                    ),
                  );
                },
                icon: const Icon(Icons.money_off),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => RezervasyonEkleViewModel(),
                      child: const RezervasyonEkleView(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add)),
          body: StreamBuilder<List<RezervasyonModel>>(
              stream: RezervasyonlarViewModel.rezervasyonlariDinle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final rezervasyonlar = snapshot.data ?? [];

                if (rezervasyonlar.isEmpty) {
                  return const Center(child: Text("Henüz rezervasyon yok."));
                }

                // Turlara göre grupla
                final Map<String, List<RezervasyonModel>> gruplar = {};
                for (var rez in rezervasyonlar) {
                  gruplar.putIfAbsent(rez.turAdi, () => []).add(rez);
                }

                final sortedGruplar = gruplar.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key));

                return ListView(
                  children: sortedGruplar.map((entry) {
                    final turAdi = entry.key;
                    final turRezervasyonlari = entry.value;

                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(turAdi),
                          IconButton(
                            icon: const Icon(Icons.print),
                            tooltip: "$turAdi listesini yazdır",
                            onPressed: () {
                              Provider.of<RezervasyonlarViewModel>(context,
                                      listen: false)
                                  .yazdirTurListesi(turAdi, turRezervasyonlari);
                            },
                          ),
                        ],
                      ),
                      children: turRezervasyonlari.map((rezervasyon) {
                        return RezervasyonCard(
                          rezervasyon: rezervasyon,
                          onSil: () async {
                            await Provider.of<RezervasyonlarViewModel>(context,
                                    listen: false)
                                .rezervasyonSil(rezervasyon.rezervasyonId);
                          },
                          onGuncelle: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => RezervasyonGuncelleViewModel()
                                    ..initFromModel(rezervasyon),
                                  child: RezervasyonGuncelleView(
                                      rezervasyon: rezervasyon),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              }),
        );
      }),
    );
  }
}
