import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../model/reklam_model.dart';
import 'base_reklam_view_model.dart';

class ReklamEkleViewModel extends BaseReklamViewModel {
  final TextEditingController baslikController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();
  final TextEditingController acenteAdiController = TextEditingController(text: "Selamet");
  final TextEditingController tarihController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String? gorselURL;
  String selectedPage = "HacUmreTurlariReklamlari";
  bool reklamDurumu = false;

  void setSelectedPage(String value) {
    selectedPage = value;
    notifyListeners();
  }

  void setReklamDurumu(bool value) {
    reklamDurumu = value;
    notifyListeners();
  }

  void setTarih(DateTime date) {
    tarihController.text = DateFormat('dd/MM/yyyy').format(date);
    notifyListeners();
  }

  Future<void> fotoSec() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final ref = _storage.ref().child('reklam_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = ref.putData(await pickedFile.readAsBytes());

        // Yükleme tamamlandığında devam et
        await uploadTask.whenComplete(() async {
          final downloadUrl = await ref.getDownloadURL();
          gorselURL = downloadUrl;
          notifyListeners();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Fotoğraf yükleme hatası: $e");
      }
      setHataMesaji("Fotoğraf yükleme hatası: $e");
    }
  }

  void disposeControllers() {
    baslikController.dispose();
    aciklamaController.dispose();
    acenteAdiController.dispose();
    tarihController.dispose();
  }

  String generateRandomId(int length) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rand = Random();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<bool> reklamOlustur(BuildContext context) async {
    try {
      final reklamId = generateRandomId(10);
      final tarih = DateFormat('dd/MM/yyyy').parse(tarihController.text);

      final reklam = ReklamModel(
        reklamId: reklamId,
        baslik: baslikController.text,
        aciklama: aciklamaController.text,
        acenteAdi: acenteAdiController.text,
        gorselURL: gorselURL,
        reklaminGecerliOlduguTarih: tarih,
        olusturmaTarihi: Timestamp.fromDate(DateTime.now()),
        reklamDurumu: reklamDurumu,
      );

      final docRef =
          FirebaseFirestore.instance.collection('TumReklamlar').doc(selectedPage).collection('rek').doc(reklamId);

      await docRef.set({
        ...reklam.toMap(),
        'olusturma_tarihi': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print("Firestore yazma başarılı");
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Reklam oluşturulurken hata: $e");
      }
      setHataMesaji("Reklam oluşturulurken hata: $e");
      return false;
    }
  }
}
