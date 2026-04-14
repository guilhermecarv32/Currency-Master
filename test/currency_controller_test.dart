import 'package:flutter_test/flutter_test.dart';
import 'package:currency_master/controllers/currency_controller.dart';

void main() {
  // O group organiza os testes, exatamente como no Jest
  group('CurrencyController Tests', () {
    late CurrencyController controller;

    // O setUp roda antes de cada teste (equivalente ao beforeEach do Jest)
    setUp(() {
      controller = CurrencyController();
    });

    test('Deve converter 10.0 para 50.0 corretamente', () {
      final result = controller.convert("10.0");
      expect(result, 50.0);
    });

    test('Deve aceitar valores com vírgula (padrão brasileiro)', () {
      final result = controller.convert("10,50");
      expect(result, 52.5);
    });

    test('Deve retornar erro para entradas não numéricas', () {
      // No Flutter, para testar exceções, passamos a chamada dentro de uma função
      expect(() => controller.convert("abc"), throwsException);
    });
  });
}