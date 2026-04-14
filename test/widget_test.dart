import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_master/main.dart';
import 'package:currency_master/controllers/currency_controller.dart';
import 'package:currency_master/services/currency_service.dart';

class MockCurrencyService extends Mock implements CurrencyService {}

void main() {
  testWidgets('Deve atualizar o resultado quando o botão for clicado', (WidgetTester tester) async {
    // 1. Criamos o mock e o controller de teste
    final mockService = MockCurrencyService();
    final testController = CurrencyController(mockService);
    
    // 2. Simulamos que a taxa já foi carregada para não dar erro no initState
    testController.exchangeRate = 5.0; 
    // E treinamos o mock para não estourar exceção quando o initState chamar ele
    when(() => mockService.fetchExchangeRate()).thenAnswer((_) async => 5.0);

    // 3. Injetamos o controller de teste no Widget
    await tester.pumpWidget(MaterialApp(home: CurrencyScreen(controller: testController)));

    final inputFinder = find.byKey(const Key('input_field'));
    await tester.enterText(inputFinder, '10');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Converter'));

    // O pump() faz o Flutter processar a mudança de estado (setState)
    await tester.pump();

    // Agora com o prefixo BRL e as duas casas decimais que o toStringAsFixed(2) gera
    expect(find.text('Resultado: BRL 50.00'), findsOneWidget);
  });
}