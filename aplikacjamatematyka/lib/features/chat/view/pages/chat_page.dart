import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:aplikacjamatematyka/features/chat/viewmodel/chat_page_viewmodel.dart';
import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatPageViewmodel(),
      child: Consumer<ChatPageViewmodel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Pallete.purpleColor,
              shape: const RoundedRectangleBorder(
                 borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                  ),
              ),
              title: const Text(
                "Czat z Matem 🐉",
                style: TextStyle(
                  color: Pallete.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            body: _buildUI(context, viewModel),
            bottomNavigationBar: const NavBarWidget(),
          );
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, ChatPageViewmodel viewModel) {
    return Column(
      children: [
        Expanded(
          child: DashChat(
            currentUser: viewModel.currentUser,
            onSend: viewModel.sendMessage,
            messages: viewModel.messages,
            messageOptions: MessageOptions(
              currentUserContainerColor: Pallete.purpleColor,
              containerColor: Pallete.whiteColor,
              textColor: Pallete.blackColor,
              currentUserTextColor: Pallete.whiteColor,
            ),
            
            inputOptions: InputOptions(
              inputDecoration: InputDecoration(
                hintText: "Napisz wiadomość...",
                hintStyle: TextStyle(color: Pallete.inactiveBottomBarItemColor),
                filled: true,
                fillColor: Pallete.whiteColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Pallete.purpleColor.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Pallete.purpleColor.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Pallete.purpleColor, width: 2),
                ),
              ),
              sendButtonBuilder: (onSend) {
                return IconButton(
                  icon: Icon(Icons.send, color: Pallete.purpleColor),
                  onPressed: onSend,
                );
              },
            ),
          ),
        ),
        if (viewModel.isTyping)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TypingIndicator(),
          ),
      ],
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        int dotCount = ((_controller.value * 3).floor() % 3) + 1;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Pallete.purpleColor,
              child: Icon(
                Icons.auto_awesome,
                color: Pallete.whiteColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mat pisze${'.' * dotCount}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Pallete.greyColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
