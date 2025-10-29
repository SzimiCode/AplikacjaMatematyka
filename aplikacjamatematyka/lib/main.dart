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
          bottomNavigationBar: NavigationBar(
            destinations:  [
              NavigationDestination(icon: Icon(Icons.book), label: ""),
              NavigationDestination(icon: Icon(Icons.home), label: ""),
              NavigationDestination(icon: Icon(Icons.chat_bubble), label: ""),
              NavigationDestination(icon: Icon(Icons.calculate), label: ""),
            ],
            onDestinationSelected: (int value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        ),
    );
  }
}