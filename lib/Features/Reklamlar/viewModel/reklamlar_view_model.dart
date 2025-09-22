import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/viewModel/base_reklam_view_model.dart';
import '../model/reklam_model.dart';

class ReklamlarViewModel extends BaseReklamViewModel {
  final Map<String, List<ReklamModel>> tumReklamlar = {};

  static Stream<Map<String, List<ReklamModel>>>
      reklamKategorileriniDinle() async* {
    final reklamlarRoot = FirebaseFirestore.instance.collection("TumReklamlar");

    yield* reklamlarRoot.snapshots().asyncMap((snapshot) async {
      final Map<String, List<ReklamModel>> yeniReklamlar = {};

      for (var doc in snapshot.docs) {
        final altKoleksiyonSnapshot =
            await reklamlarRoot.doc(doc.id).collection("rek").get();
        final reklamlarList = altKoleksiyonSnapshot.docs.map((rekDoc) {
          return ReklamModel.fromMap(rekDoc.data());
        }).toList();
        yeniReklamlar[doc.id] = reklamlarList;
      }

      return yeniReklamlar;
    });
  }

  Stream<List<ReklamModel>> kategoriyeGoreReklamStream(String dokumanAdi) {
    return FirebaseFirestore.instance
        .collection("TumReklamlar")
        .doc(dokumanAdi)
        .collection("rek")
        .orderBy("olusturma_tarihi", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReklamModel.fromMap(doc.data());
      }).toList();
    });
  }
}
