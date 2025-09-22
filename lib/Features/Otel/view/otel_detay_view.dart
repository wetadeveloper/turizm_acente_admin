import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Features/Otel/utils/dialog_helpers.dart';
import 'package:ozel_sirket_admin/Features/Otel/viewmodel/otel_detay_view_model.dart';
import 'package:provider/provider.dart';

class OtelDetaySayfasi extends StatefulWidget {
  final String turId;
  final String turAdi;

  const OtelDetaySayfasi({
    super.key,
    required this.turId,
    required this.turAdi,
  });

  @override
  State<OtelDetaySayfasi> createState() => _OtelDetaySayfasiState();
}

class _OtelDetaySayfasiState extends State<OtelDetaySayfasi> {
  late OtelDetayViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = OtelDetayViewModel();
    viewModel.odalariYukle(widget.turId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OtelDetayViewModel>.value(
      value: viewModel,
      child: Consumer<OtelDetayViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                '${widget.turAdi} - Otel Odaları',
                style: const TextStyle(
                  color: AppColors.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.icon),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                DialogHelpers.showOdaEkleDialog(
                  context: context,
                  viewModel: viewModel,
                  turId: widget.turId,
                );
              },
              child: const Icon(Icons.add),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.odalar.isEmpty
                    ? const Center(child: Text('Henüz oda eklenmemiş'))
                    : ListView.builder(
                        itemCount: viewModel.odalar.length,
                        itemBuilder: (context, index) {
                          final oda = viewModel.odalar[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              title:
                                  Text('${oda.odaNumarasi} - ${oda.odaTipi}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Kişiler: ${oda.musteriIsmiListesi.join(', ')}'),
                                  if (oda.notlar != null &&
                                      oda.notlar!.isNotEmpty)
                                    Text('Not: ${oda.notlar!}',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    viewModel.odaSil(widget.turId, oda.odaId),
                              ),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
