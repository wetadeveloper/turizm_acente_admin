import 'package:flutter/material.dart';

class OtelSecenegiCard extends StatelessWidget {
  final Map<String, dynamic> otel;
  final int index;
  final void Function(Map<String, dynamic>) onChanged;
  final VoidCallback onRemove;

  const OtelSecenegiCard({
    super.key,
    required this.otel,
    required this.index,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text("Otel ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(
                "Otel Adı", otel['otelAdi'], (val) => _update('otelAdi', val)),
            _buildTextField(
                "Adres", otel['otelAdres'], (val) => _update('otelAdres', val)),
            _buildTextField(
                "2 Kişilik Oda Fiyatı",
                otel['odaFiyatlari']?['Ikili']?.toString(),
                (val) => _updateNested(
                    'odaFiyatlari', 'Ikili', int.tryParse(val) ?? 0),
                keyboardType: TextInputType.number),
            _buildTextField(
                "3 Kişilik Oda Fiyatı",
                otel['odaFiyatlari']?['Uclu']?.toString(),
                (val) => _updateNested(
                    'odaFiyatlari', 'Uclu', int.tryParse(val) ?? 0),
                keyboardType: TextInputType.number),
            _buildTextField(
                "4 Kişilik Oda Fiyatı",
                otel['odaFiyatlari']?['Dortlu']?.toString(),
                (val) => _updateNested(
                    'odaFiyatlari', 'Dortlu', int.tryParse(val) ?? 0),
                keyboardType: TextInputType.number),
            _buildTextField("Yıldız", otel['otelYildiz'],
                (val) => _update('otelYildiz', val)),
            _buildTextField(
                "Fotoğraf Url (virgülle ayırın)",
                otel['otelImageUrls']?.join(', ') ?? '',
                (val) => _update('otelImageUrls',
                    val.split(',').map((e) => e.trim()).toList())),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String? initialValue,
    Function(String) onChanged, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialValue ?? '',
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }

  void _update(String key, dynamic value) {
    final newMap = Map<String, dynamic>.from(otel);
    newMap[key] = value;
    onChanged(newMap);
  }

  void _updateNested(String parentKey, String childKey, dynamic value) {
    final newMap = Map<String, dynamic>.from(otel);
    final parentMap = Map<String, dynamic>.from(newMap[parentKey] ?? {});
    parentMap[childKey] = value;
    newMap[parentKey] = parentMap;
    onChanged(newMap);
  }
}
