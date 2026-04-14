import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_master/main.dart';
import 'package:currency_master/controllers/currency_controller.dart';
import 'package:currency_master/services/currency_service.dart';

class MockCurrencyService extends Mock implements CurrencyService {}

void main() {
  testWidgets('Deve atualizar o resultado quando o botão for clicado', (WidgetTester tester) async {
    // Criando o mock e o controller de teste
    final mockService = MockCurrencyService();
    final testController = CurrencyController(mockService);
    
    // Simulando que a taxa já foi carregada para não dar erro no initState
    testController.exchangeRate = 5.0; 
    // Treinando o mock para não estourar exceção quando o initState chamar ele
    when(() => mockService.fetchExchangeRate()).thenAnswer((_) async => 5.0);

    // Injetando o controller de teste no Widget
    await tester.pumpWidget(MaterialApp(home: CurrencyScreen(controller: testController)));

    final inputFinder = find.byKey(const Key('input_field'));
    await tester.enterText(inputFinder, '10');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Converter'));

    await tester.pump();

    expect(find.text('Resultado: BRL 50.00'), findsOneWidget);
  });
}