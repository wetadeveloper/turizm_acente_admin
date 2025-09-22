import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Widgets/anasayfaButonlari/model/home_button_model.dart';

class CustomHomeButton extends StatelessWidget {
  final HomeButtonModel model;

  const CustomHomeButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: model.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: model.onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(model.icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                model.title,
                style: TextStyle(
                  fontSize: model.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (model.subtitle != null)
                Text(
                  model.subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
