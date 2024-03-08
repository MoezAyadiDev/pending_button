import 'package:flutter/material.dart';
import 'package:pending_button/pending_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pending Button Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending button'),
      ),
      body: Center(
        child: Column(
          children: [
            PendingButton(
              asynFunction: futureFunction,
              width: 200,
              // height: 50,
              child: const Text('Hello'),
            ),
            PendingButton(
              asynFunction: futureFunction,
              width: 200,
              animationDuration: const Duration(seconds: 3),
              // height: 50,
              child: const Text('Hello'),
            ),
            const SizedBox(height: 10),
            PendingButton(
              asynFunction: futureErrorFunction,
              child: const Text('Hello error'),
              // width: 200,
              // height: 50,
            ),
            const SizedBox(height: 10),
            PendingButton.outlined(
              asynFunction: futureErrorFunction,
              child: const Text('Oulined error'),
            ),
            const SizedBox(height: 10),
            PendingButton.outlined(
              asynFunction: futureFunction,
              child: const Text('Oulined button'),
            ),
            const SizedBox(height: 10),
            PendingButton.text(
              asynFunction: futureFunction,
              child: const Text('Text button'),
            ),
            const SizedBox(height: 10),
            PendingButton.text(
              asynFunction: futureErrorFunction,
              child: const Text('Text error'),
            ),
            const SizedBox(height: 10),
            PendingButton.icon(
              asynFunction: futureFunction,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            PendingButton.icon(
              asynFunction: futureErrorFunction,
              animationDuration: const Duration(seconds: 3),
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> futureFunction() =>
      Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          debugPrint('Function handled');
        },
      );
  Future<void> futureErrorFunction() =>
      Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          throw Exception('Error');
        },
      );
}
