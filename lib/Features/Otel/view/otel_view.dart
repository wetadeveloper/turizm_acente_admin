import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:ozel_sirket_admin/Features/Otel/viewmodel/otel_view_model.dart';
import 'package:ozel_sirket_admin/Features/Otel/view/otel_detay_view.dart';

class OtelView extends StatefulWidget {
  const OtelView({super.key});

  @override
  State<OtelView> createState() => _OtelViewState();
}

class _OtelViewState extends State<OtelView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OdaViewModel>(context, listen: false).turlariYukle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OdaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.otelTitle,
            style:
                TextStyle(color: AppColors.title, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.icon),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.hataMesaji != null
              ? Center(child: Text(viewModel.hataMesaji!))
              : ListView.builder(
                  itemCount: viewModel.turlar.length,
                  itemBuilder: (context, index) {
                    final tur = viewModel.turlar[index];

                    return ListTile(
                      title: Text(tur.turAdi),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtelDetaySayfasi(
                              turId: tur.turId,
                              turAdi: tur.turAdi,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
