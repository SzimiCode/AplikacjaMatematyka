import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPageViewModel extends ChangeNotifier {
  String _expression = '';
  String _result = '';

  String get expression => _expression;
  String get result => _result;

  void onButtonPressed(String value) {
    if (value == "AC") {
      _clearAll();
    } else if (value == "⌫") {
      _backspace();
    } else if (value == "=") {
      _calculateResult();
    } else {
      _appendValue(value);
    }
    notifyListeners();
  }

  /// Czyszczenie całego działania
  void _clearAll() {
    _expression = '';
    _result = '';
  }

  /// Usunięcie ostatniego znaku
  void _backspace() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
    }
  }

  /// Dodawanie wartości do działania
  void _appendValue(String value) {
    // Zamiana 'x' na '*' dla parsera
    if (value == 'x') value = '*';
    _expression += value;
  }

  /// Obliczenie wyniku
  void _calculateResult() {
    try {
      String finalExpression = _expression.replaceAll('x', '*');
      ShuntingYardParser parser = ShuntingYardParser();
      Expression exp = parser.parse(finalExpression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);

      // Usuwamy zbędne .0 jeśli liczba całkowita
      _result = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
    } catch (e) {
      _result = 'Błąd';
    }
  }
}
