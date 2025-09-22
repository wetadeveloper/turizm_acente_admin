import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/model/kampanya_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/kampanya_guncelle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/widgets/kampanya_common_form.dart';
import 'package:provider/provider.dart';

class KampanyaGuncelleView extends StatelessWidget {
  final String kampanyaId;
  final KampanyaModel kampanya;

  const KampanyaGuncelleView({
    super.key,
    required this.kampanyaId,
    required this.kampanya,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return ChangeNotifierProvider(
      create: (_) => KampanyaGuncelleViewModel(kampanya: kampanya),
      child: Consumer<KampanyaGuncelleViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                AppStrings.kampanyaGuncelleTitle,
                style: TextStyle(
                  color: AppColors.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.icon),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => vm.kampanyaGuncelle(context),
                ),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        KampanyaForm(
                          viewModel: vm,
                          isUpdate: true,
                          onSubmit: () async {
                            final basarili = await vm.kampanyaGuncelle(context);
                            if (basarili) {
                              if (basarili && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Kampanya başarıyla güncellendi")),
                                );
                                Navigator.of(context).pop();
                              } else if (vm.hataMesaji != null &&
                                  context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(vm.hataMesaji!)),
                                );
                              }
                            } else {
                              if (vm.hataMesaji != null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(vm.hataMesaji!)),
                                );
                              }
                            }
                          },
                          formKey: formKey,
                        ),

                        const SizedBox(height: 20),
                        //TODO : Tarih oluşturmada DateTime.Now kaydediyor bunu düzeltecez.
                        Text(
                          'Oluşturma Tarihi: ${DateFormat('dd/MM/yyyy').format(kampanya.olusturmaTarihi ?? DateTime.now())}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Güncelleme Tarihi: ${DateFormat('dd/MM/yyyy').format(kampanya.guncellemeTarihi ?? DateTime.now())}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
