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
              borderRadius: 15.0,
              backgroundColor: Colors.blueAccent,
              onSuccess: (value) {
                debugPrint(value.toString());
              },
              child: const Text('Filled succes'),
            ),
            PendingButton(
              asynFunction: () {
                return futureFunction2(1, 1, 1, 1, 1, 1, 1, 1, 1);
              },
              width: 200,
              // height: 50,
              child: const Text('Filled with args'),
            ),
            const SizedBox(height: 10),
            PendingButton(
              asynFunction: futureErrorFunction,
              child: const Text('Short'),
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
              asynFunction: futureErrorFunction,
              child: const Text('Oulined Success'),
            ),
            const SizedBox(height: 10),
            PendingButton.text(
              asynFunction: futureFunction,
              child: const Text('Text success'),
            ),
            const SizedBox(height: 10),
            PendingButton.text(
              asynFunction: futureErrorFunction,
              child: const Text('wrong password'),
            ),
            const SizedBox(height: 10),
            PendingButton.icon(
              asynFunction: futureFunction,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            PendingButton.icon(
              asynFunction: myFunction,
              onError: (Exception error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ),
                );
              },
              onSuccess: (result) {},
              child: const Icon(Icons.delete),
            ),
            PendingButton.icon(
              asynFunction: () {
                debugPrint('hello');
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> futureFunction() =>
      Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          return true;
        },
      );
  Future<bool> futureFunction2(int text1, int text2, int text3, int text4,
          int text5, int text6, int text7, int text8, int text9) =>
      Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          throw const Failures(message: 'Authentification fail');
        },
      );
  Future<void> futureErrorFunction() =>
      Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          throw const Failures(message: 'Authentification fail');
        },
      );
  Future<void> myFunction() => Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          throw Exception('Authentification fail');
        },
      );
}

class Failures implements Exception {
  final String message;
  const Failures({required this.message});
}
