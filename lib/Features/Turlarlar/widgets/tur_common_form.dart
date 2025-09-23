import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/otel_secenegi_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/tur_common_widget.dart';

class TurForm extends StatelessWidget {
  final dynamic viewModel;
  final bool isUpdate;
  final VoidCallback onSubmit;

  const TurForm({
    super.key,
    required this.viewModel,
    required this.onSubmit,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    final tur = viewModel.tur;
    final selectedImages = viewModel.selectedImages;

    final List<String> turDetaylari =
        (tur.turDetaylari ?? []).map<String>((e) => e.toString()).toList();

    final List<String> fiyataDahilHizmetler = (tur.fiyataDahilHizmetler ?? [])
        .map<String>((e) => e.toString())
        .toList();

    final List<String> imageUrls =
        (tur.imageUrls ?? []).map<String>((e) => e.toString()).toList();

    final List<Map<String, dynamic>> otelSecenekleri =
        (tur.otelSecenekleri ?? [])
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isUpdate)
              CommonFormWidgets.buildDropdown(
                value: tur.turKoleksiyonIsimleri,
                onChanged: viewModel.setTurKoleksiyonIsimleri,
                items: viewModel.turKoleksiyonIsimleri.entries
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Kategori seçiniz" : null,
                labelText: "Tur Kategorisi",
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tur Kategorisi",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    viewModel
                            .turKoleksiyonIsimleri[tur.turKoleksiyonIsimleri] ??
                        "Kategori seçilmemiş",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            if (isUpdate) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Tur Yayında",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Switch(
                    value: tur.turYayinda ?? false,
                    onChanged: viewModel.setTurYayinda,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            CommonFormWidgets.buildTextField(
              labelText: "Tur Adı",
              initialValue: tur.turAdi,
              onChanged: viewModel.setTurAdi,
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Tur adı boş olamaz" : null,
            ),
            CommonFormWidgets.buildTextField(
              labelText: "Acenta Adı",
              initialValue: tur.acentaAdi,
              onChanged: viewModel.setAcentaAdi,
            ),
            CommonFormWidgets.buildDropdown(
              value: tur.gidecekSehir,
              onChanged: viewModel.setGidecekSehir,
              items: viewModel.turSehiriOptions
                  .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Şehir seçiniz" : null,
              labelText: "Turun Gideceği Şehir",
            ),
            CommonFormWidgets.buildDatePickerField(
              context: context,
              value: tur.tarih,
              onDateSelected: viewModel.setTarih,
              labelText: "Tarih",
            ),
            CommonFormWidgets.buildDropdown(
              value: tur.yolculukTuru,
              onChanged: viewModel.setYolculukTuru,
              items: viewModel.yolculukTuruOptions
                  .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Yolculuk türü seçiniz" : null,
              labelText: "Yolculuk Türü",
            ),
            if (tur.yolculukTuru == "Uçak")
              CommonFormWidgets.buildTextField(
                labelText: "Hava Yolu",
                initialValue: tur.havaYolu,
                onChanged: viewModel.setHavaYolu,
              ),
            CommonFormWidgets.buildDropdown(
              value: tur.turSuresi,
              onChanged: viewModel.setTurSuresi,
              items: viewModel.turSuresiOptions
                  .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Tur süresi seçiniz" : null,
              labelText: "Tur Süresi",
            ),
            CommonFormWidgets.buildTextField(
              labelText: "Tur Yolcu Kapasitesi",
              initialValue: tur.kapasite?.toString(),
              onChanged: viewModel.setKapasite,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CommonFormWidgets.buildDynamicFields(
              labelText: "Tur Programı",
              values: turDetaylari,
              onAdd: viewModel.addTurDetayi,
              onRemove: viewModel.removeTurDetayi,
              onUpdate: (tuple) {
                // tuple = (index, value)
                viewModel.updateTurDetayi(tuple.$1, tuple.$2);
              },
            ),
            CommonFormWidgets.buildDynamicFields(
              labelText: "Fiyata Dahil Hizmetler",
              values: fiyataDahilHizmetler,
              onAdd: viewModel.addFiyataDahilHizmet,
              onRemove: viewModel.removeFiyataDahilHizmet,
              onUpdate: (tuple) {
                viewModel.updateFiyataDahilHizmet(tuple.$1, tuple.$2);
              },
            ),
            CommonFormWidgets.buildDynamicFields(
              labelText: "Fotoğraf Urlleri (Manuel)",
              values: imageUrls,
              onAdd: viewModel.addImageUrlsListesi,
              onRemove: viewModel.removeImageUrlsListesi,
              onUpdate: (tuple) {
                viewModel.updateImageUrlsListesi(tuple.$1, tuple.$2);
              },
            ),
            const SizedBox(height: 16),
            const Text("Otel Seçenekleri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(otelSecenekleri.length, (i) {
              final otel = otelSecenekleri[i];
              return OtelSecenegiCard(
                otel: otel,
                index: i,
                onChanged: (u) => viewModel.updateOtelSecenegi(i, u),
                onRemove: () => viewModel.removeOtelSecenegi(i),
              );
            }),
            ElevatedButton.icon(
              onPressed: viewModel.addEmptyOtelSecenegi,
              icon: const Icon(Icons.add),
              label: const Text("Yeni Otel Ekle"),
            ),
            const SizedBox(height: 16),
            if (isUpdate && imageUrls.isNotEmpty) ...[
              const Text("Yüklenmiş Fotoğraflar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
                items: imageUrls.map((url) {
                  return Stack(
                    children: [
                      Image.network(url,
                          fit: BoxFit.cover, width: double.infinity),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => viewModel.deleteFoto(url),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: Icon(isUpdate ? Icons.save : Icons.add,
                  color: AppColors.buttonText),
              label: Text(
                isUpdate ? "Turu Güncelle" : "Turumu Ekle",
                style: const TextStyle(
                    color: AppColors.buttonText, fontWeight: FontWeight.bold),
              ),
              onPressed: onSubmit,
            )
          ],
        ),
      ),
    );
  }
}
