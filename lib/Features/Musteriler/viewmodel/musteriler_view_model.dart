import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/model/musteriler_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/base_musteriler_view_model.dart';

class MusterilerViewModel extends BaseMusterilerViewModel {
  static Stream<List<MusteriModel>> musterileriDinle() {
    return FirebaseFirestore.instance
        .collection('musteriler')
        .orderBy('kayitTarihi', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MusteriModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> musteriSil(String musteriId) async {
    await FirebaseFirestore.instance
        .collection('musteriler')
        .doc(musteriId)
        .delete();
    silMusteri(musteriId);
  }
}
