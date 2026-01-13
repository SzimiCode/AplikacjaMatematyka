import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';


class NotPassedTestPage extends StatelessWidget {
  const NotPassedTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Pallete.purpleColor,
                  Pallete.purplemidColor,
                  Pallete.whiteColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                child: const Icon(
                  Icons.cancel,
                  size: 80,
                  color: Colors.red,
                ),
              ),
              
              const SizedBox(height: 32),
              
  
              const Text(
                'Test niezdany',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 16),
              

              Text(
                'Niestety, nie udało się osiągnąć wyniku 5/5. Spróbuj ponownie!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              
              const SizedBox(height: 48),
              
              
              
              // Przycisk wróć
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    selectedPageNotifier.value = 6;
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 6, 197, 70),
                    ),
                  ),
                  child: const Text(
                    'Wróć do kursu',
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 197, 70),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}