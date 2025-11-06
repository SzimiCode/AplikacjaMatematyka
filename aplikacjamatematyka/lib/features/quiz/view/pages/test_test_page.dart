import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/test_test_page_viewmodel.dart';

// strona testowa do wyswietlania pojedynczego pytania
class TestTestPage extends StatefulWidget {
  TestTestPage({super.key});
  
  final TestTestPageViewmodel viewModel = TestTestPageViewmodel();
  
  @override
  State<TestTestPage> createState() => _TestTestPageState();
}

class _TestTestPageState extends State<TestTestPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadQuestion();  // laduje pytanie jak strona sie otwiera
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testowe pytanie")),
      body: ValueListenableBuilder(
        valueListenable: widget.viewModel.isLoading,
        builder: (context, bool loading, _) {
          // jak laduje to spinner
          if (loading) return Center(child: CircularProgressIndicator());
          
          // jak nie ma danych to komunikat
          if (widget.viewModel.questionData == null) {
            return Center(child: Text(widget.viewModel.feedback.value ?? "Brak danych"));
          }
          
          final question = widget.viewModel.questionData!;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // tresc pytania
                Text(
                  question["question_text"] ?? "Brak pytania",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // generuje 4 przyciski z opcjami (A, B, C, D)
                ...List.generate(4, (i) {
                  final letter = "ABCD"[i];
                  final text = question["options"][i]["option_text"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => setState(() {
                        widget.viewModel.onAnswerPressed(letter);  // sprawdza odpowiedz
                      }),
                      child: Text("$letter. $text"),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                
                // komunikat czy dobrze czy zle
                ValueListenableBuilder(
                  valueListenable: widget.viewModel.feedback,
                  builder: (context, String? feedback, _) {
                    if (feedback == null) return SizedBox.shrink();
                    return Text(feedback, style: TextStyle(fontSize: 18));
                  },
                ),
                const SizedBox(height: 24),
                
                // przycisk powrotu
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);  // wraca do poprzedniej strony
                  },
                  child: Text("Cofnij do strony głównej"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}