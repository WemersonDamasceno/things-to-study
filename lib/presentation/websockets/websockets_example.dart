import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:things_to_study/data/web_sockets/web_sockets_datasource.dart';

class WebSocketsExample extends StatefulWidget {
  const WebSocketsExample({super.key});

  @override
  State<WebSocketsExample> createState() => _WebSocketsExampleState();
}

class _WebSocketsExampleState extends State<WebSocketsExample> {
  final _webSocketsDatasource = WebSocketsDatasource();

  @override
  void initState() {
    super.initState();

    _webSocketsDatasource.getValueInBTC();
  }

  @override
  void dispose() {
    _webSocketsDatasource.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSockets'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BTC/USDT Price',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<String>(
                stream: _webSocketsDatasource.btcStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      'BTC: \$${_convertToDollar(snapshot.data!)}',
                      style: const TextStyle(fontSize: 24),
                    );
                  } else {
                    return const Text('Sem dados disponíveis');
                  }
                }),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  _convertToDollar(String value) {
    // Converte a string para double
    double valueDouble = double.parse(value);

    // Formata para moeda em dólar (USD)
    final formatter =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 6);
    String valueConverted = formatter.format(valueDouble);

    return valueConverted;
  }
}
