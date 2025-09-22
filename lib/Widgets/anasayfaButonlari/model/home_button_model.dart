import 'package:flutter/material.dart';

class HomeButtonModel {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final void Function()? onPressed;
  final double fontSize;
  final TextAlign textAlign;

  HomeButtonModel({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    this.fontSize = 18.0,
    this.onPressed,
    this.textAlign = TextAlign.center,
  });
}
