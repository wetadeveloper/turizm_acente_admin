import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/viewmodel/musteri_ekle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/widgets/musteri_common_form.dart';

import 'package:provider/provider.dart';

class MusteriEkleView extends StatelessWidget {
  const MusteriEkleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusteriEkleViewModel(),
      child: Consumer<MusteriEkleViewModel>(
        builder: (context, vm, _) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                title: const Text(
                  AppStrings.musteriEkleTitle,
                  style: TextStyle(
                    color: AppColors.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconTheme: const IconThemeData(color: AppColors.icon),
                bottom: const TabBar(
                  dividerColor: AppColors.title,
                  labelColor: AppColors.tabBarLabel,
                  unselectedLabelColor: AppColors.tabBarUnselected,
                  indicatorColor: AppColors.title,
                  tabs: [
                    Tab(icon: Icon(Icons.person_add), text: 'Tekli Ekleme'),
                    Tab(icon: Icon(Icons.upload_file), text: 'Excel Import'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  MusteriForm(
                    viewModel: vm,
                    onSubmit: () async {
                      final basarili = await vm.musteriEkle();
                      if (basarili && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Müşteri başarıyla eklendi")),
                        );
                        Navigator.of(context).pop();
                      } else if (vm.hataMesaji != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.hataMesaji!)),
                        );
                      }
                    },
                  ),
                  _buildExcelImportTab(context, vm),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExcelImportTab(BuildContext context, MusteriEkleViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Excel Format Bilgisi
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Excel Format Bilgisi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Excel dosyanızda şu sütun sırası olmalıdır:\n'
                    '1. AD SOYAD (A sütunu)\n'
                    '2. FİYAT (B sütunu - atlanacak)\n'
                    '3. ALINAN (C sütunu - atlanacak)\n'
                    '4. KALAN (D sütunu - atlanacak)\n'
                    '5. TELEFON (E sütunu)\n'
                    '6. T.C (F sütunu)',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Excel Dosyası Seçme Butonu
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: vm.isExcelImporting
                  ? null
                  : () async {
                      await vm.pickExcelFile();
                    },
              icon: vm.isExcelImporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(vm.isExcelImporting
                  ? 'Dosya Okunuyor...'
                  : 'Excel Dosyası Seç'),
            ),
          ),

          const SizedBox(height: 16),

          // Hata Mesajı
          if (vm.excelHataMesaji != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: vm.excelHataMesaji!.contains('başarıyla')
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                border: Border.all(
                  color: vm.excelHataMesaji!.contains('başarıyla')
                      ? Colors.green.shade300
                      : Colors.red.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                vm.excelHataMesaji!,
                style: TextStyle(
                  color: vm.excelHataMesaji!.contains('başarıyla')
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Preview Data
          if (vm.previewData.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Önizleme (${vm.previewData.length} kayıt)',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (vm.previewData.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: vm.isExcelImporting
                        ? null
                        : () async {
                            bool result = await vm.importExcelData();
                            if (result && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Excel verileri başarıyla içe aktarıldı'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('İçe Aktar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Import Progress
            if (vm.isExcelImporting && vm.totalImportCount > 0)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: vm.importProgress / vm.totalImportCount,
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '${vm.importProgress} / ${vm.totalImportCount} kayıt işlendi'),
                  const SizedBox(height: 16),
                ],
              ),

            // Preview Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Satır')),
                  DataColumn(label: Text('Ad')),
                  DataColumn(label: Text('Soyad')),
                  DataColumn(label: Text('Telefon')),
                  DataColumn(label: Text('TC Kimlik')),
                  DataColumn(label: Text('Durum')),
                ],
                rows: vm.previewData.map((item) {
                  Color? rowColor;
                  if (item['durum'] == 'Hatalı') {
                    rowColor = Colors.red.shade50;
                  } else if (item['durum'] == 'Hazır') {
                    rowColor = Colors.green.shade50;
                  } else if (item['durum'] == 'Zaten Var' ||
                      item['durum'] == 'Tekrar') {
                    rowColor = Colors.orange.shade50;
                  }

                  return DataRow(
                    color: rowColor != null
                        ? WidgetStateProperty.all(rowColor)
                        : null,
                    cells: [
                      DataCell(Text(item['satir'].toString())),
                      DataCell(Text(item['ad'] ?? '')),
                      DataCell(Text(item['soyad'] ?? '')),
                      DataCell(Text(item['telefon'] ?? '')),
                      DataCell(Text(item['kimlikNumarasi'] ?? '')),
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['durum'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: item['durum'] == 'Hazır'
                                    ? Colors.green
                                    : item['durum'] == 'Hatalı'
                                        ? Colors.red
                                        : Colors.orange,
                              ),
                            ),
                            if (item['hata'] != null)
                              Text(
                                item['hata'],
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Özet Bilgileri
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Özet:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                            'Hazır: ${vm.previewData.where((item) => item['durum'] == 'Hazır').length}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                            'Hatalı: ${vm.previewData.where((item) => item['durum'] == 'Hatalı').length}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.warning,
                            color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                            'Zaten Var: ${vm.previewData.where((item) => item['durum'] == 'Zaten Var').length}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Temizle Butonu
            TextButton.icon(
              onPressed: vm.clearPreviewData,
              icon: const Icon(Icons.clear),
              label: const Text('Önizlemeyi Temizle'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
