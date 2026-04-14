import 'package:flutter/material.dart';
import 'controllers/currency_controller.dart';

void main() => runApp(const CurrencyMasterApp());

class CurrencyMasterApp extends StatelessWidget {
  const CurrencyMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CurrencyScreen(),
    );
  }
}

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final controller = CurrencyController();
  final textController = TextEditingController();
  String result = "0.0";

  void _convert() {
    setState(() {
      result = controller.convert(textController.text).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Master')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('input_field'), // Chave importante para o teste!
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor em USD'),
            ),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Converter'),
            ),
            const SizedBox(height: 20),
            Text('Resultado: $result', key: const Key('result_text')),
          ],
        ),
      ),
    );
  }
}