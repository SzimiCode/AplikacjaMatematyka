import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPageViewModel extends ChangeNotifier {
  String _expression = '';
  String _result = '';
  bool _hasError = false;
  bool get hasError => _hasError;
  int _openBrackets = 0;
  static const int maxExpressionLength = 24;

  String get expression => _expression;
  String get result => _result;

  void onButtonPressed(String value) {
    if (value == "AC") {
      _clearAll();
    } else if (value == "⌫") {
      _backspace();
      _hasError = false;
    } else if (value == "=") {
      _calculateResult();
    } else if (value == ",") {
      _hasError = false;
      _addComma();
    } else if (value == "()") {
      _handleBrackets();
    } else {
      _hasError = false;
      _appendValue(value);
    }
    notifyListeners();
  }

  /// Czyszczenie całego działania
  void _clearAll() {
    _expression = '';
    _result = '';
    _hasError = false;
    _openBrackets = 0;
  }

  /// Usunięcie ostatniego znaku
  void _backspace() {
    if (_expression.isNotEmpty) {
      String last = _expression[_expression.length - 1];

      if (last == '(') _openBrackets--;
      if (last == ')') _openBrackets++;

      _expression = _expression.substring(0, _expression.length - 1);
    }
  }

  /// Dodawanie wartości do działania
  void _appendValue(String value) {
    // 🚫 BLOKADA DŁUGOŚCI
    if (_expression.length >= maxExpressionLength) {
      // pozwalamy tylko na ZAMIANY operatorów (np. + → -)
      if (_expression.isNotEmpty &&
          _isOperator(_expression[_expression.length - 1]) &&
          _isOperator(value)) {
        _expression = _expression.substring(0, _expression.length - 1) + value;
      }
      return;
    }

    String current = _currentNumber();

    // 🚫 usuwamy 0 TYLKO gdy po nim idzie cyfra
    if (current == '0' && _isDigit(value)) {
      _expression = _expression.substring(0, _expression.length - 1) + value;
      return;
    }

    // limit 4 procentow
    if (value == '%' && _countTrailingPercents() >= 3) {
      return;
    }
    // BLOKADA operatorów na początku (poza minusem)
    if (_expression.isEmpty) {
      if (['+', '×', '/', '%'].contains(value)) {
        return;
      }
    }

    // Jeśli zaczynamy od przecinka → 0,
    if (_expression.isEmpty && value == ',') {
      _expression = '0,';
      return;
    }

    // Jeśli ostatni znak to przecinek i klikamy operator LUB % → domykamy 0
    if (_expression.endsWith(',') &&
        (_isOperator(value) || _isPercent(value))) {
      _expression += '0';
    }

    // 🔁 Zamiana operatora na operator (blokada ++, xx, //, %%)
    if (_expression.isNotEmpty &&
        _isOperator(_expression[_expression.length - 1]) &&
        _isOperator(value)) {
      _expression = _expression.substring(0, _expression.length - 1) + value;
      return;
    }

    _expression += value;
  }

  /// ✅ Obsługa przecinka (polska notacja)
  void _addComma() {
    // Pobieramy ostatnią liczbę (po operatorze)
    final parts = _expression.split(RegExp(r'[+\-x/%()]'));
    final lastPart = parts.isNotEmpty ? parts.last : '';

    // Nie pozwalamy na dwa przecinki w jednej liczbie
    if (lastPart.contains(',')) return;

    // Jeśli puste lub operator przed – dodajemy 0,
    if (_expression.isEmpty || _isLastCharOperator()) {
      _expression += '0,';
    } else {
      _expression += ',';
    }
  }

  String _handlePercent(String expression) {
    final percentRegex = RegExp(r'(\d+(?:[.,]\d+)?)(%+)');

    while (percentRegex.hasMatch(expression)) {
      final match = percentRegex.firstMatch(expression)!;

      String number = match.group(1)!;
      String percents = match.group(2)!;

      double value = double.parse(number.replaceAll(',', '.'));

      // każde % to /100
      for (int i = 0; i < percents.length; i++) {
        value /= 100;
      }

      String replacement = value.toString();

      int endIndex = match.end;
      if (endIndex < expression.length) {
        final nextChar = expression[endIndex];
        if (RegExp(r'\d|\(').hasMatch(nextChar)) {
          replacement += '*';
        }
      }

      expression = expression.replaceFirst(match.group(0)!, replacement);
    }

    return expression;
  }

  void _handleBrackets() {
    if (_expression.isEmpty) {
      _expression += '(';
      _openBrackets++;
      return;
    }

    String last = _expression[_expression.length - 1];

    // Jeśli ostatni znak to operator lub '(' → otwieramy
    if (_isOperator(last) || last == '(') {
      _expression += '(';
      _openBrackets++;
      return;
    }

    // Jeśli możemy zamknąć nawias
    if (_openBrackets > 0 && !_isOperator(last)) {
      _expression += ')';
      _openBrackets--;
      return;
    }

    // Fallback – otwieramy
    _expression += '(';
    _openBrackets++;
  }

  String _currentNumber() {
    if (_expression.isEmpty) return '';

    final parts = _expression.split(RegExp(r'[+\-x/%()]'));

    return parts.last;
  }

  bool _isLastCharOperator() {
    if (_expression.isEmpty) return false;
    return '+-x÷'.contains(_expression[_expression.length - 1]);
  }

  bool _isOperator(String value) {
    return ['+', '-', '×', '÷'].contains(value);
  }

  bool _isPercent(String value) => value == '%';

  bool _isDigit(String value) {
    return RegExp(r'^[0-9]$').hasMatch(value);
  }

  int _countTrailingPercents() {
    int count = 0;
    for (int i = _expression.length - 1; i >= 0; i--) {
      if (_expression[i] == '%') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  String _trimTrailingOperators(String exp) {
    while (exp.isNotEmpty &&
        (_isOperator(exp[exp.length - 1]) || exp.endsWith(','))) {
      exp = exp.substring(0, exp.length - 1);
    }
    return exp;
  }

  void _setError() {
    _result = 'Błąd';
    _hasError = true;
  }

  /// Obliczenie wyniku
  void _calculateResult() {
    try {
      String exp = _expression;

      exp = _trimTrailingOperators(exp);

      if (exp.isEmpty) {
        _result = '';
        return;
      }

      while (_openBrackets > 0) {
        exp += ')';
        _openBrackets--;
      }

      // Zamiana procentów
      exp = _handlePercent(exp);

      // Zamiana notacji
      exp = exp.replaceAll(',', '.').replaceAll('×', '*').replaceAll('÷', '/');

      ShuntingYardParser parser = ShuntingYardParser();
      Expression parsedExp = parser.parse(exp);
      ContextModel contextModel = ContextModel();

      double eval = parsedExp.evaluate(EvaluationType.REAL, contextModel);

      if (eval.isInfinite || eval.isNaN) {
        _setError();
        _result = 'Nie można dzielić przez 0!';
        return;
      }

      String formatted = eval.toStringAsFixed(5);
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      formatted = formatted.replaceAll('.', ',');

      _result = formatted;
      _hasError = false;
    } catch (e) {
      _setError();
      _result = 'Błąd zapisu działania!';
    }
  }
}
