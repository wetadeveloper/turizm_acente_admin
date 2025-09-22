import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Widgets/anasayfaButonlari/ViewModel/home_view_model.dart';
import 'package:ozel_sirket_admin/Widgets/anasayfaButonlari/utils/custom_home_button.dart';

class Anasayfabutonlari extends StatelessWidget {
  const Anasayfabutonlari({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel();
    final buttons = viewModel.getButtons(context);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              for (int i = 0; i < buttons.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomHomeButton(model: buttons[i]),
                      ),
                      if (i + 1 < buttons.length) ...[
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomHomeButton(model: buttons[i + 1]),
                        ),
                      ]
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
