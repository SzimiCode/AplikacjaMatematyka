import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
     brightness: Brightness.light,
  );
}
