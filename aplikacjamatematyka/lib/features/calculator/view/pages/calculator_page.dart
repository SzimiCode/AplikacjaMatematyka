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
      body: Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            ElevatedButton(
              onPressed: widget.viewModel.onButtonPressed,
              child: const Text('Jesteśmy calculator page'),
            ),
            const SizedBox(height: 20), 
           ElevatedButton(
            onPressed: widget.viewModel.onBackButtonPressed, 
            child: const Text('Drugi przycisk'),
            ),
          ],
        ),
      ),
    );
  }
}
