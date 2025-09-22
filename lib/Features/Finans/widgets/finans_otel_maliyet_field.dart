import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Finans/widgets/roomkeys.dart';

class OtelMaliyetField extends StatefulWidget {
  final String label;
  final Map<String, double> initialData;
  final void Function(Map<String, double>) onChanged;

  const OtelMaliyetField({
    super.key,
    required this.label,
    this.initialData = const {},
    required this.onChanged,
  });

  @override
  State<OtelMaliyetField> createState() => _OtelMaliyetFieldState();
}

class _OtelMaliyetFieldState extends State<OtelMaliyetField> {
  late final Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (final k in RoomKeys.all)
        k: TextEditingController(
          text: (widget.initialData[k] ?? 0).toString(),
        )..addListener(_notifyChange),
    };
    // İlk render sonrası parent’a bir defa yaz (0’lar da gitmiş olur)
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyChange());
  }

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    final map = {
      for (final e in controllers.entries)
        e.key: double.tryParse(e.value.text.replaceAll(',', '.')) ?? 0,
    };
    widget.onChanged(map);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            for (final k in RoomKeys.all)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Oda Tipi",
                        ),
                        child: Text(RoomKeys.label(k)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: controllers[k],
                        decoration: const InputDecoration(
                          labelText: "Maliyet",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
