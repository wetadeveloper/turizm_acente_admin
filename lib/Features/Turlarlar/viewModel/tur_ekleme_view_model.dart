import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    // Base'deki selectedImages temizleme (eğer base'de clear metodu varsa)
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
