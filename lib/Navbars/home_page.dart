import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Features/Auth/view/auth_cikis_view.dart';
import 'package:ozel_sirket_admin/Features/Hakkinda/view/hakkinda_view.dart';
import 'package:ozel_sirket_admin/Widgets/anasayfaButonlari/view/anasayfa_butonlari.dart';
import 'bottom_navbar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Align(
            alignment: Alignment.topRight,
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.icon),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HakkindaView()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AuthCikisView(),
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Anasayfabutonlari(),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget(
          index: 0,
        ),
      ),
    );
  }
}
