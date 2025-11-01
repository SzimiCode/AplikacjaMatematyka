import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: widget.viewModel.onButtonPressed,
              child: const Text('Jesteśmy choose class page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.viewModel.onBackButtonPressed,
              child: const Text('Drugi przycisk'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.viewModel.onTestButtonPressed(context),
              child: const Text('Przejdź do testu dla Mateusza'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}
