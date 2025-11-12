import 'package:aplikacjamatematyka/core/theme/theme.dart';
import 'package:aplikacjamatematyka/core/widget_tree.dart';
import 'package:aplikacjamatematyka/services/google_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      home: WidgetTree(),
    );
  }
}
