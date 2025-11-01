import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/test_test_page_viewmodel.dart';

class TestTestPage extends StatefulWidget {
  TestTestPage({super.key});
  final TestTestPageViewmodel viewModel = TestTestPageViewmodel();

  @override
  State<TestTestPage> createState() => _TestTestPageState();
}

class _TestTestPageState extends State<TestTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => widget.viewModel.onAnswerPressed('A'),
                child: const Text('A'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.viewModel.onAnswerPressed('B'),
                child: const Text('B'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.viewModel.onAnswerPressed('C'),
                child: const Text('C'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.viewModel.onAnswerPressed('D'),
                child: const Text('D'),
              ),

              const Text(
                'Jesteśmy na stronie testowej dla Mateusza ',
              ),

              ElevatedButton(
                onPressed: widget.viewModel.onBackButtonPressed,
                child: Text('Cofnij do strony głównej'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
