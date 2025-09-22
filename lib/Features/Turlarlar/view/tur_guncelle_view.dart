import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/tur_guncelleme_view_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/widgets/tur_common_form.dart';
import 'package:provider/provider.dart';

class TurGuncelleSayfasi extends StatelessWidget {
  final String turID;
  final String koleksiyonAdi;

  const TurGuncelleSayfasi(
      {super.key, required this.turID, required this.koleksiyonAdi});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TurGuncelleViewModel()..loadTurData(turID, koleksiyonAdi),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Center(
            child: Text(
              AppStrings.turGuncelleTitle,
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
              onPressed: () =>
                  context.read<TurGuncelleViewModel>().pickAndUploadImage(),
            ),
            Consumer<TurGuncelleViewModel>(
              builder: (context, vm, _) => IconButton(
                icon: const Icon(Icons.save),
                onPressed:
                    vm.canSave ? () => _guncelleButtonHandler(context) : null,
              ),
            ),
          ],
        ),
        body: Consumer<TurGuncelleViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading && vm.tur.gidecekSehir == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return TurForm(
                viewModel: vm,
                isUpdate: true,
                onSubmit: () {
                  _guncelleButtonHandler(context);
                });
          },
        ),
      ),
    );
  }

  Future<void> _guncelleButtonHandler(BuildContext context) async {
    final viewModel = context.read<TurGuncelleViewModel>();
    try {
      await viewModel.updateTur();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tur başarıyla güncellendi.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        debugPrint('guncelleButtonHandler metodu hatası: $e');
      }
    }
  }
}
