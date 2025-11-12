import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPageViewmodel extends ChangeNotifier {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  bool isTyping = false;

  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(id: "1", firstName: "Mat");

  ChatPageViewmodel() {
    _initializeChat();
  }

  void _initializeChat() {
    final welcomeMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Cześć! 🐉 Z tej strony smok Mat. W czym mógłbym ci dzisiaj pomóc?",
    );
    messages = [welcomeMessage];
    notifyListeners();
  }

  void sendMessage(ChatMessage chatMessage) {
    messages = [chatMessage, ...messages];
    isTyping = true;
    notifyListeners();

    final question =
        "Odpowiadaj zawsze po polsku, w poprawny i naturalny sposób. "
        "Pamiętaj że jesteś smok Mat i pomagasz  dzieciom w matematyce ale nie musisz ciągle o tym pisać. "
        "Używaj tylko poprawnych znaków matematycznych i nie wstawiaj znaków specjalnych"
        "Oto pytanie użytkownika: ${chatMessage.text}";

    ChatMessage aiMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "",
    );

    messages = [aiMessage, ...messages];
    notifyListeners();

    gemini
        .streamGenerateContent(question)
        .listen(
          (event) {
            final responseChunk =
                event.content?.parts
                    ?.whereType<TextPart>()
                    .map((p) => p.text)
                    .join(" ") ??
                "";

            aiMessage.text += responseChunk;
            messages[0] = aiMessage;
            notifyListeners();
          },
          onError: (e) {
            debugPrint("Błąd Gemini: $e");
            isTyping = false;
            notifyListeners();
          },
          onDone: () {
            isTyping = false;
            notifyListeners();
          },
        );
  }
}
