import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonFormWidgets {
  static Widget buildTextField({
    String? initialValue,
    required String labelText,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget buildDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
    required List<DropdownMenuItem<String>> items,
    required String labelText,
    FormFieldValidator<String?>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget buildDatePickerField({
    required BuildContext context,
    required DateTime? value,
    required ValueChanged<DateTime> onDateSelected,
    required String labelText,
  }) {
    final controller = TextEditingController(
      text: value != null ? DateFormat('dd/MM/yyyy').format(value) : '',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            onDateSelected(date);
          }
        },
      ),
    );
  }

  static Widget buildDynamicFields({
    required List<String> values,
    required ValueChanged<String> onAdd,
    required ValueChanged<int> onRemove,
    ValueChanged<(int, String)>? onUpdate, // Optional yapıldı
    required String labelText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...List.generate(values.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: values[index],
                    decoration: InputDecoration(
                      labelText: "$labelText ${index + 1}",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      if (onUpdate != null) {
                        onUpdate((index, val));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => onRemove(index),
                )
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            // Boş string yerine varsayılan değer ekle
            onAdd("");
          },
          icon: const Icon(Icons.add),
          label: Text("$labelText Ekle"),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Yeni bir method - dinamik alanlar için controller'lı versiyon
  static Widget buildDynamicFieldsWithControllers({
    required List<String> values,
    required ValueChanged<String> onAdd,
    required ValueChanged<int> onRemove,
    required ValueChanged<(int, String)> onUpdate,
    required String labelText,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              labelText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(values.length, (index) {
              final controller = TextEditingController(text: values[index]);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: "$labelText ${index + 1}",
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          onUpdate((index, val));
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        onRemove(index);
                        setState(() {}); // UI'ı yenile
                      },
                    )
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                onAdd("");
                setState(() {}); // UI'ı yenile
              },
              icon: const Icon(Icons.add),
              label: Text("$labelText Ekle"),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
