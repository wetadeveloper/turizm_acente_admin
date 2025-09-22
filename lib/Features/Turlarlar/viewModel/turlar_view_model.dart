import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/tur_model.dart';
import 'base_tur_view_model.dart';

class TurlarViewModel extends BaseTurViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, List<TurModelAdmin>> tumTurlar = {};
  final Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      _subscriptions = {};

  void initDinleme() {
    tumTurlar.clear();

    for (final koleksiyon in turKoleksiyonIsimleri.keys) {
      final subscription =
          _firestore.collection(koleksiyon).snapshots().listen((snapshot) {
        final turlar = snapshot.docs.map((doc) {
          final data = doc.data();
          return TurModelAdmin.fromMap(data).copyWith(turID: doc.id);
        }).toList();

        tumTurlar[koleksiyon] = turlar;
        notifyListeners();
      });

      _subscriptions[koleksiyon] = subscription;
    }
  }

  Future<void> deleteTur(String koleksiyonAdi, String turID) async {
    await _firestore.collection(koleksiyonAdi).doc(turID).delete();
  }

  static Stream<List<TurModelAdmin>> turlariDinle() {
    return FirebaseFirestore.instance
        .collectionGroup('hac_umre_turlari')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TurModelAdmin.fromMap(data).copyWith(turID: doc.id);
      }).toList();
    });
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  static Widget getTravelIcon(String? travelType) {
    switch (travelType) {
      case "Otobüs":
        return const Icon(FontAwesomeIcons.bus, color: Colors.white, size: 30);
      case "Uçak":
        return const Icon(FontAwesomeIcons.planeDeparture,
            color: Colors.white, size: 30);
      case "Tren":
        return const Icon(FontAwesomeIcons.trainTram,
            color: Colors.white, size: 33);
      default:
        return Container();
    }
  }

  IconData getKategoriIcon(String koleksiyonAdi) {
    switch (koleksiyonAdi) {
      case 'deniz_tatilleri':
        return FontAwesomeIcons.umbrellaBeach;
      case 'karadeniz_turlari':
        return FontAwesomeIcons.tree;
      case 'anadolu_turlari':
        return FontAwesomeIcons.mountain;
      case 'hac_umre_turlari':
        return FontAwesomeIcons.mosque;
      case 'gastronomi_turlari':
        return FontAwesomeIcons.utensils;
      default:
        return Icons.category;
    }
  }
}
