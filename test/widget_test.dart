import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_master/main.dart';

void main() {
  testWidgets('Deve atualizar o resultado quando o botão for clicado', (WidgetTester tester) async {
    // 1. Carrega o widget no ambiente de teste
    await tester.pumpWidget(const CurrencyMasterApp());

    // 2. Encontra o campo de texto e digita "10"
    final inputFinder = find.byKey(const Key('input_field'));
    await tester.enterText(inputFinder, '10');

    // 3. Encontra o botão e clica nele
    final buttonFinder = find.widgetWithText(ElevatedButton, 'Converter');
    await tester.tap(buttonFinder);

    // 4. "Rebuilda" o widget após a ação (como o setState)
    await tester.pump();

    // 5. Verifica se o texto de resultado mudou para 50.0 (taxa fixa do controller)
    expect(find.text('Resultado: 50.0'), findsOneWidget);
  });
}