import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ozel_sirket_admin/Features/Otel/model/otel_model.dart';
import 'base_otel_view_model.dart';

class TurBilgisi {
  final String turId;
  final String turAdi;

  TurBilgisi({required this.turId, required this.turAdi});
}

class OdaViewModel extends BaseOtelViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TurBilgisi> _turlar = [];
  List<TurBilgisi> get turlar => _turlar;

  Future<void> turlariYukle() async {
    try {
      setLoading(true);
      notifyListeners();

      final snapshot = await _firestore.collection('rezervasyonlar').get();

      final dokumanlar = snapshot.docs;

      final benzersizTurlar = <String, String>{}; // {turId: turAdi}

      for (var doc in dokumanlar) {
        final data = doc.data();
        final turId = data['turId'];
        final turAdi = data['turAdi'] ?? 'Bilinmeyen Tur';

        if (turId != null && !benzersizTurlar.containsKey(turId)) {
          benzersizTurlar[turId] = turAdi;
        }
      }

      _turlar = benzersizTurlar.entries
          .map((e) => TurBilgisi(turId: e.key, turAdi: e.value))
          .toList();

      setHataMesaji(null);
    } catch (e) {
      setHataMesaji("Turlar yüklenemedi: $e");
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

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

  Future<void> odaGuncelle(String turId, OtelModel guncelOda) async {
    try {
      await _firestore
          .collection('otelislemleri')
          .doc(turId)
          .collection('odalar')
          .doc(guncelOda.odaId)
          .update(guncelOda.toMap());

      guncelleOda(guncelOda);
    } catch (e) {
      setHataMesaji("Oda güncellenemedi: $e");
    }
  }
}
