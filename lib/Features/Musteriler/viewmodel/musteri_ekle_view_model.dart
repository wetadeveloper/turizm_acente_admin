import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/base_musteri_form_view_model.dart';

class MusteriEkleViewModel extends BaseMusteriFormViewModel {
  String? hataMesaji;
  bool isLoading = false;

  // Excel import için yeni değişkenler
  bool isExcelImporting = false;
  List<Map<String, dynamic>> previewData = [];
  String? excelHataMesaji;
  int importProgress = 0;
  int totalImportCount = 0;

  // Mevcut tek müşteri ekleme fonksiyonu
  Future<bool> musteriEkle() async {
    try {
      isLoading = true;
      hataMesaji = null;
      notifyListeners();

      // Validasyon
      if (!_validateSingleCustomer()) {
        return false;
      }

      final docRef = FirebaseFirestore.instance.collection('musteriler').doc();
      final yeniMusteri = MusteriModel(
        musteriId: docRef.id,
        ad: adController.text.trim(),
        soyad: soyadController.text.trim(),
        telefon: int.parse(telefonController.text.trim()),
        kimlikNumarasi: int.parse(kimlikNoController?.text.trim() ?? ''),
        cinsiyet: cinsiyet ?? "Erkek",
        medeniDurum: medeniDurum ?? "Bekar",
        dogumTarihi: dogumTarihi ?? DateTime.now(),
        kayitTarihi: DateTime.now(),
      );

      await docRef.set(yeniMusteri.toMap());
      debugPrint("Yeni müşteri eklendi: ${docRef.id}");
      _clearForm();
      return true;
    } catch (e) {
      hataMesaji = "Müşteri eklenemedi: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Excel dosyası seçme ve önizleme
  Future<bool> pickExcelFile() async {
    try {
      isExcelImporting = true;
      excelHataMesaji = null;
      previewData.clear();
      notifyListeners();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        await _processExcelFile(file);
        return previewData.isNotEmpty;
      } else {
        excelHataMesaji = "Dosya seçilmedi";
        return false;
      }
    } catch (e) {
      excelHataMesaji = "Excel dosyası okuma hatası: $e";
      return false;
    } finally {
      isExcelImporting = false;
      notifyListeners();
    }
  }

  // Excel dosyasını işleme
  Future<void> _processExcelFile(File file) async {
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet == null) continue;

      // İlk satırı header olarak kabul et
      if (sheet.maxRows <= 1) continue;

      for (int i = 1; i < sheet.maxRows; i++) {
        var row = sheet.rows[i];
        if (row.isEmpty) continue;

        try {
          String adSoyad = row[0]?.value?.toString().trim() ?? '';
          String telefon = row[4]?.value?.toString().trim() ?? '';
          String tcKimlik = row[5]?.value?.toString().trim() ?? '';

          if (adSoyad.isEmpty || telefon.isEmpty || tcKimlik.isEmpty) {
            continue; // Boş satırları atla
          }

          // Ad ve soyadı ayır
          List<String> adSoyadParts = adSoyad.split(' ');
          String ad = adSoyadParts.isNotEmpty ? adSoyadParts[0] : '';
          String soyad =
              adSoyadParts.length > 1 ? adSoyadParts.sublist(1).join(' ') : '';

          // Telefon numarasını temizle
          telefon = telefon.replaceAll(RegExp(r'[^\d]'), '');

          // TC kimlik numarasını temizle
          tcKimlik = tcKimlik.replaceAll(RegExp(r'[^\d]'), '');

          if (ad.isNotEmpty && telefon.length >= 10 && tcKimlik.length == 11) {
            previewData.add({
              'ad': ad,
              'soyad': soyad,
              'telefon': telefon,
              'kimlikNumarasi': tcKimlik,
              'satir': i + 1,
              'durum': 'Hazır',
              'hata': null,
            });
          } else {
            previewData.add({
              'ad': ad,
              'soyad': soyad,
              'telefon': telefon,
              'kimlikNumarasi': tcKimlik,
              'satir': i + 1,
              'durum': 'Hatalı', // 🔴 Yine kaydedilecek
              'hata': _getValidationError(ad, telefon, tcKimlik),
            });
          }
        } catch (e) {
          previewData.add({
            'ad': '',
            'soyad': '',
            'telefon': '',
            'kimlikNumarasi': '',
            'satir': i + 1,
            'durum': 'Hatalı',
            'hata': 'Satır işleme hatası: $e',
          });
        }
      }
      break; // Sadece ilk sheet'i işle
    }

    if (previewData.isEmpty) {
      excelHataMesaji = "Excel dosyasında geçerli müşteri verisi bulunamadı";
    }
  }

  String _getValidationError(String ad, String telefon, String tcKimlik) {
    List<String> hatalar = [];

    if (ad.isEmpty) hatalar.add('Ad boş');
    if (telefon.length < 10) hatalar.add('Geçersiz telefon');
    if (tcKimlik.length != 11) hatalar.add('Geçersiz TC');

    return hatalar.join(', ');
  }

  // Excel verilerini toplu import etme
  Future<bool> importExcelData() async {
    if (previewData.isEmpty) return false;

    try {
      isExcelImporting = true;
      importProgress = 0;

      // 🔴 Artık tüm satırlar işlenecek
      List<Map<String, dynamic>> veriler = previewData;

      totalImportCount = veriler.length;
      notifyListeners();

      final batch = FirebaseFirestore.instance.batch();
      List<String> eklenenTcler = [];
      int basariliEklenen = 0;

      for (int i = 0; i < veriler.length; i++) {
        var veri = veriler[i];

        try {
          String tcKimlik = veri['kimlikNumarasi'] ?? '';

          // Duplicate TC kontrolü (hatalı olsa bile TC boş geçilebilir)
          if (tcKimlik.isNotEmpty && eklenenTcler.contains(tcKimlik)) {
            previewData[i]['durum'] = 'Tekrar';
            continue;
          }

          // Firestore’da aynı TC var mı kontrol et
          if (tcKimlik.isNotEmpty) {
            var existingQuery = await FirebaseFirestore.instance
                .collection('musteriler')
                .where('kimlikNumarasi', isEqualTo: int.tryParse(tcKimlik))
                .limit(1)
                .get();

            if (existingQuery.docs.isNotEmpty) {
              previewData[i]['durum'] = 'Zaten Var';
              continue;
            }
          }

          final docRef =
              FirebaseFirestore.instance.collection('musteriler').doc();

          final yeniMusteri = {
            'musteriId': docRef.id,
            'ad': veri['ad'],
            'soyad': veri['soyad'],
            'telefon': int.tryParse(veri['telefon'] ?? '') ?? 0,
            'kimlikNumarasi': int.tryParse(tcKimlik) ?? 0,
            'cinsiyet': 'Bilinmiyor',
            'medeniDurum': 'Bilinmiyor',
            'dogumTarihi': null,
            'kayitTarihi': DateTime.now(),
            'durum':
                veri['durum'], // 🔴 Hatalı/Hazır bilgisi Firestore’a yazılıyor
            'hata': veri['hata'], // 🔴 Hata açıklaması Firestore’da tutulacak
          };

          batch.set(docRef, yeniMusteri);
          if (tcKimlik.isNotEmpty) eklenenTcler.add(tcKimlik);
          basariliEklenen++;

          importProgress = i + 1;
          notifyListeners();

          if ((i + 1) % 50 == 0) {
            await batch.commit();
            FirebaseFirestore.instance.batch();
          }
        } catch (e) {
          previewData[i]['durum'] = 'Hata';
          previewData[i]['hata'] = e.toString();
        }
      }

      await batch.commit();

      excelHataMesaji =
          "$basariliEklenen müşteri kaydedildi (hatalılar da dahil)";
      return basariliEklenen > 0;
    } catch (e) {
      excelHataMesaji = "Toplu import hatası: $e";
      return false;
    } finally {
      isExcelImporting = false;
      notifyListeners();
    }
  }

  // Preview verilerini temizle
  void clearPreviewData() {
    previewData.clear();
    excelHataMesaji = null;
    importProgress = 0;
    totalImportCount = 0;
    notifyListeners();
  }

  // Tek müşteri formu validasyonu
  bool _validateSingleCustomer() {
    if (adController.text.trim().isEmpty) {
      hataMesaji = "Ad alanı boş olamaz";
      notifyListeners();
      return false;
    }
    if (soyadController.text.trim().isEmpty) {
      hataMesaji = "Soyad alanı boş olamaz";
      notifyListeners();
      return false;
    }
    if (telefonController.text.trim().isEmpty) {
      hataMesaji = "Telefon alanı boş olamaz";
      notifyListeners();
      return false;
    }
    if (kimlikNoController?.text.trim().isEmpty ?? true) {
      hataMesaji = "Kimlik numarası boş olamaz";
      notifyListeners();
      return false;
    }
    if (kimlikNoController?.text.trim().length != 11) {
      hataMesaji = "Kimlik numarası 11 haneli olmalıdır";
      notifyListeners();
      return false;
    }
    return true;
  }

  // Form temizleme
  void _clearForm() {
    adController.clear();
    soyadController.clear();
    telefonController.clear();
    kimlikNoController?.clear();
    dogumTarihi = null;
    cinsiyet = 'Erkek';
    medeniDurum = 'Bekar';
    hataMesaji = null;
  }

  @override
  void disposeControllers() {
    adController.dispose();
    soyadController.dispose();
    telefonController.dispose();
    kimlikNoController?.dispose();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
