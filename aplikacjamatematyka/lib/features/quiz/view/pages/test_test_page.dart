import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/test_test_page_viewmodel.dart';

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
    widget.viewModel.loadTestQuestions();
    // opcjonalnie: nasłuchiwanie zmian żeby odświeżać widok bez setState
    widget.viewModel.currentIndex.addListener(() => setState(() {}));
    widget.viewModel.answered.addListener(() => setState(() {}));
    widget.viewModel.score.addListener(() => setState(() {}));
    widget.viewModel.feedback.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.viewModel.currentIndex.removeListener(() {});
    widget.viewModel.answered.removeListener(() {});
    widget.viewModel.score.removeListener(() {});
    widget.viewModel.feedback.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.viewModel.isLoading,
        builder: (context, loading, _) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final question = widget.viewModel.currentQuestion;

          if (question == null) {
            // gdy brak pytań lub błąd
            return Center(child: Text(widget.viewModel.feedback.value ?? "Brak pytań"));
          }

          final options = (question["options"] as List<dynamic>?) ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // nagłówek — indeks / liczba pytań / wynik
                Text(
                  "Pytanie ${widget.viewModel.currentIndex.value + 1} / ${widget.viewModel.totalQuestions}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  question["question_text"] ?? "Brak treści pytania",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // opcje — generujemy dynamicznie, ale jeśli jest mniej niż 4, generujemy tyle ile jest
                ...List.generate(options.length, (i) {
                  final letter = "ABCD"[i];
                  final text = options[i]["option_text"] ?? "";
                  final disabled = widget.viewModel.answered.value; // po jednym kliknięciu blokujemy przyciski
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ElevatedButton(
                      onPressed: disabled
                          ? null
                          : () {
                              widget.viewModel.onAnswerPressed(letter);
                              // setState nie jest konieczne, bo nasłuchiwacze zmienią widok,
                              // ale wywołujemy dla pewności natychmiastowego odświeżenia.
                              setState(() {});
                            },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("$letter. $text"),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // komunikat czy dobrze czy źle / wynik po zakończeniu
                if (widget.viewModel.feedback.value != null)
                  Text(widget.viewModel.feedback.value!, style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 16),

                // jeśli odpowiedziano → pokaż przycisk "Następne pytanie"
                if (widget.viewModel.answered.value)
                  ElevatedButton(
                    onPressed: () {
                      widget.viewModel.nextQuestion();
                      setState(() {}); // aby zaktualizować UI (nowe pytanie / koniec)
                    },
                    child: const Text("Następne pytanie"),
                  ),

                const SizedBox(height: 12),

                // Zawsze dostępny przycisk wychodzenia z testu
                ElevatedButton(
                  onPressed: () {
                    widget.viewModel.exitTest();
                    Navigator.pop(context);
                  },
                  child: const Text("Cofnij do strony głównej"),
                ),

                const Spacer(),

                // pasek statusu na dole z punktami
                Text("Punkty: ${widget.viewModel.score.value}"),
              ],
            ),
          );
        },
      ),
    );
  }
}