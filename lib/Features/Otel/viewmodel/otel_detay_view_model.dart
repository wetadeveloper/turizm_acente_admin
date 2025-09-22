import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozel_sirket_admin/Features/Otel/model/otel_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'base_otel_view_model.dart';

class OtelDetayViewModel extends BaseOtelViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> odalariYukle(String turId) async {
    try {
      setLoading(true);
      final snapshot = await _firestore
          .collection('otelislemleri')
          .doc(turId)
          .collection('odalar')
          .get();

      final odalarList = snapshot.docs
          .map((doc) => OtelModel.fromMap(doc.data(), doc.id))
          .toList();

      setOdalar(odalarList);
    } catch (e) {
      setHataMesaji("Oda verileri alınamadı: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> odaEkle(String turId, OtelModel yeniOda) async {
    try {
      setLoading(true);
      final odaRef = await _firestore
          .collection('otelislemleri')
          .doc(turId)
          .collection('odalar')
          .add(yeniOda.toMap());

      final oda = yeniOda.copyWith(odaId: odaRef.id);
      addOda(oda);
    } catch (e) {
      setHataMesaji("Oda eklenemedi: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> odaSil(String turId, String odaId) async {
    try {
      await _firestore
          .collection('otelislemleri')
          .doc(turId)
          .collection('odalar')
          .doc(odaId)
          .delete();

      silOda(odaId);
    } catch (e) {
      setHataMesaji("Oda silinemedi: $e");
    }
  }

  Future<void> odalariYazdir(String turAdi) async {
    if (odalar.isEmpty) {
      debugPrint("Yazdırılacak oda yok.");
      return;
    }

    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
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
              pw.SizedBox(height: 16),
              pw.Text("Tur Adı: $turAdi",
                  style: pw.TextStyle(font: ttf, fontSize: 18)),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Oda No', 'Oda Tipi', 'Müşteriler', 'Notlar'],
                data: odalar.map((oda) {
                  return [
                    oda.odaNumarasi,
                    oda.odaTipi,
                    oda.musteriIsmiListesi.join(', '),
                    oda.notlar ?? '-',
                  ];
                }).toList(),
                cellStyle: pw.TextStyle(font: ttf),
                headerStyle: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<List<Map<String, dynamic>>> uygunMusterileriGetir(String turId) async {
    final rezervasyonSnapshot = await _firestore
        .collection('rezervasyonlar')
        .where('turId', isEqualTo: turId)
        .get();

    final mevcutOdalardakiIdler =
        odalar.expand((oda) => oda.musteriIdListesi ?? []).toSet();

    final uygunMusteriler = rezervasyonSnapshot.docs
        .where((doc) {
          return !mevcutOdalardakiIdler.contains(doc['musteriId']);
        })
        .map((doc) => {
              'musteriId': doc['musteriId'],
              'musteriAdi': doc['musteriAdi'],
            })
        .toList();

    return uygunMusteriler;
  }
}
