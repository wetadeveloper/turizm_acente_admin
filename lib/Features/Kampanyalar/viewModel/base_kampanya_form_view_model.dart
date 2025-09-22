import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/base_kampanya_view_model.dart';

abstract class BaseKampanyaFormViewModel extends BaseKampanyaViewModel {
  final TextEditingController kampanyaIdController = TextEditingController();
  final TextEditingController baslikController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();
  final TextEditingController detaylarController = TextEditingController();
  final TextEditingController baslangicDateController = TextEditingController();
  final TextEditingController bitisDateController = TextEditingController();
  final TextEditingController olusturmaDateController = TextEditingController();
  final TextEditingController guncellemeDateController =
      TextEditingController();
  bool kampanyaDurumu = false;
  DateTime? baslangicTarihi;
  DateTime? bitisTarihi;

  Future<void> pickBaslangicTarihi(BuildContext context) async {
    final initial = baslangicTarihi ??
        DateTime.now(); // eklemede now, güncellemede eski tarih
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      baslangicTarihi = selected;
      baslangicDateController.text =
          "${selected.day}/${selected.month}/${selected.year}";
      notifyListeners();
    }
  }

  Future<void> pickBitisTarihi(BuildContext context) async {
    final initial = bitisTarihi ?? DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      bitisTarihi = selected;
      bitisDateController.text =
          "${selected.day}/${selected.month}/${selected.year}";
      notifyListeners();
    }
  }

  void setKampanyaDurumu(bool value) {
    kampanyaDurumu = value;
    notifyListeners();
  }

  void disposeControllers() {
    baslikController.dispose();
    aciklamaController.dispose();
    detaylarController.dispose();
  }
}
