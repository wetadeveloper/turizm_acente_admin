import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/tur_guncelleme_view_model.dart';
import 'package:provider/provider.dart';

class GuncelleFormWidgets {
  Widget buildTextField({
    required String label,
    required String? value,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
  }) {
    final controller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label, // 👈 burada label artık floating olur
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required FormFieldValidator<T?> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: const InputDecoration(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onChanged,
    required FormFieldValidator<DateTime?> validator,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          initialValue:
              value != null ? DateFormat('dd/MM/yyyy').format(value) : null,
          readOnly: true,
          onTap: () => TurGuncelleViewModel().pickDate(context),
          validator: (_) => validator(value),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDynamicFields({
    required String label,
    required List<String> values,
    required ValueChanged<String> onAdd,
    required ValueChanged<int> onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: values.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: values[index],
                    onChanged: (value) {
                      // Burada mevcut değeri güncellemek için bir yöntem eklemelisiniz
                      // ViewModel'de updateTurDetayi(index, value) gibi bir metod olabilir
                    },
                    decoration: const InputDecoration(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => onRemove(index),
                ),
              ],
            );
          },
        ),
        ElevatedButton(
          onPressed: () => onAdd(''), // Yeni boş bir alan ekle
          child: Text('$label Ekle'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildPhotoSection(TurGuncelleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotoğraflar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (viewModel.turFotograflari.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
            items: viewModel.turFotograflari.map((fotoURL) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(
                          fotoURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _showDeleteConfirmationDialog(context, fotoURL),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Fotoğraf Ekle'),
          onPressed: viewModel.pickAndUploadImage,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String fotoURL) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fotoğrafı Sil'),
          content: const Text('Silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Sil'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await context
                      .read<TurGuncelleViewModel>()
                      .deleteFoto(fotoURL);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hata: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
