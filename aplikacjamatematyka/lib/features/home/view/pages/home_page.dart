import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const Text('Strona Glowna'),
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Testowy'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}