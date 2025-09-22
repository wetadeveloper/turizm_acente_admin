import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Finans/model/finans_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/viewModel/finans_viewmodel.dart';
import 'package:provider/provider.dart';
import '../widgets/finans_form_fields.dart';

class FinansEkleView extends StatelessWidget {
  const FinansEkleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinansEkleViewModel(),
      child: Consumer<FinansEkleViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                AppStrings.finansEkleTitle,
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
                onSave: (FinansalModel finansModel) async {
                  await model.ekleFinansal(finansModel);
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
