import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/auth/viewmodel/register_page_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  final RegisterPageViewmodel viewModel = RegisterPageViewmodel();

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.viewModel.onBackButtonPressed,
              child: const Text('Register page back'),
            ),
          ],
        ),
      ),
    );
  }
}