import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/turlar_view_model.dart';
import 'package:provider/provider.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/view/tur_guncelle_view.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/view/tur_ekleme_view.dart';
import 'package:intl/intl.dart';

class TurlarView extends StatelessWidget {
  const TurlarView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> currencySymbols = {
      "Dolar": "\$",
      "Türk Lirası": "₺",
      "Euro": "€",
    };
    return ChangeNotifierProvider(
      create: (_) => TurlarViewModel()..initDinleme(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.turlarTitle,
              style: TextStyle(
                  color: AppColors.title, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: AppColors.icon),
        ),
        body: Consumer<TurlarViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.tumTurlar.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: viewModel.tumTurlar.entries.map((entry) {
                  final koleksiyon = entry.key;
                  final turListesi = entry.value;

                  if (turListesi.isEmpty) return const SizedBox();

                  return Column(
                    children: turListesi.map((tur) {
                      return Dismissible(
                        key: Key(tur.turID ?? tur.turAdi ?? 'Tur ID Yok'),
                        onDismissed: (_) {
                          viewModel.deleteTur(koleksiyon, tur.turID ?? '');
                        },
                        child: InkWell(
                          onTap: () {
                            if (tur.turID == null || tur.turID!.isEmpty) {
                              debugPrint(
                                  "HATA: turID boş, güncelleme sayfasına gidilemiyor!");
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TurGuncelleSayfasi(
                                  turID: tur.turID!,
                                  koleksiyonAdi: koleksiyon,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.red.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TurlarViewModel.getTravelIcon(
                                          tur.yolculukTuru),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 0,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                        ),
                                        child: Text(
                                          tur.turAdi ?? '',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios,
                                          color: Colors.white),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tur.acentaAdi ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Tarih: ",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey.shade100,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd/MM').format(
                                                tur.tarih ?? DateTime.now()),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          TurlarViewModel.getTravelIcon(
                                              koleksiyon),
                                          const SizedBox(width: 5),
                                          Text(
                                            viewModel.turKoleksiyonIsimleri[
                                                    koleksiyon] ??
                                                '',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "İki'li oda: ${tur.odaFiyatlari?['Ikili']} ${currencySymbols[tur.currency] ?? tur.currency}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => TurEkle()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
