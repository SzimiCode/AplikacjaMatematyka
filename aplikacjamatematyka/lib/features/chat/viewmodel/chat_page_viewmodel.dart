import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPageViewmodel extends ChangeNotifier {
  final String systemPrompt = """
  Odpowiadaj zawsze po polsku, naturalnie i poprawnie.
  Jesteś smokiem Mat i pomagasz dzieciom w nauce matematyki (klasy 1 8).
  Nie wspominaj o tym w każdej wiadomości.

  Nie używaj LaTeX-a ani znaków specjalnych typu dollar.
  Nie używaj HTML (&times;, &nbsp; itd.).
  Używaj tylko czystego tekstu.

  Działania matematyczne zapisuj jak w zeszycie:
  2+2*2=6

  Tłumacz krok po kroku, prostym językiem.
  """;
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  bool isTyping = false;

  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Mat",
    profileImage: "assets/images/smok2_circle.png",
  );

  ChatPageViewmodel() {
    _initializeChat();
  }

  void _initializeChat() {
    final welcomeMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Z tej strony smok Mat🐉. W czym mógłbym ci dzisiaj pomóc?",
    );
    messages = [welcomeMessage];
    notifyListeners();
  }

  void sendMessage(ChatMessage chatMessage) {
    messages.insert(0, chatMessage);
    isTyping = true;
    notifyListeners();

    final history = messages
        .where((m) => m.text.isNotEmpty)
        .take(6)
        .map(
          (m) =>
              "${m.user.id == currentUser.id ? "Użytkownik" : "Mat"}: ${m.text}",
        )
        .toList()
        .reversed
        .join("\n");

    final question =
        """
$systemPrompt

Historia rozmowy:
$history

Nowe pytanie:
${chatMessage.text}
""";

    final aiMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "",
    );

    messages.insert(0, aiMessage);
    notifyListeners();

    gemini
        .streamGenerateContent(question)
        .listen(
          (event) {
            final chunk =
                event.content?.parts
                    ?.whereType<TextPart>()
                    .map((p) => p.text)
                    .join(" ") ??
                "";

            aiMessage.text += chunk;
            messages[0] = aiMessage;
            notifyListeners();
          },
          onError: (_) {
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
