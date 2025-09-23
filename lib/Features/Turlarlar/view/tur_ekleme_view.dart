import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/tur_ekleme_view_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/tur_common_form.dart';
import 'package:provider/provider.dart';

class TurEkle extends StatelessWidget {
  const TurEkle({super.key});

  Future<void> _ekleButtonHandler(BuildContext context) async {
    final viewModel = context.read<TurEklemeViewModel>();
    try {
      await viewModel.uploadTur();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tur başarıyla kaydedildi."),
            duration: Duration(seconds: 2),
          ),
        );
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Ekle button Handler metod hatası: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = TurEklemeViewModel();
        vm.init(); // init metodunu çağır
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Center(
            child: Text(
              AppStrings.turEkleTitle,
              style: TextStyle(
                color: AppColors.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.icon),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: () {
                context.read<TurEklemeViewModel>().pickImages();
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_box),
              onPressed: () {
                _ekleButtonHandler(context);
              },
            ),
          ],
        ),
        body: Consumer<TurEklemeViewModel>(
          builder: (context, viewModel, child) {
            return TurForm(
              viewModel: viewModel,
              isUpdate: false,
              onSubmit: () {
                _ekleButtonHandler(context);
              },
            );
          },
        ),
      ),
    );
  }
}
