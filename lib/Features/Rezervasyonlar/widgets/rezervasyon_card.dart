import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';

class RezervasyonCard extends StatelessWidget {
  final RezervasyonModel rezervasyon;
  final VoidCallback? onSil;
  final VoidCallback? onGuncelle;

  const RezervasyonCard({
    super.key,
    required this.rezervasyon,
    required this.onGuncelle,
    this.onSil,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(rezervasyon.rezervasyonId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Rezervasyonu Sil"),
            content:
                const Text("Bu rezervasyonu silmek istediğinize emin misiniz?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Sil", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onSil?.call();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          title: Text("Müşteri Adı: ${rezervasyon.musteriAdi}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tur Adı: ${rezervasyon.turAdi}"),
              Text(
                "Tarih: ${rezervasyon.rezervasyonTarihi != null ? rezervasyon.rezervasyonTarihi!.toLocal().toString().split(' ')[0] : 'Yok'}",
              ),
              Text(
                  "Kişi: ${rezervasyon.kisiSayisi}, Ücret: ${rezervasyon.toplamUcret} ₺"),
              if (rezervasyon.kalanUcret != null)
                Text("Kalan: ${rezervasyon.kalanUcret} ₺"),
              Text("Konaklama: ${rezervasyon.konaklamaTipi}"),
              Text(
                  "Çanta Verildi mi: ${rezervasyon.cantaVerildiMi ? "Evet" : "Hayır"}"),
              if (rezervasyon.notlar != null)
                Text("Not: ${rezervasyon.notlar}"),
            ],
          ),
          onLongPress: onGuncelle,
        ),
      ),
    );
  }
}
