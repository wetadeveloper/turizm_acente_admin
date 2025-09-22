import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/model/hakkinda_model.dart';

class HakkindaSirketCard extends StatelessWidget {
  final HakkindaModel data;

  const HakkindaSirketCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.sirketAdi,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _infoRow(Icons.person, "Sahibi", data.sahibiAdi),
            _infoRow(Icons.location_on, "Adres", data.adres),
            _infoRow(Icons.phone, "Telefon", data.telefon),
            _infoRow(Icons.email, "E-posta", data.eposta),
            _infoRow(Icons.person_pin, "Yetkili", data.yetkiliKisi ?? "-"),
            _infoRow(Icons.business, "Vergi Dairesi", data.vergiDairesi ?? "-"),
            _infoRow(Icons.numbers, "Vergi No", data.vergiNo ?? "-"),
            _infoRow(
                Icons.numbers, "Ticaret Sicil No", data.ticaretSicilNo ?? "-"),
            _infoRow(Icons.badge, "Turizm Belge No",
                data.turizmBakanlikBelgeNo ?? "-"),
            _infoRow(Icons.card_membership, "TÜRSAB Belge No",
                data.tursabBelgeNo ?? "-"),
            _infoRow(Icons.language, "Website", data.webSite ?? "-"),
            const SizedBox(height: 8),
            Text(data.aciklama ?? "-",
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

Widget _infoRow(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Expanded(
            child: Text("$label: $value", style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
