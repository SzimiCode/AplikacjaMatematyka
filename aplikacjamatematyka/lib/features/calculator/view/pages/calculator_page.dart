import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/calculator/viewmodel/calculator_page_viewmodel.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({super.key});

  final CalculatorPageViewmodel viewModel = CalculatorPageViewmodel();

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator')),
      body: Center(
        child: ElevatedButton(
          onPressed: widget.viewModel.onCalculatePressed, 
          child: const Text('Jestemy na stronie z kalkulatorem'),
        ),
      ),
    );
  }
}
