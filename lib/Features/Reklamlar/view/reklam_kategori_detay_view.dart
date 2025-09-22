import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/viewModel/reklamlar_view_model.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/model/reklam_model.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/view/reklam_guncelle_view.dart';

class KategoriDetayView extends StatelessWidget {
  final String dokumanAdi;

  const KategoriDetayView({super.key, required this.dokumanAdi});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReklamlarViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            dokumanAdi,
            style: const TextStyle(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.icon),
        ),
        body: Consumer<ReklamlarViewModel>(
          builder: (context, vm, _) {
            return StreamBuilder<List<ReklamModel>>(
              stream: vm.kategoriyeGoreReklamStream(dokumanAdi),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                }

                final reklamlar = snapshot.data ?? [];

                if (reklamlar.isEmpty) {
                  return const Center(
                      child: Text("Bu kategoride hiç reklam yok."));
                }

                return ListView.separated(
                  itemCount: reklamlar.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final reklam = reklamlar[index];
                    final formattedDate = DateFormat.yMMMMd('tr_TR')
                        .format(reklam.reklaminGecerliOlduguTarih);

                    return ListTile(
                      title: Text(reklam.baslik),
                      subtitle:
                          Text('${reklam.aciklama}\nGeçerli: $formattedDate'),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReklamGuncelleView(
                              reklam: reklam,
                              selectedPage: dokumanAdi,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
