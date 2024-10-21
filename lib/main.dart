import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/graphql/graphql_example.dart';
import 'package:flutter_application_1/presentation/semantics/semantics_screen.dart';
import 'package:flutter_application_1/presentation/websockets/websockets_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListOfExamples(),
    );
  }
}

class ListOfExamples extends StatelessWidget {
  const ListOfExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Examples')),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccessibilityScreen(),
                  ),
                ),
                child: const Text('Accessibility Widgets'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GraphQLExample(),
                    ),
                  );
                },
                child: const Text('GraphQL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Isolates'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Method Channel'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebSocketsExample(),
                  ),
                ),
                child: const Text('WebSockets'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
