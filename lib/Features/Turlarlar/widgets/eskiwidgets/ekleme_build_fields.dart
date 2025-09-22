import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EkleFormWidgets {
  static Widget buildTextField({
    String? initialValue,
    required String labelText,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty)
          Text(
            labelText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(suffixIcon: suffixIcon),
          onChanged: onChanged,
          validator: validator,
          readOnly: readOnly,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  static Widget buildDropdown<T>({
    required T? value,
    required ValueChanged<T?> onChanged,
    required List<DropdownMenuItem<T>> items,
    required FormFieldValidator<T?> validator,
    required String labelText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<T>(
          initialValue: value,
          onChanged: onChanged,
          items: items,
          validator: validator,
          decoration: const InputDecoration(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  static Widget buildDynamicFields({
    required List<String> values,
    required ValueChanged<String> onAdd,
    required ValueChanged<int> onRemove,
    required ValueChanged<(int, String)> onUpdate,
    required String labelText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: values.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextFormField(
                    initialValue: values[index],
                    decoration: InputDecoration(
                      labelText: "$labelText ${index + 1}",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => onUpdate((index, value)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => onRemove(index),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => onAdd(''),
          icon: const Icon(Icons.add),
          label: Text('$labelText Ekle'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildDatePickerField({
    required BuildContext context,
    required DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
    required String labelText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: TextEditingController(
            text: initialDate != null
                ? DateFormat('dd/MM/yyyy').format(initialDate)
                : '',
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: initialDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  onDateSelected(date);
                }
              },
            ),
          ),
          readOnly: true,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
