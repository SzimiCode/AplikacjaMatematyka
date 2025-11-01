import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
   @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Pallete.purpleColor, width: 0.7)),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Pallete.whiteColor,
              indicatorColor: Pallete.purpleColor.withOpacity(0.1),
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                Set<WidgetState> states,
              ) {
                final bool selected = states.contains(WidgetState.selected);
                return TextStyle(
                  color: selected
                      ? Pallete.blackColor
                      : Pallete.inactiveBottomBarItemColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                );
              }),
            ),
            child: NavigationBar( 
              destinations: [
                _buildAnimatedDestination(Icons.home, 'Menu', 0, selectedPage),
                 _buildAnimatedDestination(Icons.book, 'Kursy', 1, selectedPage),
                _buildAnimatedDestination(Icons.chat_bubble, 'Czat', 2, selectedPage),
                _buildAnimatedDestination(Icons.calculate, 'Kalkulator', 3, selectedPage),
              ],
              selectedIndex: selectedPage,
             onDestinationSelected: (int value) {
                selectedPageNotifier.value = value; 
              },
            ),
          ),
        );
      }
    );
  }

  /// Funkcja budująca pojedynczy element nawigacji z animacją powiększenia
  NavigationDestination _buildAnimatedDestination(
    IconData icon,
    String label,
    int index,
    int selectedIndex,
  ) {
    final bool isSelected = selectedIndex == index;

    return NavigationDestination(
      label: label,
      icon: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Icon(
          icon,
          color: isSelected
              ? Pallete.purpleColor
              : Pallete.inactiveBottomBarItemColor,
        ),
      ),
    );
  }
}
