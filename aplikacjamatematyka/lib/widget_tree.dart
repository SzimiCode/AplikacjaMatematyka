import 'package:aplikacjamatematyka/features/navbar_widget_test.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBarWidgetTEST(),
    );
  }
}