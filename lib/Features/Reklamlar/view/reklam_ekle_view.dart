import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/viewModel/reklam_ekle_view_model.dart';
import 'package:provider/provider.dart';

class ReklamEkleView extends StatefulWidget {
  const ReklamEkleView({super.key});

  @override
  State<ReklamEkleView> createState() => _ReklamEkleViewState();
}

class _ReklamEkleViewState extends State<ReklamEkleView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    context.read<ReklamEkleViewModel>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReklamEkleViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Center(
          child: Text(
            AppStrings.reklamEkleTitle,
            style: TextStyle(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.icon),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: vm.fotoSec,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await vm.reklamOlustur(context);
                if (!success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(vm.hataMesaji ?? 'Bilinmeyen hata')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Hangi Sayfada Gösterilecek?'),
              DropdownButtonFormField<String>(
                initialValue: vm.selectedPage,
                onChanged: (val) =>
                    vm.setSelectedPage(val ?? "HacUmreTurlariReklamlari"),
                items: [
                  "HacUmreTurlariReklamlari",
                  "DenizTatilleriReklamlari",
                  "KaradenizTurlariReklamlari",
                  "AnadoluTurlariReklamlari",
                  "GastronomiTurlariReklamlari",
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Reklam Durumu'),
                  const Spacer(),
                  Switch(
                    value: vm.reklamDurumu,
                    onChanged: vm.setReklamDurumu,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: vm.baslikController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Lütfen başlık girin.';
                  if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(val)) {
                    return 'Sadece harf giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: vm.aciklamaController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Lütfen açıklama girin.';
                  }
                  if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(val)) {
                    return 'Sadece harf giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: vm.acenteAdiController,
                decoration: const InputDecoration(labelText: 'Acente Adı'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Lütfen acente adı girin.';
                  }
                  if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(val)) {
                    return 'Sadece harf veya boşluk giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: vm.tarihController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Reklam Tarihi',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2029),
                      );
                      if (pickedDate != null) {
                        vm.setTarih(pickedDate);
                      }
                    },
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Tarih boş bırakılamaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (vm.gorselURL != null)
                Column(
                  children: [
                    Image.network(
                      vm.gorselURL!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ElevatedButton(
                onPressed: vm.fotoSec,
                child: const Text('Fotoğraf Seç'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await vm.reklamOlustur(context);
                    if (!success) {
                      if (kDebugMode) {
                        print('Reklam oluşturma başarısız: ${vm.hataMesaji}');
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(vm.hataMesaji ?? 'Bilinmeyen hata')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Reklam Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
