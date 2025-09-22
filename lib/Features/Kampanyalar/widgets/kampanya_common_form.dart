import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/base_kampanya_form_view_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/widgets/kampanya_common_widget.dart';

class KampanyaForm extends StatelessWidget {
  //Burası değişecek
  final BaseKampanyaFormViewModel viewModel;
  final bool isUpdate;
  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey; // <- eklendi

  const KampanyaForm({
    super.key,
    required this.viewModel,
    required this.onSubmit,
    this.isUpdate = false,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey, // <-- önemli
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isUpdate)
              KampanyaCommonFormWidgets.buildTextField(
                controller: viewModel.kampanyaIdController,
                labelText: "Kampanya ID",
                readOnly: true,
              ),
            KampanyaCommonFormWidgets.buildDropdown(
              value: (viewModel.kampanyaDurumu == true) ? "Aktif" : "Pasif",
              onChanged: (val) => viewModel.setKampanyaDurumu(val == "Aktif"),
              items: const [
                DropdownMenuItem(value: "Pasif", child: Text("Pasif")),
                DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
              ],
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Kampanya Durumu seçiniz" : null,
              labelText: "Kampanya Durumu",
            ),
            KampanyaCommonFormWidgets.buildTextField(
              controller: viewModel.baslikController,
              labelText: "Kampanya Başlığı",
              validator: (v) => (v == null || v.isEmpty)
                  ? "Kampanya başlığı boş olamaz"
                  : null,
            ),
            KampanyaCommonFormWidgets.buildTextField(
              controller: viewModel.aciklamaController,
              labelText: "Kampanya Açıklama",
              maxLines: 3,
              validator: (v) => (v == null || v.isEmpty)
                  ? "Kampanya açıklama boş olamaz"
                  : null,
            ),
            KampanyaCommonFormWidgets.buildTextField(
              controller: viewModel.detaylarController,
              labelText: "Kampanya Detaylar",
              maxLines: 2,
              validator: (v) => (v == null || v.isEmpty)
                  ? "Kampanya detaylar boş olamaz"
                  : null,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: viewModel.baslangicDateController,
                    decoration:
                        const InputDecoration(labelText: 'Başlangıç Tarihi'),
                    onTap: () => viewModel.pickBaslangicTarihi(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: viewModel.bitisDateController,
                    decoration:
                        const InputDecoration(labelText: 'Bitiş Tarihi'),
                    onTap: () => {viewModel.pickBitisTarihi(context)},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(isUpdate ? "Kampanya Güncelle" : "Kampanya Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}
