import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Importe o mocktail aqui também
import 'package:currency_master/controllers/currency_controller.dart';
import 'package:currency_master/services/currency_service.dart';

// 1. Crie o Mock do Serviço
class MockCurrencyService extends Mock implements CurrencyService {}

void main() {
  late CurrencyController controller;
  late MockCurrencyService mockService;

  setUp(() {
    // 2. Instancie o Mock
    mockService = MockCurrencyService();
    // 3. Passe o Mock para o Controller
    controller = CurrencyController(mockService);
  });

  group('CurrencyController Tests', () {
    test('Deve converter corretamente quando a taxa está definida', () {
      // Definimos uma taxa manualmente para o teste de conversão pura
      controller.exchangeRate = 5.0; 
      
      final result = controller.convert("10.0");
      expect(result, 50.0);
    });

    test('Deve lidar com erro de conversão de texto', () {
      expect(controller.convert("abc"), 0.0);
    });
  });
}