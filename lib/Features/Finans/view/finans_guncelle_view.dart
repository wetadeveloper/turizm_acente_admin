import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/viewModel/finans_viewmodel.dart';
import 'package:provider/provider.dart';
import '../widgets/finans_form_fields.dart';

class FinansGuncelleView extends StatelessWidget {
  final FinansalModel finans;

  const FinansGuncelleView({super.key, required this.finans});

  @override
  Widget build(BuildContext context) {
    context.watch<FinansGuncelleViewModel>();

    return ChangeNotifierProvider(
      create: (_) => FinansGuncelleViewModel(),
      child: Consumer<FinansGuncelleViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                AppStrings.finansGuncelleTitle,
                style: TextStyle(
                  color: AppColors.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.icon),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FinansFormFields(
                initialData: finans,
                onSave: (FinansalModel finansModel) async {
                  await model.guncelleFinansal(
                    finansModel.finansId,
                    finansModel.toMap(),
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
