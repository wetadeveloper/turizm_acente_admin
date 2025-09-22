import 'package:flutter/material.dart';

abstract class BaseMusteriFormViewModel with ChangeNotifier {
  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController? kimlikNoController = TextEditingController();

  String? cinsiyet = "Erkek";
  String? medeniDurum = "Bekar";
  DateTime? dogumTarihi;

  void setDogumTarihi(DateTime date) {
    dogumTarihi = date;
    notifyListeners();
  }

  void setCinsiyet(String? value) {
    if (value == null) return;
    cinsiyet = value;
    notifyListeners();
  }

  void setMedeniDurum(String? value) {
    if (value == null) return;
    medeniDurum = value;
    notifyListeners();
  }

  void disposeControllers() {
    adController.dispose();
    soyadController.dispose();
    telefonController.dispose();
    kimlikNoController?.dispose();
  }
}
