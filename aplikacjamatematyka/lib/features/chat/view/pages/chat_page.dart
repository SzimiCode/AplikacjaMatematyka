import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/chat/viewmodel/chat_page_viewmodel.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  final ChatPageViewmodel viewModel = ChatPageViewmodel();

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: widget.viewModel.onButtonPressed,
              child: const Text('Jesteśmy chat page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.viewModel.onBackButtonPressed,
              child: const Text('Drugi przycisk'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}
