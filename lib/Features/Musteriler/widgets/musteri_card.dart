import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';

class MusteriCard extends StatelessWidget {
  final MusteriModel musteri;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const MusteriCard({
    super.key,
    required this.musteri,
    required this.index,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(musteri.musteriId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Müşteri Sil"),
            content: Text(
                "${musteri.ad} ${musteri.soyad} adlı müşteriyi silmek istiyor musunuz?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("İptal")),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Sil")),
            ],
          ),
        );
      },
      onDismissed: (_) {
        onDelete?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${musteri.ad} ${musteri.soyad} silindi.")),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text('${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(
          "${musteri.ad} ${musteri.soyad}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: musteri.musteriId));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Müşteri ID kopyalandı")),
            );
          },
        ),
        onLongPress: onUpdate,
      ),
    );
  }
}
