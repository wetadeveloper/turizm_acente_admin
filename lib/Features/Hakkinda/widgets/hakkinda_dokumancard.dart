import 'package:flutter/material.dart';

class HakkindaDokumanCard extends StatelessWidget {
  final List<Map<String, dynamic>> dokumanlar;

  const HakkindaDokumanCard({super.key, required this.dokumanlar});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dokümanlar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            for (final doc in dokumanlar)
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(doc["ad"]),
                subtitle: Text(doc["dosya"]),
                onTap: () {
                  // PDF açma fonksiyonu
                },
              ),
          ],
        ),
      ),
    );
  }
}
