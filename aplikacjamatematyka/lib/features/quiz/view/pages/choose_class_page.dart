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
        child: ListView.builder(
          //Tutaj do zmiany, żeby brało z bazy danych
          itemCount: 4, 
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Lekcja ${index + 1}"),
            );
          },
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}
