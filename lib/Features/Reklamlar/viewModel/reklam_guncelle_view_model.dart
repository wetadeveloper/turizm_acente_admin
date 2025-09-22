import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../model/reklam_model.dart';
import 'base_reklam_view_model.dart';

class ReklamGuncelleViewModel extends BaseReklamViewModel {
  final TextEditingController baslikController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();
  final TextEditingController acenteAdiController = TextEditingController();
  final TextEditingController tarihController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String? gorselURL;
  String reklamId;
  String selectedPage;
  bool reklamDurumu;

  ReklamGuncelleViewModel({
    required ReklamModel reklam,
    required this.selectedPage,
  })  : reklamId = reklam.reklamId,
        reklamDurumu = reklam.reklamDurumu {
    baslikController.text = reklam.baslik;
    aciklamaController.text = reklam.aciklama;
    acenteAdiController.text = reklam.acenteAdi;
    tarihController.text = DateFormat('dd/MM/yyyy').format(reklam.reklaminGecerliOlduguTarih);
    gorselURL = reklam.gorselURL;
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
      if (pickedFile == null) return;

      final ref = _storage.ref().child('reklam_images/$reklamId-${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putData(await pickedFile.readAsBytes());

      await uploadTask.whenComplete(() async {
        gorselURL = await ref.getDownloadURL();
        notifyListeners();
      });
    } catch (e) {
      setHataMesaji("Fotoğraf yükleme hatası: $e");
    }
  }

  Future<bool> reklamGuncelle(BuildContext context) async {
    try {
      setLoading(true);
      final tarih = DateFormat('dd/MM/yyyy').parse(tarihController.text);

      final updatedReklam = ReklamModel(
        reklamId: reklamId,
        baslik: baslikController.text,
        aciklama: aciklamaController.text,
        acenteAdi: acenteAdiController.text,
        gorselURL: gorselURL,
        reklaminGecerliOlduguTarih: tarih,
        olusturmaTarihi: null, // Firestore'da değişmez
        reklamDurumu: reklamDurumu,
      );

      final docRef =
          FirebaseFirestore.instance.collection('TumReklamlar').doc(selectedPage).collection('rek').doc(reklamId);

      await docRef.update({
        ...updatedReklam.toMap(),
      });

      setLoading(false);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
      return true;
    } catch (e) {
      setLoading(false);
      setHataMesaji("Güncelleme sırasında hata: $e");
      return false;
    }
  }

  void disposeControllers() {
    baslikController.dispose();
    aciklamaController.dispose();
    acenteAdiController.dispose();
    tarihController.dispose();
  }
}
