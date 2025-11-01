import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/choose_class_page_viewmodel.dart';

class ChooseClassPage extends StatefulWidget {
  ChooseClassPage({super.key});
  final ChooseClassPageViewmodel viewModel = ChooseClassPageViewmodel();
  @override
  State<ChooseClassPage> createState() => _ChooseClassPageState();
}

class _ChooseClassPageState extends State<ChooseClassPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: widget.viewModel.onButtonPressed, 
          child: const Text('Jestesmy choose class page'),
        ),
      ),
    );
  }
}