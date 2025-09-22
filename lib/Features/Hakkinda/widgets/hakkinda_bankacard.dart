import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/model/hakkinda_model.dart';

class HakkindaBankaCard extends StatelessWidget {
  final List<BankaBilgisi> bankalar;

  const HakkindaBankaCard({super.key, required this.bankalar});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Banka Bilgileri",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            for (BankaBilgisi banka in bankalar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ${banka.bankaAdi} (${banka.hesapTuru})",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banka.hesapAdi,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          banka.iban,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          final String textToCopy =
                              "${banka.hesapAdi}\n${banka.iban}";
                          Clipboard.setData(ClipboardData(text: textToCopy));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("IBAN kopyalandı ✅"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
