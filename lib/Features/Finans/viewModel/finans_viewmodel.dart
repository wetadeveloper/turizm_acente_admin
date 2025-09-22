import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'base_finans_view_model.dart';

/// ----------------- LİSTELEME -----------------
class FinansListeViewModel extends BaseFinansViewModel {
  Future<void> fetchFinansal() async {
    try {
      setLoading(true);
      final snapshot = await FirebaseFirestore.instance
          .collection("financial")
          .orderBy("olusturmaTarihi", descending: true)
          .get();

      final liste = snapshot.docs
          .map((doc) => FinansalModel.fromMap(doc.data(), doc.id))
          .toList();

      setFinansal(liste);
    } catch (e) {
      setHataMesaji("Listeleme hatası: $e");
    } finally {
      setLoading(false);
    }
  }
}

/// ----------------- EKLEME -----------------
class FinansEkleViewModel extends BaseFinansViewModel {
  Future<void> ekleFinansal(FinansalModel finans) async {
    try {
      setLoading(true);

      // Firestore'a boş doc oluşturuyoruz (ID'yi biz kontrol edeceğiz)
      final docRef = FirebaseFirestore.instance.collection("financial").doc();

      // Finans modeline docId'yi yerleştiriyoruz
      final finansWithId = FinansalModel(
        finansId: docRef.id,
        turId: finans.turId,
        turAdi: finans.turAdi,
        mekkeOtelMaliyet: finans.mekkeOtelMaliyet,
        medineOtelMaliyet: finans.medineOtelMaliyet,
        digerSehirOtelMaliyet: finans.digerSehirOtelMaliyet,
        ucusMaliyet: finans.ucusMaliyet,
        karayoluMaliyet: finans.karayoluMaliyet,
        yemekMaliyet: finans.yemekMaliyet,
        vizeMaliyet: finans.vizeMaliyet,
        rehberMaliyet: finans.rehberMaliyet,
        sigortaMaliyet: finans.sigortaMaliyet,
        personelMaliyet: finans.personelMaliyet,
        promosyonMaliyet: finans.promosyonMaliyet,
        digerMaliyet: finans.digerMaliyet,
        suraMaliyet: finans.suraMaliyet,
        kurbanMaliyet: finans.kurbanMaliyet,
        muzeGirisMaliyet: finans.muzeGirisMaliyet,
        ekstraAktiviteMaliyet: finans.ekstraAktiviteMaliyet,
        turTipi: finans.turTipi,
        currency: finans.currency,
        olusturmaTarihi: DateTime.now(),
        guncellemeTarihi: DateTime.now(),
      );

      // docId ile kaydet
      await docRef.set(finansWithId.toMap());
    } catch (e) {
      setHataMesaji("Ekleme hatası: $e");
    } finally {
      setLoading(false);
    }
  }
}

/// ----------------- GÜNCELLEME -----------------
class FinansGuncelleViewModel extends BaseFinansViewModel {
  Future<void> guncelleFinansal(String id, Map<String, dynamic> data) async {
    try {
      setLoading(true);
      await FirebaseFirestore.instance
          .collection("financial")
          .doc(id)
          .update(data);
    } catch (e) {
      setHataMesaji("Güncelleme hatası: $e");
    } finally {
      setLoading(false);
    }
  }
}

/// ----------------- DETAY -----------------
class FinansDetayViewModel extends BaseFinansViewModel {
  Future<FinansalModel?> getirFinansalDetay(String id) async {
    try {
      setLoading(true);
      final doc = await FirebaseFirestore.instance
          .collection("financial")
          .doc(id)
          .get();
      if (doc.exists) {
        return FinansalModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      setHataMesaji("Detay getirme hatası: $e");
    } finally {
      setLoading(false);
    }
    return null;
  }
}

/// ----------------- RAPORLAMA -----------------
class FinansRaporlamaViewModel extends BaseFinansViewModel {
  Future<void> filtrele({
    DateTime? baslangic,
    DateTime? bitis,
    String? kategori,
  }) async {
    try {
      setLoading(true);
      Query query = FirebaseFirestore.instance.collection("financial");

      if (baslangic != null) {
        query = query.where("createdAt", isGreaterThanOrEqualTo: baslangic);
      }
      if (bitis != null) {
        query = query.where("createdAt", isLessThanOrEqualTo: bitis);
      }
      if (kategori != null) {
        query = query.where("kategori", isEqualTo: kategori);
      }

      final snapshot = await query.get();
      final liste = snapshot.docs
          .map((doc) =>
              FinansalModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      setFinansal(liste);
    } catch (e) {
      setHataMesaji("Raporlama hatası: $e");
    } finally {
      setLoading(false);
    }
  }
}
