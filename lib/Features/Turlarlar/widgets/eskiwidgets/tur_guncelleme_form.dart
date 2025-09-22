import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/tur_guncelleme_view_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/eskiwidgets/guncelle_build_fields.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/otel_secenegi_card.dart';
import 'package:provider/provider.dart';

class TurGuncellemeForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TurGuncellemeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TurGuncelleViewModel>();
    final tur = viewModel.tur;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final koleksiyonAdi = tur.turKoleksiyonIsimleri != null
        ? (viewModel.turKoleksiyonIsimleri[tur.turKoleksiyonIsimleri] ??
            'Bilinmiyor')
        : 'Kategori seçilmemiş';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Tur Kategorisi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(koleksiyonAdi, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Tur Yayında',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Switch(
                    value: tur.turYayinda ?? false,
                    onChanged: viewModel.setTurYayinda),
              ],
            ),
            const SizedBox(height: 16),
            GuncelleFormWidgets().buildTextField(
              label: 'Tur Adı',
              value: tur.turAdi,
              onChanged: viewModel.setTurAdi,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Zorunlu alan' : null,
            ),
            GuncelleFormWidgets().buildTextField(
              label: 'Acente Adı',
              value: tur.acentaAdi,
              onChanged: viewModel.setAcentaAdi,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Zorunlu alan' : null,
            ),
            GuncelleFormWidgets().buildDropdown(
              label: 'Turun Gideceği Şehir',
              value: tur.gidecekSehir,
              items: viewModel.turSehiriOptions,
              onChanged: viewModel.setGidecekSehir,
              validator: (value) => value == null ? 'Zorunlu alan' : null,
            ),
            GuncelleFormWidgets().buildDateField(
              label: 'Tarih',
              value: tur.tarih,
              onChanged: viewModel.setTarih,
              validator: (value) => value == null ? 'Zorunlu alan' : null,
              context: context,
            ),
            GuncelleFormWidgets().buildDropdown(
              label: 'Yolculuk Türü',
              value: tur.yolculukTuru,
              items: viewModel.yolculukTuruOptions,
              onChanged: viewModel.setYolculukTuru,
              validator: (value) => value == null ? 'Zorunlu alan' : null,
            ),
            if (tur.yolculukTuru == 'Uçak')
              GuncelleFormWidgets().buildTextField(
                label: 'Hava Yolu ',
                value: tur.havaYolu?.toString(),
                onChanged: viewModel.setHavaYolu,
              ),
            GuncelleFormWidgets().buildDropdown(
              label: 'Tur Süresi',
              value: tur.turSuresi,
              items: viewModel.turSuresiOptions,
              onChanged: viewModel.setTurSuresi,
              validator: (value) => value == null ? 'Zorunlu alan' : null,
            ),
            GuncelleFormWidgets().buildTextField(
              label: 'Tur Yolcu Kapasitesi',
              value: tur.kapasite?.toString(),
              onChanged: viewModel.setKapasite,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Zorunlu alan' : null,
            ),
            GuncelleFormWidgets().buildDynamicFields(
              label: 'Tur Programı',
              values: tur.turDetaylari,
              onAdd: viewModel.addTurDetayi,
              onRemove: viewModel.removeTurDetayi,
            ),
            GuncelleFormWidgets().buildDynamicFields(
              label: 'Fiyata Dahil Hizmetler',
              values: tur.fiyataDahilHizmetler,
              onAdd: viewModel.addFiyataDahilHizmet,
              onRemove: viewModel.removeFiyataDahilHizmet,
            ),
            GuncelleFormWidgets().buildDynamicFields(
              label: 'Fotoğraf Urlleri Listesi (Manuel)',
              values: tur.imageUrls,
              onAdd: viewModel.addImageUrlsListesi,
              onRemove: viewModel.removeImageUrlsListesi,
            ),
            const SizedBox(height: 24),
            const Text("Otel Seçenekleri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
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
            const SizedBox(height: 20),
            GuncelleFormWidgets().buildPhotoSection(viewModel),
          ],
        ),
      ),
    );
  }
}
