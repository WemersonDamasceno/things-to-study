import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() async {
  // Garante que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Download Example',
      home: DownloadPage(),
    );
  }
}

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  String url =
      'https://cartographicperspectives.org/index.php/journal/article/download/cp47-issue/pdf/2446'; // URL do arquivo
  String savePath = ''; // Caminho para salvar o arquivo
  String statusMessage = 'Aguardando download...'; // Mensagem de status

  @override
  void initState() {
    super.initState();
    _initializeAndDownload();
  }

  Future<void> _initializeAndDownload() async {
    // Obtém o diretório temporário para salvar o arquivo
    Directory tempDir = await getTemporaryDirectory();
    savePath = '${tempDir.path}/largefile.zip'; // Define o caminho completo
    await downloadFile(url, savePath); // Inicia o download
  }

  Future<void> downloadFile(String url, String savePath) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
        _downloadInIsolate, [url, savePath, receivePort.sendPort]);

    // Escuta as mensagens do isolate
    await for (final message in receivePort) {
      if (message is String) {
        setState(() {
          statusMessage = message; // Atualiza a mensagem de status
        });
      } else if (message is List) {
        setState(() {
          statusMessage = 'Download completo: ${message[0]}';
        });
        receivePort.close(); // Fecha o ReceivePort
      }
    }
  }

  static void _downloadInIsolate(List<dynamic> args) async {
    final String url = args[0];
    final String savePath = args[1];
    final SendPort sendPort = args[2];

    // Inicia o download
    final response = await http.get(Uri.parse(url));
    final file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);

    // Envia mensagem de progresso ou finalização
    sendPort.send('Download em andamento...');
    sendPort.send([savePath]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download de Arquivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusMessage), // Exibe a mensagem de status
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _initializeAndDownload, // Botão para iniciar o download
              child: const Text('Reiniciar Download'),
            ),
          ],
        ),
      ),
    );
  }
}
