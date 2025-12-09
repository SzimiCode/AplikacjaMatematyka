import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class AppbarLessonWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const AppbarLessonWidget({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: tempLessonName,
      builder: (context, lessonName, child) {
        return AppBar(
          toolbarHeight: 100,
          backgroundColor: const Color.fromARGB(255, 165, 12, 192),
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          ),

          title: Text(
            lessonName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
