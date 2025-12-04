import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/home/viewmodel/home_page_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageViewModel viewModel = HomePageViewModel();

  @override
  void initState() {
    super.initState();
    // Pobierz dane użytkownika przy starcie
    viewModel.fetchUserData();
    viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: viewModel.goToSettingsButtonPressed,
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
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Pallete.whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            viewModel.userName,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: viewModel.goToSettingsButtonPressed,
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
              // OGNIE - pokazują total_points
              Row(
                children: [
                  Image.asset('assets/images/fire1.png', height: 55, width: 55),
                  const SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(top: 19.0),
                    child: Text(
                      '${viewModel.totalPoints}',  // ZMIENIONE - wyświetla total_points
                      style: const TextStyle(
                        color: Pallete.redColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                viewModel.dragonName,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                    children: [
                      const Text(
                        'Poziom',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '${viewModel.userLevel}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: viewModel.levelProgress,  // ZMIENIONE - używa gettera
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Pallete.greenColor,
                      ),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${viewModel.pointsInCurrentLevel}/${viewModel.pointsToNextLevel} punktów do poziomu ${viewModel.userLevel + 1}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
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