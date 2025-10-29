import 'package:flutter/material.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
    int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
          data: const NavigationBarThemeData(
            backgroundColor: Colors.deepPurple, 
            iconTheme: WidgetStatePropertyAll(IconThemeData(color: Colors.black)), 
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int value) {
              setState(() {
                selectedIndex = value;
              });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.book), label: ''),
            NavigationDestination(icon: Icon(Icons.home), label: ''),
            NavigationDestination(icon: Icon(Icons.chat_bubble), label: ''),
            NavigationDestination(icon: Icon(Icons.calculate), label: ''),
            ],
            ),
        );
  }
}