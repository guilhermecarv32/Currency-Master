import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:currency_master/services/currency_service.dart';

// 1. Criamos um Mock para o Cliente
class MockClient extends Mock implements http.Client {}

// 2. Criamos uma "Fake" para o Uri (necessário para o Mocktail)
class FakeUri extends Fake implements Uri {}

void main() {
  late CurrencyService service;
  late MockClient mockClient;

  // 3. Registramos o valor de fallback ANTES de rodar qualquer teste
  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    service = CurrencyService(mockClient);
  });

  group('CurrencyService - API Tests', () {
    test('Deve retornar a cotação quando a API responde 200', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('{"USDBRL": {"bid": "5.25"}}', 200),
      );

      final rate = await service.fetchExchangeRate();

      expect(rate, 5.25);
      verify(() => mockClient.get(any())).called(1);
    });

    test('Deve lançar uma Exception quando a API responde 404', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => service.fetchExchangeRate(), throwsException);
    });
  });
}