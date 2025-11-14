import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/choose_category_page_viewmodel.dart';

class ChooseCategoryPage extends StatefulWidget {
  ChooseCategoryPage({super.key});
  final ChooseCategoryPageViewmodel viewModel = ChooseCategoryPageViewmodel();
  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: widget.viewModel.onButtonPressed,
              child: const Text('Jesteśmy choose category page'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}
