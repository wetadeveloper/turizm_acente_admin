import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../model/tur_model.dart';

abstract class BaseTurViewModel with ChangeNotifier {
  TurModelAdmin _tur = TurModelAdmin(
    turAdi: 'Tur Adı',
    acentaAdi: '',
    odaFiyatlari: {},
    tarih: DateTime.now(),
  );
  bool _isLoading = false;
  final List<File> _selectedImages = [];

  final Map<String, String> _turKoleksiyonIsimleri = {
    'hac_umre_turlari': 'Hac&Umre Turları',
    'deniz_tatilleri': 'Deniz Tatilleri',
    'karadeniz_turlari': 'Karadeniz Turları',
    'anadolu_turlari': 'Anadolu Turları',
    'gastronomi_turlari': 'Gastronomi Turları',
  };

  List<String> yolculukTuruOptions = [
    'Otobüs',
    'Uçak',
    'Tren',
    'Gemi',
    'Diğer',
  ];

  List<String> turSuresiOptions = [
    'Günübirlik',
    '1 Gün 0 Gece',
    '2 Gün 1 Gece',
    '3 Gün 2 Gece',
    '4 Gün 3 Gece',
    '5 Gün 4 Gece',
    '6 Gün 5 Gece',
    '7 Gün 6 Gece',
    '8 Gün 7 Gece',
    '9 Gün 8 Gece',
    '10 Gün 9 Gece',
    '11 Gün 10 Gece',
    '12 Gün 11 Gece',
    '13 Gün 12 Gece',
    '14 Gün 13 Gece',
  ];

  List<String> turSehiriOptions = [
    'Konya',
    'Mekke',
    'Cidde',
    'Medine',
    'İstanbul',
    'Ankara',
    'İzmir',
    'Trabzon',
    'Antalya',
    'Bodrum',
    'Sakarya',
    'Kocaeli',
    'Bursa',
    'Sakarya',
    'Aydın',
    'Çanakkale',
    'Düzce',
    'Eskişehir',
    'Gaziantep',
    'Kayseri',
    'Kahramanmaraş',
    'Mersin',
    'Muğla',
    'Nevşehir',
    'Niğde',
  ];

  // Getter'lar
  TurModelAdmin get tur => _tur;
  bool get isLoading => _isLoading;
  List<File> get selectedImages => _selectedImages;
  Map<String, String> get turKoleksiyonIsimleri => _turKoleksiyonIsimleri;

  // Setter'lar
  set tur(TurModelAdmin value) {
    _tur = value;
    notifyListeners();
  }

  void setTurKoleksiyonIsimleri(String? value) {
    if (value != null) {
      _tur = _tur.copyWith(turKoleksiyonIsimleri: value);
      notifyListeners();
    }
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setTurAdi(String value) {
    _tur = _tur.copyWith(turAdi: value);
    notifyListeners();
  }

  void setAcentaAdi(String value) {
    _tur = _tur.copyWith(acentaAdi: value);
    notifyListeners();
  }

  void setFiyat(String value) {
    _tur = _tur.copyWith(odaFiyatlari: {'default': int.tryParse(value) ?? 0});
    notifyListeners();
  }

  void setTarih(DateTime value) {
    _tur = _tur.copyWith(tarih: value);
    notifyListeners();
  }

  void setTurYayinda(bool value) {
    _tur = _tur.copyWith(turYayinda: value);
    notifyListeners();
  }

  void setYolculukTuru(String? value) {
    if (value != null) {
      _tur = _tur.copyWith(yolculukTuru: value);
      notifyListeners();
    }
  }

  void setHavaYolu(String value) {
    _tur = _tur.copyWith(havaYolu: value.isEmpty ? null : value);
    notifyListeners();
  }

  void setTurSuresi(String? value) {
    if (value != null) {
      _tur = _tur.copyWith(turSuresi: value);
      notifyListeners();
    }
  }

  void setKapasite(String value) {
    _tur = _tur.copyWith(kapasite: int.tryParse(value) ?? 20);
    notifyListeners();
  }

  void setMevcutSehir(String? value) {
    if (value != null) {
      _tur = _tur.copyWith(mevcutSehir: value);
      notifyListeners();
    }
  }

  void setGidecekSehir(String? value) {
    if (value != null) {
      _tur = _tur.copyWith(gidecekSehir: value);
      notifyListeners();
    }
  }

  // Düzeltilmiş tur detayları metodları
  void addTurDetayi(String value) {
    if (value.trim().isEmpty) {
      value = "Yeni tur detayı";
    }
    final currentList = List<String>.from(_tur.turDetaylari);
    currentList.add(value);
    _tur = _tur.copyWith(turDetaylari: currentList);
    debugPrint("Tur detayı eklendi: $value, Toplam: ${currentList.length}");
    notifyListeners();
  }

  void removeTurDetayi(int index) {
    final currentList = List<String>.from(_tur.turDetaylari);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      _tur = _tur.copyWith(turDetaylari: currentList);
      debugPrint("Tur detayı silindi, kalan: ${currentList.length}");
      notifyListeners();
    }
  }

  void updateTurDetayi(int index, String value) {
    final currentList = List<String>.from(_tur.turDetaylari);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = value;
      _tur = _tur.copyWith(turDetaylari: currentList);
      debugPrint("Tur detayı güncellendi: $index -> $value");
      notifyListeners();
    }
  }

  // Düzeltilmiş fiyata dahil hizmetler metodları
  void addFiyataDahilHizmet(String value) {
    if (value.trim().isEmpty) {
      value = "Yeni hizmet";
    }
    final currentList = List<String>.from(_tur.fiyataDahilHizmetler);
    currentList.add(value);
    _tur = _tur.copyWith(fiyataDahilHizmetler: currentList);
    debugPrint(
        "Fiyata dahil hizmet eklendi: $value, Toplam: ${currentList.length}");
    notifyListeners();
  }

  void removeFiyataDahilHizmet(int index) {
    final currentList = List<String>.from(_tur.fiyataDahilHizmetler);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      _tur = _tur.copyWith(fiyataDahilHizmetler: currentList);
      debugPrint("Fiyata dahil hizmet silindi, kalan: ${currentList.length}");
      notifyListeners();
    }
  }

  void updateFiyataDahilHizmet(int index, String value) {
    final currentList = List<String>.from(_tur.fiyataDahilHizmetler);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = value;
      _tur = _tur.copyWith(fiyataDahilHizmetler: currentList);
      debugPrint("Fiyata dahil hizmet güncellendi: $index -> $value");
      notifyListeners();
    }
  }

  // Düzeltilmiş image URLs metodları
  void addImageUrlsListesi(String value) {
    if (value.trim().isEmpty) {
      value = "https://example.com/image.jpg";
    }
    final currentList = List<String>.from(_tur.imageUrls);
    currentList.add(value);
    _tur = _tur.copyWith(imageUrls: currentList);
    debugPrint("Image URL eklendi: $value, Toplam: ${currentList.length}");
    notifyListeners();
  }

  void removeImageUrlsListesi(int index) {
    final currentList = List<String>.from(_tur.imageUrls);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      _tur = _tur.copyWith(imageUrls: currentList);
      debugPrint("Image URL silindi, kalan: ${currentList.length}");
      notifyListeners();
    }
  }

  void updateImageUrlsListesi(int index, String value) {
    final currentList = List<String>.from(_tur.imageUrls);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = value;
      _tur = _tur.copyWith(imageUrls: currentList);
      debugPrint("Image URL güncellendi: $index -> $value");
      notifyListeners();
    }
  }

  // Otel metodları aynı kalıyor
  void addOtelSecenegi(Map<String, dynamic> otel) {
    if (otel.isEmpty ||
        otel['otelAdi'] == null ||
        otel['otelAdi'].toString().trim().isEmpty) {
      debugPrint("Geçersiz otel verisi: Ekleme yapılmadı.");
      return;
    }

    final updatedList = List<Map<String, dynamic>>.from(tur.otelSecenekleri);
    updatedList.add(otel);
    tur = tur.copyWith(otelSecenekleri: updatedList);
    notifyListeners();
  }

  void removeOtelSecenegi(int index) {
    final currentList = tur.otelSecenekleri;
    if (index < 0 || index >= currentList.length) {
      debugPrint("Geçersiz index: Otel silinemedi.");
      return;
    }

    final updatedList = List<Map<String, dynamic>>.from(currentList)
      ..removeAt(index);
    tur = tur.copyWith(otelSecenekleri: updatedList);
    debugPrint("Otel silindi, kalan: ${updatedList.length}");
    notifyListeners();
  }

  void updateOtelSecenegi(int index, Map<String, dynamic> updatedOtel) {
    final currentList = tur.otelSecenekleri;
    if (index < 0 || index >= currentList.length) return;

    final updatedList = List<Map<String, dynamic>>.from(currentList);
    updatedList[index] = updatedOtel;
    tur = tur.copyWith(otelSecenekleri: updatedList);
    notifyListeners();
  }

  void addEmptyOtelSecenegi() {
    final updatedList = List<Map<String, dynamic>>.from(tur.otelSecenekleri);
    updatedList.add({
      'otelAdi': '',
      'otelAdres': '',
      'otelFiyat': 0,
      'otelImageUrls': <String>[],
      'otelYildiz': '',
    });
    tur = tur.copyWith(otelSecenekleri: updatedList);
    debugPrint("Yeni boş otel eklendi, toplam: ${updatedList.length}");
    notifyListeners();
  }

  void addImage(File image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  Future<String> getUserIPAddress() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.ipify.org/?format=json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ip'];
      }
      throw Exception('Failed to get IP address');
    } catch (e) {
      throw Exception('Failed to get IP address: $e');
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: tur.tarih ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setTarih(pickedDate);
    }
  }

  Future<void> pickImages() async {
    try {
      final picker = ImagePicker();

      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking images: $e');
      }
    }
  }
}
