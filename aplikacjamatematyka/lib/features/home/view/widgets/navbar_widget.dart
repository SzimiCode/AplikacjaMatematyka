import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int selectedIndex = 0;
   @override
  Widget build(BuildContext context) {
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
          selectedIndex: selectedIndex,
          onDestinationSelected: (int value) {
            setState(() => selectedIndex = value);
          },
          destinations: [
            _buildAnimatedDestination(Icons.book, 'Kursy', 0),
            _buildAnimatedDestination(Icons.home, 'Menu', 1),
            _buildAnimatedDestination(Icons.chat_bubble, 'Czat', 2),
            _buildAnimatedDestination(Icons.calculate, 'Kalkulator', 3),
          ],
        ),
      ),
    );
  }

  /// Funkcja budująca pojedynczy element nawigacji z animacją powiększenia
  NavigationDestination _buildAnimatedDestination(
    IconData icon,
    String label,
    int index,
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
