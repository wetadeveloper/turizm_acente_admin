import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/viewModel/reklam_guncelle_view_model.dart';
import 'package:provider/provider.dart';
import '../model/reklam_model.dart';

class ReklamGuncelleView extends StatelessWidget {
  final ReklamModel reklam;
  final String selectedPage;

  const ReklamGuncelleView({
    super.key,
    required this.reklam,
    required this.selectedPage,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReklamGuncelleViewModel(
        reklam: reklam,
        selectedPage: selectedPage,
      ),
      child: Consumer<ReklamGuncelleViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                AppStrings.reklamGuncelleTitle,
                style: TextStyle(
                  color: AppColors.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.icon),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => vm.reklamGuncelle(context),
                ),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: vm.fotoSec,
                          child: vm.gorselURL != null
                              ? Image.network(vm.gorselURL!,
                                  height: 200, fit: BoxFit.cover)
                              : Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.camera_alt, size: 48),
                                ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text('Reklam Yayında'),
                          value: vm.reklamDurumu,
                          onChanged: vm.setReklamDurumu,
                        ),
                        if (vm.hataMesaji != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              vm.hataMesaji!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: vm.baslikController,
                          decoration:
                              const InputDecoration(labelText: 'Başlık'),
                        ),
                        TextField(
                          controller: vm.aciklamaController,
                          decoration:
                              const InputDecoration(labelText: 'Açıklama'),
                          maxLines: 2,
                        ),
                        TextField(
                          controller: vm.acenteAdiController,
                          decoration:
                              const InputDecoration(labelText: 'Acenta Adı'),
                        ),
                        TextField(
                          controller: vm.tarihController,
                          decoration: InputDecoration(
                            labelText: 'Geçerli Tarih',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      reklam.reklaminGecerliOlduguTarih,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) vm.setTarih(date);
                              },
                            ),
                          ),
                          readOnly: true,
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
