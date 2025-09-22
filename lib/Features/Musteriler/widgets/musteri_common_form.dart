import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/base_musteri_form_view_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/widgets/musteri_common_widget.dart';

class MusteriForm extends StatelessWidget {
  final BaseMusteriFormViewModel viewModel;
  final bool isUpdate;
  final VoidCallback onSubmit;

  const MusteriForm({
    super.key,
    required this.viewModel,
    required this.onSubmit,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MusteriCommonFormWidgets.buildTextField(
              controller: viewModel.adController,
              labelText: "Müşteri Adı",
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Müşteri adı boş olamaz" : null,
            ),
            MusteriCommonFormWidgets.buildTextField(
              controller: viewModel.soyadController,
              labelText: "Müşteri Soyadı",
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Müşteri soyadı boş olamaz" : null,
            ),
            MusteriCommonFormWidgets.buildTextField(
              controller: viewModel.telefonController,
              labelText: "Müşteri Telefon",
              validator: (v) => (v == null || v.isEmpty)
                  ? "Müşteri telefon boş olamaz"
                  : null,
            ),
            MusteriCommonFormWidgets.buildTextField(
              controller: viewModel.kimlikNoController,
              labelText: "Müşteri Kimlik Numarası",
              validator: (v) => (v == null || v.isEmpty)
                  ? "Müşteri kimlik numarası boş olamaz"
                  : null,
            ),
            MusteriCommonFormWidgets.buildDropdown(
              value: (viewModel.cinsiyet == "Erkek" ||
                      viewModel.cinsiyet == "Kadın" ||
                      viewModel.cinsiyet == "Bilinmiyor")
                  ? viewModel.cinsiyet
                  : "Bilinmiyor",
              onChanged: (val) => viewModel.cinsiyet = val ?? "Erkek",
              items: const [
                DropdownMenuItem(value: "Erkek", child: Text("Erkek")),
                DropdownMenuItem(value: "Kadın", child: Text("Kadın")),
                DropdownMenuItem(
                    value: "Bilinmiyor", child: Text("Bilinmiyor")),
              ],
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Cinsiyet seçiniz" : null,
              labelText: "Cinsiyet",
            ),
            MusteriCommonFormWidgets.buildDropdown(
              value: (viewModel.medeniDurum == "Bekar" ||
                      viewModel.medeniDurum == "Evli" ||
                      viewModel.medeniDurum == "Bilinmiyor")
                  ? viewModel.medeniDurum
                  : "Bilinmiyor",
              onChanged: (val) => viewModel.medeniDurum = val ?? "Bekar",
              items: const [
                DropdownMenuItem(value: "Bekar", child: Text("Bekar")),
                DropdownMenuItem(value: "Evli", child: Text("Evli")),
                DropdownMenuItem(
                    value: "Bilinmiyor", child: Text("Bilinmiyor")),
              ],
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Medeni durum seçiniz" : null,
              labelText: "Medeni Durum",
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Doğum Tarihi'),
                subtitle: Text(
                  viewModel.dogumTarihi != null
                      ? DateFormat('dd.MM.yyyy').format(viewModel.dogumTarihi!)
                      : 'Seçilmedi',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selected != null) viewModel.setDogumTarihi(selected);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(isUpdate ? "Müşteri Güncelle" : "Müşteri Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}
