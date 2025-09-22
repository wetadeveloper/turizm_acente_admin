import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Otel/model/otel_model.dart';
import 'package:ozel_sirket_admin/Features/Otel/viewmodel/otel_detay_view_model.dart';

class DialogHelpers {
  static Future<void> showOdaEkleDialog({
    required BuildContext context,
    required OtelDetayViewModel viewModel,
    required String turId,
  }) async {
    final uygunMusteriler = await viewModel.uygunMusterileriGetir(turId);

    final TextEditingController odaNoCtrl = TextEditingController();
    final TextEditingController notlarCtrl = TextEditingController();
    String odaTipi = '2li';

    List<String> secilenMusteriId = [];
    List<String> secilenMusteriIsmi = [];

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Yeni Oda Oluştur"),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      initialValue: odaTipi,
                      items: ['2li', '3lu', '4lu']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => odaTipi = val);
                      },
                      decoration: const InputDecoration(labelText: 'Oda Tipi'),
                    ),
                    TextField(
                      controller: odaNoCtrl,
                      decoration: const InputDecoration(labelText: 'Oda No'),
                    ),
                    const SizedBox(height: 10),
                    const Text('Müşteri Seç',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: uygunMusteriler.length,
                        itemBuilder: (ctx, index) {
                          final musteri = uygunMusteriler[index];
                          final id = musteri['musteriId'];
                          final ad = musteri['musteriAdi'];
                          final secili = secilenMusteriId.contains(id);

                          return CheckboxListTile(
                            value: secili,
                            title: Text(ad),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  secilenMusteriId.add(id);
                                  secilenMusteriIsmi.add(ad);
                                } else {
                                  secilenMusteriId.remove(id);
                                  secilenMusteriIsmi.remove(ad);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    TextField(
                      controller: notlarCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Not (isteğe bağlı)'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        _manuelMusteriEkleDialog(
                          context,
                          secilenMusteriId,
                          secilenMusteriIsmi,
                          setState,
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Manuel Müşteri Ekle'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final oda = OtelModel(
                      odaId: '',
                      odaTipi: odaTipi,
                      odaNumarasi: odaNoCtrl.text.trim(),
                      musteriIdListesi: secilenMusteriId,
                      musteriIsmiListesi: secilenMusteriIsmi,
                      notlar: notlarCtrl.text.trim().isEmpty
                          ? null
                          : notlarCtrl.text.trim(),
                    );
                    viewModel.odaEkle(turId, oda);
                    Navigator.pop(context);
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  static void _manuelMusteriEkleDialog(
    BuildContext context,
    List<String> idList,
    List<String> isimList,
    void Function(void Function()) setState,
  ) {
    final idCtrl = TextEditingController();
    final isimCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Manuel Müşteri Ekle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'Müşteri ID'),
            ),
            TextField(
              controller: isimCtrl,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                idList.add(idCtrl.text.trim());
                isimList.add(isimCtrl.text.trim());
              });
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
