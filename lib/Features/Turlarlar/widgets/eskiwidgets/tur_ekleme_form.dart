import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/tur_ekleme_view_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/eskiwidgets/ekleme_build_fields.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/otel_secenegi_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TurEklemeForm extends StatelessWidget {
  final VoidCallback onEklePressed;

  const TurEklemeForm({super.key, required this.onEklePressed});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TurEklemeViewModel>();
    final tur = viewModel.tur;
    final selectedImages = viewModel.selectedImages;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EkleFormWidgets.buildDropdown(
              value: tur.turKoleksiyonIsimleri,
              onChanged: viewModel.setTurKoleksiyonIsimleri,
              items: viewModel.turKoleksiyonIsimleri.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Koleksiyon seçilmelidir';
                }
                return null;
              },
              labelText: 'Tur Kategorisi',
            ),
            const SizedBox(height: 10),
            EkleFormWidgets.buildTextField(
              initialValue: tur.turAdi,
              labelText: "Tur Adı",
              onChanged: viewModel.setTurAdi,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tur Adı boş bırakılamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            EkleFormWidgets.buildTextField(
              initialValue: tur.acentaAdi,
              labelText: "Acenta Adı",
              onChanged: viewModel.setAcentaAdi,
            ),
            /*EkleFormWidgets.buildTextField(
              initialValue: tur.odaFiyatlari?['Ikili']?.toString(),
              labelText: "2 Kişilik Oda Fiyatı",
              onChanged: (value) => viewModel.setOdaFiyati("Ikili", value),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Bu alan boş olamaz';
                return null;
              },
            ),
            EkleFormWidgets.buildTextField(
              initialValue: tur.odaFiyatlari?['Uclu']?.toString(),
              labelText: "3 Kişilik Oda Fiyatı",
              onChanged: (value) => viewModel.setOdaFiyati("Uclu", value),
            ),
            EkleFormWidgets.buildTextField(
              initialValue: tur.odaFiyatlari?['Dortlu']?.toString(),
              labelText: "4 Kişilik Oda Fiyatı",
              onChanged: (value) => viewModel.setOdaFiyati("Dortlu", value),
            ),*/

            EkleFormWidgets.buildDropdown(
              value: tur.mevcutSehir,
              onChanged: viewModel.setMevcutSehir,
              items: ['İstanbul', 'Ankara', 'İzmir', 'Konya']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hareket Noktası Şehiri Boş Bırakılamaz.';
                }
                return null;
              },
              labelText: 'Hareket Noktası',
            ),
            const SizedBox(height: 10),
            EkleFormWidgets.buildDropdown(
              value: tur.gidecekSehir,
              onChanged: viewModel.setGidecekSehir,
              items: viewModel.turSehiriOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Turun Gideceği Şehir Boş Bırakılamaz.';
                }
                return null;
              },
              labelText: 'Turun Gideceği Şehir',
            ),
            EkleFormWidgets.buildTextField(
              initialValue: tur.tarih != null
                  ? DateFormat('dd/MM/yyyy').format(tur.tarih!)
                  : null,
              labelText: "Tarih",
              suffixIcon: IconButton(
                onPressed: () => viewModel.pickDate(context),
                icon: const Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tarih boş bırakılamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            EkleFormWidgets.buildDropdown(
              value: tur.yolculukTuru,
              onChanged: viewModel.setYolculukTuru,
              items: viewModel.yolculukTuruOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Yolculuk Türü seçilmelidir';
                }
                return null;
              },
              labelText: 'Yolculuk Türü',
            ),
            if (tur.yolculukTuru == 'Uçak') // ✅ Hava Yolu Alanı
              EkleFormWidgets.buildTextField(
                initialValue: tur.havaYolu,
                labelText: "Hava Yolu",
                onChanged: viewModel.setHavaYolu,
              ),
            const SizedBox(height: 10),
            EkleFormWidgets.buildDropdown(
              value: tur.turSuresi,
              onChanged: viewModel.setTurSuresi,
              items: viewModel.turSuresiOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tur Süresi seçilmelidir';
                }
                return null;
              },
              labelText: 'Tur Süresi',
            ),
            const SizedBox(height: 10),
            EkleFormWidgets.buildTextField(
              initialValue: tur.kapasite?.toString(),
              labelText: "Tur Yolcu Kapasitesi",
              onChanged: viewModel.setKapasite,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kapasite boş bırakılamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            EkleFormWidgets.buildDynamicFields(
              values: tur.turDetaylari,
              onAdd: (value) => viewModel.addTurDetayi(value),
              onRemove: (index) => viewModel.removeTurDetayi(index),
              labelText: 'Tur Programı',
              onUpdate: ((int, String) value) {},
            ),
            const SizedBox(height: 16),
            EkleFormWidgets.buildDynamicFields(
              values: tur.fiyataDahilHizmetler,
              onAdd: viewModel.addFiyataDahilHizmet,
              onRemove: viewModel.removeFiyataDahilHizmet,
              labelText: 'Fiyata Dahil Hizmetler',
              onUpdate: ((int, String) value) {},
            ),

            ...List.generate(tur.otelSecenekleri.length, (index) {
              final otel = tur.otelSecenekleri[index];
              return OtelSecenegiCard(
                otel: otel,
                index: index,
                onChanged: (updatedOtel) =>
                    viewModel.updateOtelSecenegi(index, updatedOtel),
                onRemove: () => viewModel.removeOtelSecenegi(index),
              );
            }),
            ElevatedButton.icon(
              onPressed: viewModel.addEmptyOtelSecenegi,
              icon: const Icon(Icons.add),
              label: const Text("Yeni Otel Ekle"),
            ),

            // ✅ Manuel Fotoğraf URL Girişi
            const SizedBox(height: 16),

            EkleFormWidgets.buildDynamicFields(
              labelText: 'Fotoğraf Urlleri Listesi (Manuel)',
              values: tur.imageUrls,
              onAdd: viewModel.addImageUrlsListesi,
              onRemove: viewModel.removeImageUrlsListesi,
              onUpdate: ((int, String) value) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Fotoğraflar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: viewModel.pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Fotoğraf Seç'),
            ),
            const SizedBox(height: 16),
            if (selectedImages.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                ),
                items: selectedImages.map((image) {
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Fotoğrafı Sil'),
                            content: const Text(
                                'Fotoğrafı silmek istediğinize emin misiniz?'),
                            actions: [
                              TextButton(
                                child: const Text('Hayır'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: const Text('Evet'),
                                onPressed: () {
                                  viewModel.removeImage(
                                      selectedImages.indexOf(image));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onEklePressed(),
              child: const Text("Turumu Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}
