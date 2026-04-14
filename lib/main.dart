import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'controllers/currency_controller.dart';
import 'services/currency_service.dart';

void main() {
  final apiClient = http.Client();
  final service = CurrencyService(apiClient);
  final controller = CurrencyController(service);

  runApp(CurrencyMasterApp(controller: controller));
}

class CurrencyMasterApp extends StatelessWidget {
  final CurrencyController controller;
  const CurrencyMasterApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark, // Ativa o modo escuro para combinar com o seu BG
      ),
      home: CurrencyScreen(controller: controller),
    );
  }
}

class CurrencyScreen extends StatefulWidget {
  final CurrencyController controller;
  const CurrencyScreen({super.key, required this.controller});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final textController = TextEditingController();
  String result = "0.00";

  @override
  void initState() {
    super.initState();
    _loadRate();
  }

  void _loadRate() async {
    await widget.controller.updateRate();
    if (mounted) setState(() {});
  }

  void _convert() {
    setState(() {
      result = widget.controller.convert(textController.text).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F35),
      appBar: AppBar(
        title: const Text('Currency Master', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de Exibição da Taxa
            Card(
              elevation: 0,
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Cotação Atual (USD → BRL)', 
                      style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${widget.controller.exchangeRate.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold, 
                        color: colorScheme.onPrimaryContainer
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Campo de Input
            TextField(
              key: const Key('input_field'),
              controller: textController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Valor em Dólar (USD)',
                labelStyle: const TextStyle(color: Colors.white70), // Garante visibilidade
                floatingLabelBehavior: FloatingLabelBehavior.always, // Evita cortar o texto
                prefixIcon: const Icon(Icons.attach_money, color: Colors.deepPurpleAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05), // Fundo sutil para o input
              ),
              onChanged: (_) => _convert(),
            ),
            
            const SizedBox(height: 32),

            // Card de Resultado
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text('VALOR CONVERTIDO', 
                    style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  FittedBox(
                    child: Text(
                      'R\$ $result',
                      key: const Key('result_text'),
                      style: const TextStyle(
                        fontSize: 48, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            TextButton.icon(
              onPressed: _loadRate,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar Cotação'),
            ),
          ],
        ),
      ),
    );
  }
}