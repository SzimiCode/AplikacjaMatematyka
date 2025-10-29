import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple
          ),
        ),
        home: Scaffold(
          bottomNavigationBar: NavigationBarTheme(
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
          ),
        ),
    );
  }
}