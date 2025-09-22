import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/model/rezervasyon_model.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/viewmodel/base_rezervasyon_view_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RezervasyonlarViewModel extends BaseRezervasyonViewModel {
  static Stream<List<RezervasyonModel>> rezervasyonlariDinle() {
    return FirebaseFirestore.instance
        .collection('rezervasyonlar')
        .orderBy('rezervasyonTarihi', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RezervasyonModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<RezervasyonModel>> sadeceBorclulariGetir() {
    return RezervasyonlarViewModel.rezervasyonlariDinle().map((list) {
      return list.where((rez) => (rez.kalanUcret ?? 0) > 0).toList();
    });
  }

  Future<void> rezervasyonSil(String rezervasyonId) async {
    await FirebaseFirestore.instance
        .collection('rezervasyonlar')
        .doc(rezervasyonId)
        .delete();
    silRezervasyon(rezervasyonId);
  }

  Future<void> yazdirTurListesi(
      String turAdi, List<RezervasyonModel> rezervasyonlar) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("Selamet Turizm",
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 12),
              pw.Text("Tur Adı: $turAdi",
                  style: pw.TextStyle(font: ttf, fontSize: 18)),
              pw.SizedBox(height: 12),
              pw.TableHelper.fromTextArray(
                headers: [
                  'Müşteri Adı',
                  'Kişi Sayısı',
                  'Toplam Ücret',
                  'Kalan Ücret',
                  'Çanta Verildi mi?'
                ],
                data: rezervasyonlar.map((rez) {
                  return [
                    rez.musteriAdi,
                    rez.kisiSayisi?.toString() ?? "-",
                    "${rez.toplamUcret} \$",
                    rez.kalanUcret != null ? "${rez.kalanUcret} \$" : "-",
                    rez.cantaVerildiMi ? "Evet" : "Hayır"
                  ];
                }).toList(),
                cellStyle: pw.TextStyle(font: ttf),
                cellAlignment: pw.Alignment.center,
                headerStyle: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
