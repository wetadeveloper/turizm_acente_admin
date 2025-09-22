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

  TurModelAdmin _tur = TurModelAdmin();
  List<String> turFotograflari = [];

  @override
  TurModelAdmin get tur => _tur;

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
      _tur = TurModelAdmin.fromMap(data).copyWith(
        turID: _docId, // ⚙️ Modele de yazalım
        turKoleksiyonIsimleri: _collection,
      );

      await _getTurFotograflari();
      _tur = _tur.copyWith(imageUrls: List<String>.from(turFotograflari));
    } catch (e) {
      debugPrint("loadTurData hatası: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setOdaFiyati(String odaTipi, String? value) async {
    _tur.odaFiyatlari ??= {};
    _tur.odaFiyatlari![odaTipi] = (double.tryParse(value ?? '') ?? 0).toInt();
    notifyListeners();
  }

  Future<void> _getTurFotograflari() async {
    final id = _docId ?? _tur.turID;
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
      _tur = _tur.copyWith(imageUrls: List<String>.from(turFotograflari));
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
    final id = _docId ?? _tur.turID;
    if (id == null || id.isEmpty) return;

    try {
      final uuid = const Uuid().v4();
      final storageRef = _storage.ref('turFotograflari/$id/fotograflar/$uuid');
      await storageRef.putFile(imageFile);
      final url = await storageRef.getDownloadURL();

      turFotograflari.add(url);
      _tur = _tur.copyWith(imageUrls: List<String>.from(turFotograflari));
      notifyListeners();
    } catch (e) {
      debugPrint('Fotoğraf yükleme hatası: $e');
      rethrow;
    }
  }

  Future<void> updateTur() async {
    final id = _docId ?? _tur.turID;
    final col = _collection ?? _tur.turKoleksiyonIsimleri;

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
        'tur_adi': _tur.turAdi,
        'acenta_adi': _tur.acentaAdi,
        'oda_fiyatlari': _tur.odaFiyatlari, // not: alan adın tutarlı olsun
        'tarih': _tur.tarih != null ? Timestamp.fromDate(_tur.tarih!) : null,
        'yolculuk_turu': _tur.yolculukTuru,
        'tur_suresi': _tur.turSuresi,
        'kapasite': _tur.kapasite,
        'turunkalkacagiSehir': _tur.mevcutSehir,
        'turungidecegiSehir': _tur.gidecekSehir,
        'tur_yayinda': _tur.turYayinda,
        'turDetaylari': _tur.turDetaylari,
        'fiyataDahilHizmetler': _tur.fiyataDahilHizmetler,
        'imageUrls': _tur.imageUrls,
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
