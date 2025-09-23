import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../model/tur_model.dart';
import 'base_tur_view_model.dart';

class TurEklemeViewModel extends BaseTurViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String acentaAdi = 'Selamet';

  Future<void> init() async {
    // Acenta adını yükle (Base'deki tur getter'ını kullanarak)
    tur = tur.copyWith(acentaAdi: acentaAdi);
    notifyListeners();
  }

  @override
  void addTurDetayi(String value) {
    if (value.trim().isEmpty) {
      value = "Yeni tur detayı";
    }
    final currentList = List<String>.from(tur.turDetaylari);
    currentList.add(value);
    tur = tur.copyWith(turDetaylari: currentList);
    debugPrint("Tur detayı eklendi: $value, Toplam: ${currentList.length}");
    notifyListeners();
  }

  @override
  void removeTurDetayi(int index) {
    final currentList = List<String>.from(tur.turDetaylari);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      tur = tur.copyWith(turDetaylari: currentList);
      debugPrint("Tur detayı silindi, kalan: ${currentList.length}");
      notifyListeners();
    }
  }

  @override
  void updateTurDetayi(int index, String value) {
    final currentList = List<String>.from(tur.turDetaylari);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = value;
      tur = tur.copyWith(turDetaylari: currentList);
      debugPrint("Tur detayı güncellendi: $index -> $value");
      notifyListeners();
    }
  }

  @override
  void addFiyataDahilHizmet(String value) {
    if (value.trim().isEmpty) {
      value = "Yeni hizmet";
    }
    final currentList = List<String>.from(tur.fiyataDahilHizmetler);
    currentList.add(value);
    tur = tur.copyWith(fiyataDahilHizmetler: currentList);
    debugPrint(
        "Fiyata dahil hizmet eklendi: $value, Toplam: ${currentList.length}");
    notifyListeners();
  }

  @override
  void removeFiyataDahilHizmet(int index) {
    final currentList = List<String>.from(tur.fiyataDahilHizmetler);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      tur = tur.copyWith(fiyataDahilHizmetler: currentList);
      debugPrint("Fiyata dahil hizmet silindi, kalan: ${currentList.length}");
      notifyListeners();
    }
  }

  @override
  void updateFiyataDahilHizmet(int index, String value) {
    final currentList = List<String>.from(tur.fiyataDahilHizmetler);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = value;
      tur = tur.copyWith(fiyataDahilHizmetler: currentList);
      debugPrint("Fiyata dahil hizmet güncellendi: $index -> $value");
      notifyListeners();
    }
  }

  @override
  void addImageUrlsListesi(String value) {
    if (value.trim().isEmpty) {
      value = "https://example.com/image.jpg";
    }
    final currentList = List<String>.from(tur.imageUrls);
    currentList.add(value);
    tur = tur.copyWith(imageUrls: currentList);
    debugPrint("Image URL eklendi: $value, Toplam: ${currentList.length}");
    notifyListeners();
  }

  @override
  void removeImageUrlsListesi(int index) {
    final currentList = List<String>.from(tur.imageUrls);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      tur = tur.copyWith(imageUrls: currentList);
      debugPrint("Image URL silindi, kalan: ${currentList.length}");
      notifyListeners();
    }
  }

  @override
  void updateImageUrlsListesi(int index, String value) {
    final currentList = List<String>.from(tur.imageUrls);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = value;
      tur = tur.copyWith(imageUrls: currentList);
      debugPrint("Image URL güncellendi: $index -> $value");
      notifyListeners();
    }
  }

  @override
  void addEmptyOtelSecenegi() {
    final updatedList = List<Map<String, dynamic>>.from(tur.otelSecenekleri);
    updatedList.add({
      'otelAdi': '',
      'otelAdres': '',
      'otelFiyat': 0,
      'otelImageUrls': <String>[],
      'otelYildiz': '',
    });
    tur = tur.copyWith(otelSecenekleri: updatedList);
    debugPrint("Yeni boş otel eklendi, toplam: ${updatedList.length}");
    notifyListeners();
  }

  @override
  void addOtelSecenegi(Map<String, dynamic> otel) {
    if (otel.isEmpty ||
        otel['otelAdi'] == null ||
        otel['otelAdi'].toString().trim().isEmpty) {
      debugPrint("Geçersiz otel verisi: Ekleme yapılmadı.");
      return;
    }

    final updatedList = List<Map<String, dynamic>>.from(tur.otelSecenekleri);
    updatedList.add(otel);
    tur = tur.copyWith(otelSecenekleri: updatedList);
    notifyListeners();
  }

  @override
  void removeOtelSecenegi(int index) {
    final currentList = tur.otelSecenekleri;
    if (index < 0 || index >= currentList.length) {
      debugPrint("Geçersiz index: Otel silinemedi.");
      return;
    }

    final updatedList = List<Map<String, dynamic>>.from(currentList)
      ..removeAt(index);
    tur = tur.copyWith(otelSecenekleri: updatedList);
    debugPrint("Otel silindi, kalan: ${updatedList.length}");
    notifyListeners();
  }

  @override
  void updateOtelSecenegi(int index, Map<String, dynamic> updatedOtel) {
    final currentList = tur.otelSecenekleri;
    if (index < 0 || index >= currentList.length) return;

    final updatedList = List<Map<String, dynamic>>.from(currentList);
    updatedList[index] = updatedOtel;
    tur = tur.copyWith(otelSecenekleri: updatedList);
    notifyListeners();
  }

  Future<void> uploadTur() async {
    if (tur.turKoleksiyonIsimleri!.isEmpty) {
      throw Exception("Lütfen tur kategorisi seçiniz");
    }

    isLoading = true;
    notifyListeners();

    try {
      // Tur bilgilerini güncelle (Base'deki tur getter/setter'larını kullanarak)
      final turId = const Uuid().v4();
      final ipAddress = await getUserIPAddress();

      tur = tur.copyWith(
        turID: turId,
        turunOlusturulmaTarihi: DateTime.now(),
        acenteIpAdresi: ipAddress,
        turOnayi: false,
      );

      // Resimleri yükle (Base'deki selectedImages getter'ını kullanarak)
      final List<String> imageUrls = [];
      for (final image in selectedImages) {
        final ref = _storage
            .ref()
            .child('turFotograflari/$turId/fotograflar/${const Uuid().v4()}');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Turu Firestore'a kaydet
      await _firestore
          .collection(tur.turKoleksiyonIsimleri!)
          .doc(turId)
          .set(tur.copyWith(imageUrls: imageUrls).toMap());
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    // Base'deki tur setter'ını kullanarak
    tur = TurModelAdmin(
      turAdi: '',
      acentaAdi: acentaAdi,
      odaFiyatlari: {'default': 0},
      tarih: DateTime.now(),
    );
    // Base'deki selectedImages temizleme
    selectedImages.clear();
    notifyListeners();
  }

  void setOdaFiyati(String odaTipi, String fiyatStr) {
    final fiyat = int.tryParse(fiyatStr) ?? 0;
    final mevcutFiyatlar = tur.odaFiyatlari ?? {};
    tur = tur.copyWith(odaFiyatlari: {
      ...mevcutFiyatlar,
      odaTipi: fiyat,
    });
    notifyListeners();
  }
}
