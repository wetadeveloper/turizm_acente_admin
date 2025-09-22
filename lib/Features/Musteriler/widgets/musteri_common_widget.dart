import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MusteriCommonFormWidgets {
  /// TextField (hem controller hem initialValue destekler)
  static Widget buildTextField({
    TextEditingController? controller,
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
        controller: controller,
        // Eğer controller verilmişse initialValue kullanılamaz → null bırakılır
        initialValue: controller == null ? initialValue : null,
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

  /// Dropdown
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
        initialValue: value,
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

  /// Date Picker Field
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
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            onDateSelected(date);
          }
        },
      ),
    );
  }
}
