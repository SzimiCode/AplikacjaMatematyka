import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class NotPassedTestPage extends StatelessWidget {
  const NotPassedTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wynik testu'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikona niepowodzenia
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
              
              // Tytuł
              const Text(
                'Test niezdany',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Opis
              Text(
                'Niestety, nie udało się osiągnąć wyniku 4/5. Spróbuj ponownie!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Przycisk spróbuj ponownie
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Restart testu - możesz dodać logikę
                    selectedPageNotifier.value = 6; // Tymczasowo wróć do kursu
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 6, 197, 70),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Spróbuj ponownie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
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