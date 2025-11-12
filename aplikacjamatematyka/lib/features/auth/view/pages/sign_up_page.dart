import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/auth/viewmodel/sign_up_page_viewmodel.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  final SignUpPageViewmodel viewModel = SignUpPageViewmodel();

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              child: const Text('Sign Up page back'),
            ),
          ],
        ),
      ),
    );
  }
}