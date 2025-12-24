import 'package:aplikacjamatematyka/features/calculator/viewmodel/calculator_page_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculatorPageViewModel vm;

  setUp(() {
    vm = CalculatorPageViewModel();
  });
  test('2 + 3 = 5', () {
    vm.onButtonPressed('2');
    vm.onButtonPressed('+');
    vm.onButtonPressed('3');
    vm.onButtonPressed('=');

    expect(vm.result, '5');
  });

  test('24 - 6 / 4 = 22,5', () {
    for (final v in ['2', '4', '-', '6', '/', '4', '=']) {
      vm.onButtonPressed(v);
    }
    expect(vm.result, '22,5');
  });
  test('1,5 + 2 = 3,5', () {
    for (final v in ['1', ',', '5', '+', '2', '=']) {
      vm.onButtonPressed(v);
    }
    expect(vm.result, '3,5');
  });

  test('nie pozwala na dwa przecinki', () {
    for (final v in ['1', ',', '2', ',', '3']) {
      vm.onButtonPressed(v);
    }
    expect(vm.expression, '1,23');
  });
  test('50% = 0,5', () {
    for (final v in ['5', '0', '%', '=']) {
      vm.onButtonPressed(v);
    }
    expect(vm.result, '0,5');
  });

  test('max 3 procenty z rzędu', () {
    for (final v in ['2', '%', '%', '%', '%']) {
      vm.onButtonPressed(v);
    }
    expect(vm.expression, '2%%%');
  });
  test('nawiasy działają', () {
    for (final v in ['(', '2', '+', '3', ')', 'x', '4', '=']) {
      vm.onButtonPressed(v);
    }
    expect(vm.result, '20');
  });

  test('automatycznie domyka nawiasy', () {
    for (final v in ['()', '2', '+', '3', '=']) {
      vm.onButtonPressed(v);
    }
    expect(vm.result, '5');
  });
  test('dzielenie przez zero', () {
    for (final v in ['5', '/', '0', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.hasError, true);
    expect(vm.result, 'Nie można dzielić przez 0!');
  });
  test('backspace usuwa znak', () {
    for (final v in ['1', '2', '⌫']) {
      vm.onButtonPressed(v);
    }
    expect(vm.expression, '1');
  });

  test('backspace aktualizuje liczbę nawiasów', () {
    for (final v in ['()', '1', '⌫']) {
      vm.onButtonPressed(v);
    }
    expect(vm.expression, '(');
  });

  test('nie pozwala zaczynać od +', () {
    vm.onButtonPressed('+');
    expect(vm.expression, '');
  });

  test('blokuje ++', () {
    for (final v in ['2', '+', '+']) {
      vm.onButtonPressed(v);
    }
    expect(vm.expression, '2+');
  });
  test('AC czyści wszystko', () {
    for (final v in ['1', '+', '2']) {
      vm.onButtonPressed(v);
    }
    vm.onButtonPressed('AC');

    expect(vm.expression, '');
    expect(vm.result, '');
    expect(vm.hasError, false);
  });
  test('wielokrotne = nie zmienia wyniku', () {
    for (final v in ['2', '+', '3', '=']) {
      vm.onButtonPressed(v);
    }
    expect(vm.result, '5');

    vm.onButtonPressed('=');
    vm.onButtonPressed('=');

    expect(vm.result, '5');
  });
  test('AC resetuje expression, result i błędy', () {
    for (final v in ['2', '/', '0', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.hasError, true);

    vm.onButtonPressed('AC');

    expect(vm.expression, '');
    expect(vm.result, '');
    expect(vm.hasError, false);
  });
  test('backspace po = nie niszczy wyniku', () {
    for (final v in ['9', '-', '4', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.result, '5');

    vm.onButtonPressed('⌫');

    expect(vm.result, '5');
  });
  test('minus na początku tworzy liczbę ujemną', () {
    for (final v in ['-', '5', '+', '2', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.result, '-3');
  });
  test('0,5 + 0,5 = 1', () {
    for (final v in ['0', ',', '5', '+', '0', ',', '5', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.result, '1');
  });
  test('same nawiasy nie powodują crasha', () {
    for (final v in ['()', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.hasError, true);
  });
  test('nie można wpisać więcej niż 24 znaki', () {
    for (int i = 0; i < 30; i++) {
      vm.onButtonPressed('1');
    }

    expect(vm.expression.length <= 24, true);
  });
  test('po błędzie kalkulator dalej działa', () {
    for (final v in ['5', '/', '0', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.hasError, true);

    vm.onButtonPressed('AC');

    for (final v in ['6', 'x', '2', '=']) {
      vm.onButtonPressed(v);
    }

    expect(vm.result, '12');
    expect(vm.hasError, false);
  });
}
