import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_master/main.dart';
import 'package:currency_master/controllers/currency_controller.dart';
import 'package:currency_master/services/currency_service.dart';

class MockCurrencyService extends Mock implements CurrencyService {}

void main() {
  testWidgets('Deve atualizar o resultado automaticamente ao digitar', (WidgetTester tester) async {
    final mockService = MockCurrencyService();
    final testController = CurrencyController(mockService);
    
    testController.exchangeRate = 5.0; 
    when(() => mockService.fetchExchangeRate()).thenAnswer((_) async => 5.0);

    await tester.pumpWidget(MaterialApp(home: CurrencyScreen(controller: testController)));

    // Encontra o campo e digita "10"
    final inputFinder = find.byKey(const Key('input_field'));
    await tester.enterText(inputFinder, '10');

    // O pump() aqui é para o Flutter processar o onChange e o setState
    await tester.pump();

    // Verifica o resultado
    expect(find.text('R\$ 50.00'), findsOneWidget);
  });
}