import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/view/finans_detay_view.dart';
import 'package:ozel_sirket_admin/Features/Finans/view/finans_guncelle_view.dart';

class FinansCard extends StatelessWidget {
  final FinansalModel finans;

  const FinansCard({super.key, required this.finans});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: ListTile(
        title: Text(
          finans.turAdi,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.blue),
              tooltip: "Rapor",
              onPressed: () {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FinansRaporView(finansListesi: [finans]),
                  ),
                ); */
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: "Güncelle",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FinansGuncelleView(finans: finans),
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FinansDetayView(finans: finans),
            ),
          );
        },
      ),
    );
  }
}
