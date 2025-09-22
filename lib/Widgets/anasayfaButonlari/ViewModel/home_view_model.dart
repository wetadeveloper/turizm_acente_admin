import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Core/constants/app_strings.dart';
import 'package:ozel_sirket_admin/Core/constants/app_colors.dart';
import 'package:ozel_sirket_admin/Features/Finans/view/finans_view.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/view/kampanyalar_view.dart';
import 'package:ozel_sirket_admin/Features/Musteriler/view/musteriler_view.dart';
import 'package:ozel_sirket_admin/Features/Otel/view/otel_view.dart';
import 'package:ozel_sirket_admin/Features/Reklamlar/view/reklamlar_view.dart';
import 'package:ozel_sirket_admin/Features/Rezervasyonlar/view/rezervasyonlar_view.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/view/turlar_view.dart';
import 'package:ozel_sirket_admin/Widgets/anasayfaButonlari/model/home_button_model.dart';

class HomeViewModel {
  List<HomeButtonModel> getButtons(BuildContext context) {
    return [
      HomeButtonModel(
        title: AppStrings.turlarButton,
        textAlign: TextAlign.center,
        icon: Icons.tour,
        color: AppColors.turlarButtonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TurlarView()),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.kampanyaButton,
        textAlign: TextAlign.center,
        icon: Icons.local_offer,
        color: AppColors.kampanyaButtonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KampanyalarView()),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.reklamlarButton,
        textAlign: TextAlign.center,
        icon: Icons.list_alt,
        color: AppColors.reklamlarButtonColor,
        fontSize: 16.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReklamlarView()),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.musterilerButton,
        textAlign: TextAlign.center,
        icon: Icons.people,
        color: AppColors.musterilerButtonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MusterilerView()),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.rezervasyonButton,
        textAlign: TextAlign.center,
        icon: Icons.book_online,
        color: AppColors.rezervasyonButtonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RezervasyonlarView()),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.otelButton,
        textAlign: TextAlign.center,
        icon: Icons.hotel,
        color: AppColors.otelButtonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OtelView()),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.otobusButton,
        textAlign: TextAlign.center,
        icon: Icons.directions_bus,
        color: AppColors.otobusButtonColor,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Otobüs işlemleri henüz eklenmedi')),
          );
        },
      ),
      HomeButtonModel(
        title: AppStrings.finansalButton,
        textAlign: TextAlign.center,
        icon: Icons.bar_chart,
        color: AppColors.finansalButtonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FinansAnasayfaView()),
          );
        },
      ),
    ];
  }
}
