import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/model/tur_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/turlar_view_model.dart';
import 'package:provider/provider.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/rezervasyon_ekle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/musteriler_view_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';

class RezervasyonEkleView extends StatelessWidget {
  const RezervasyonEkleView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RezervasyonEkleViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          AppStrings.rezervasyonEkleTitle,
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.icon),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    final basarili = await viewModel.rezervasyonEkle();
                    if (basarili) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Rezervasyon eklendi")),
                        );
                      }
                    } else if (viewModel.hataMesaji != null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(viewModel.hataMesaji!)),
                        );
                      }
                    }
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Müşteri Dropdown
              StreamBuilder<List<MusteriModel>>(
                stream: MusterilerViewModel.musterileriDinle(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final musteriler = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    initialValue: viewModel.secilenMusteriId,
                    decoration:
                        const InputDecoration(labelText: "Müşteri Seçin"),
                    items: musteriler.map((m) {
                      return DropdownMenuItem(
                        value: m.musteriId,
                        child: Text("${m.ad} ${m.soyad}"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      final musteri =
                          musteriler.firstWhere((m) => m.musteriId == val);
                      viewModel.setSecilenMusteri(
                          val!, "${musteri.ad} ${musteri.soyad}");
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              StreamBuilder<List<TurModelAdmin>>(
                stream: TurlarViewModel
                    .turlariDinle(), // ✅ artık Stream<List<>> döndürüyor
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final turlar = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    initialValue: viewModel.secilenTurId,
                    decoration: const InputDecoration(labelText: "Tur Seçin"),
                    items: turlar.map((tur) {
                      return DropdownMenuItem(
                        value: tur.turID,
                        child: Text(tur.turAdi ?? "Tur"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      final tur = turlar.firstWhere((t) => t.turID == val);
                      viewModel.setSecilenTur(tur.turID ?? "Bilinmiyor",
                          tur.turAdi ?? "Bilinmiyor");
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: viewModel.kisiSayisiController,
                decoration: const InputDecoration(labelText: "Kişi Sayısı"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: viewModel.toplamUcretController,
                decoration: const InputDecoration(labelText: "Toplam Ücret"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: viewModel.kalanUcretController,
                decoration: const InputDecoration(labelText: "Kalan Ücret"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Konaklama Tipi
              DropdownButtonFormField<String>(
                initialValue: viewModel.konaklamaTipi,
                decoration: const InputDecoration(labelText: "Konaklama Tipi"),
                items: ["2'li Oda", "3'lü Oda", "4'lü Oda"].map((tip) {
                  return DropdownMenuItem(value: tip, child: Text(tip));
                }).toList(),
                onChanged: (val) => viewModel.setKonaklamaTipi(val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: viewModel.notlarController,
                decoration: const InputDecoration(labelText: "Notlar"),
              ),
              const SizedBox(height: 16),

              // Çanta Verildi mi
              SwitchListTile(
                value: viewModel.cantaVerildiMi,
                title: const Text("Çanta Verildi mi?"),
                onChanged: viewModel.setCantaVerildi,
              ),
              const SizedBox(height: 24),
              const Text(
                "Yakın Müşteri Bilgileri (Opsiyonel)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Text(
                "Sistemde kayıtlı olan veya olmayan birden fazla yakın müşteri ekleyebilirsiniz.",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 12),

// Sistemdeki müşterilerden seç
              StreamBuilder<List<MusteriModel>>(
                stream: MusterilerViewModel.musterileriDinle(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final musteriler = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text("Sistemde kayıtlı yakın müşteri seçin"),
                    items: musteriler.map((m) {
                      return DropdownMenuItem(
                        value: "${m.ad} ${m.soyad}",
                        child: Text("${m.ad} ${m.soyad}"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        viewModel.addIliskiliMusteriler(val);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 12),

// Manuel ekleme alanı
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.refMusteriInputController,
                      decoration: const InputDecoration(
                        labelText: "Manuel Yakın Müşteri Ekle",
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (value) {
                        viewModel.addIliskiliMusteriler(value);
                        viewModel.refMusteriInputController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.addIliskiliMusteriler(
                          viewModel.refMusteriInputController.text);
                      viewModel.refMusteriInputController.clear();
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (viewModel.iliskiliMusteriler.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: viewModel.iliskiliMusteriler.map((ref) {
                      return Chip(
                        label: Text(ref),
                        onDeleted: () => viewModel.removeRefMusteri(ref),
                      );
                    }).toList(),
                  ),
                ),

              // Kaydet Butonu
              ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        final basarili = await viewModel.rezervasyonEkle();
                        if (basarili) {
                          if (context.mounted) {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Rezervasyon eklendi")),
                            );
                          }
                        } else if (viewModel.hataMesaji != null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.hataMesaji!)),
                            );
                          }
                        }
                      },
                child: viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Rezervasyonu Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
