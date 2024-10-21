import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketsDatasource {
  final _btcController = StreamController<String>.broadcast();
  late WebSocketChannel _channel;

  Stream<String> get btcStream => _btcController.stream;

  void getValueInBTC() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@trade'),
    );

    _channel.stream.listen((event) {
      final data = jsonDecode(event);
      final price = data['p'];
      _btcController.add(price);
    }, onError: (error) {
      _btcController.addError(error);
    });
  }

  void disconnect() {
    _channel.sink.close();
    _btcController.close();
  }
}
