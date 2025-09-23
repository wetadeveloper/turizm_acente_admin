import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/model/tur_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/base_tur_view_model.dart';
import 'package:uuid/uuid.dart';

class TurGuncelleViewModel extends BaseTurViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // 🔒 Doküman kimliği ve koleksiyon adını sabit tut
  String? _docId;
  String? _collection;
  List<String> turFotograflari = [];

  // Parent class'ın _tur field'ını kullanmak yerine override ediyoruz
  @override
  TurModelAdmin get tur => super.tur;

  @override
  set tur(TurModelAdmin value) {
    super.tur = value;
  }

  // UI'da save butonunu enable/disable etmek için
  bool get canSave =>
      !isLoading &&
      (_docId?.isNotEmpty ?? false) &&
      (_collection?.isNotEmpty ?? false);

  Future<void> loadTurData(String turID, String koleksiyonAdi) async {
    isLoading = true;
    _docId = turID;
    _collection = koleksiyonAdi;
    notifyListeners();

    try {
      final snap = await _firestore.collection(_collection!).doc(_docId).get();
      if (!snap.exists) {
        throw Exception("Tur bulunamadı: ${_collection!}/${_docId!}");
      }

      final data = snap.data()!;
      // Parent class'ın tur setter'ını kullan
      tur = TurModelAdmin.fromMap(data).copyWith(
        turID: _docId,
        turKoleksiyonIsimleri: _collection,
      );

      await _getTurFotograflari();
      tur = tur.copyWith(imageUrls: List<String>.from(turFotograflari));
    } catch (e) {
      debugPrint("loadTurData hatası: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Parent class method'larını override et
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

  Future<void> setOdaFiyati(String odaTipi, String? value) async {
    final currentFiyatlar = Map<String, int>.from(tur.odaFiyatlari ?? {});
    currentFiyatlar[odaTipi] = (double.tryParse(value ?? '') ?? 0).toInt();
    tur = tur.copyWith(odaFiyatlari: currentFiyatlar);
    notifyListeners();
  }

  Future<void> _getTurFotograflari() async {
    final id = _docId ?? tur.turID;
    if (id == null || id.isEmpty) return;

    try {
      final ref = _storage.ref('turFotograflari/$id/fotograflar');
      final result = await ref.listAll();
      turFotograflari =
          await Future.wait(result.items.map((r) => r.getDownloadURL()));
      notifyListeners();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        debugPrint('Fotoğraf listeleme hatası: $e');
      }
      turFotograflari = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Hata: $e');
      turFotograflari = [];
      notifyListeners();
    }
  }

  Future<void> deleteFoto(String fotoURL) async {
    try {
      await _storage.refFromURL(fotoURL).delete();
      turFotograflari.remove(fotoURL);
      tur = tur.copyWith(imageUrls: List<String>.from(turFotograflari));
      notifyListeners();
    } catch (e) {
      debugPrint('Fotoğraf silme hatası: $e');
      rethrow;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      await _uploadImage(File(picked.path));
    } catch (e) {
      debugPrint('Fotoğraf seçme hatası: $e');
      rethrow;
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final id = _docId ?? tur.turID;
    if (id == null || id.isEmpty) return;

    try {
      final uuid = const Uuid().v4();
      final storageRef = _storage.ref('turFotograflari/$id/fotograflar/$uuid');
      await storageRef.putFile(imageFile);
      final url = await storageRef.getDownloadURL();

      turFotograflari.add(url);
      tur = tur.copyWith(imageUrls: List<String>.from(turFotograflari));
      notifyListeners();
    } catch (e) {
      debugPrint('Fotoğraf yükleme hatası: $e');
      rethrow;
    }
  }

  Future<void> updateTur() async {
    final id = _docId ?? tur.turID;
    final col = _collection ?? tur.turKoleksiyonIsimleri;

    debugPrint("updateTur -> id: $id, col: $col");

    if (id == null || id.isEmpty || col == null || col.isEmpty) {
      throw Exception(
          'View model updateTur metodu Tur ID veya koleksiyon bilgisi eksik');
    }

    isLoading = true;
    notifyListeners();

    try {
      final userIPAddress = await getUserIPAddress();
      await _firestore.collection(col).doc(id).update({
        'tur_adi': tur.turAdi,
        'acenta_adi': tur.acentaAdi,
        'oda_fiyatlari': tur.odaFiyatlari,
        'tarih': tur.tarih != null ? Timestamp.fromDate(tur.tarih!) : null,
        'yolculuk_turu': tur.yolculukTuru,
        'tur_suresi': tur.turSuresi,
        'kapasite': tur.kapasite,
        'turunkalkacagiSehir': tur.mevcutSehir,
        'turungidecegiSehir': tur.gidecekSehir,
        'tur_yayinda': tur.turYayinda,
        'turDetaylari': tur.turDetaylari,
        'fiyataDahilHizmetler': tur.fiyataDahilHizmetler,
        'imageUrls': tur.imageUrls,
        'Guncelleyen_Acente_ipAdresi': userIPAddress,
        'Acente_Guncelleme_tarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('updateTur hatası: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
