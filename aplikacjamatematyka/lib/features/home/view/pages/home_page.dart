import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const NavBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Pallete.purpleColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "User2131514",
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // Prawa strona: 2 ikony
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/book1.png',
                          height: 35,
                          width: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu,
                          color: Pallete.purpleColor,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Image.asset('assets/images/fire1.png', height: 55, width: 55),
                  const SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(top: 19.0),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Pallete.redColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                'Dragon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Pallete.errorColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                ),
              ),

              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/dragon1.png',
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.45,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Poziom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          '2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.2,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Pallete.greenColor,
                        ),
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
